import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:m_cubit/m_cubit.dart';

import '../strings/enum_manager.dart';
import '../util/shared_preferences.dart';
import 'helpers_api/helper_api_service.dart';
import 'helpers_api/log_api.dart';

var loggerObject = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    // number of method calls to be displayed
    errorMethodCount: 0,
    // number of method calls if stacktrace is provided
    lineLength: 300,
    // width of the output
    colors: true,
    // Colorful log messages
    printEmojis: false,
    // Print an emoji for each log message
    printTime: false,
  ),
);

class APIService {
  static final APIService _singleton = APIService._internal();

  APIService._internal() {
    Timer.periodic(
      Duration(seconds: 30),
      (t) => serverTime = serverTime.addFromNow(second: 30),
    );
  }

  DateTime serverTime = DateTime.now().toUtc();

  factory APIService() => _singleton;

  Map<String, String> get innerHeader => {
    'Content-Type': 'application/json',
    'Accept': 'Application/json',
    'lang': AppSharedPreference.getLocal,
    'Authorization': 'Bearer ${AppSharedPreference.getToken}',
  };

  Future<http.Response> callApi({
    required String url,
    required ApiType type,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? header,
    String? path,
    String? hostName,
    String? additional,
  }) async {
    // if (!await network.isConnected) noInternet;

    final uri = getUri(
      url: url,
      additional: additional,
      hostName: hostName,
      query: query ?? {},
      path: path,
      body: body,
      type: type,
    );
    try {
      late final http.Response response;

      switch (type) {
        case ApiType.get:
          response = await http
              .get(uri, headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
        case ApiType.post:
          response = await http
              .post(uri, body: jsonEncode(body), headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
        case ApiType.put:
          response = await http
              .put(uri, body: jsonEncode(body), headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
        case ApiType.patch:
          response = await http
              .patch(uri, body: jsonEncode(body), headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
        case ApiType.delete:
          response = await http
              .delete(uri, body: jsonEncode(body), headers: (header ?? innerHeader))
              .timeout(connectionTimeOut, onTimeout: () => timeOut);
      }

      logResponse(url: url, response: response, type: type);
      serverTime = response.serverTime;
      return response;
    } catch (e) {
      loggerObject.e(e);
      return noInternet;
    }
  }

  Future<http.Response> uploadMultiPart({
    required String url,
    String? path,
    String type = 'POST',
    List<UploadFile?>? files,
    Map<String, dynamic>? fields,
  }) async {
    final uri = getUri(url: url, query: fields ?? {}, path: path, type: ApiType.post);

    var request = http.MultipartRequest(type, uri);

    for (var uploadFile in (files ?? <UploadFile?>[])) {
      if (uploadFile?.fileBytes == null) continue;

      final multipartFile = http.MultipartFile.fromBytes(
        uploadFile!.nameField,
        uploadFile.fileBytes!,
        filename: '${getRandomString(10)}.jpg',
      );

      request.files.add(multipartFile);
    }

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers.addAll(innerHeader);
    request.fields.addAll(fixFields(fields));

    final stream = await request.send().timeout(
      const Duration(seconds: 40),
      onTimeout: () => http.StreamedResponse(Stream.value([]), 481),
    );

    final response = await http.Response.fromStream(stream);

    logResponse(url: url, response: response, type: ApiType.post);

    return response;
  }
}

class UploadFile {
  UploadFile({
    this.fileBytes,
    this.nameField = 'File',
    this.localId,
    this.extension,
    this.fileType = FileType.other, // تأكد أن FileType معرف لديك كـ Enum
  });

  Uint8List? fileBytes;
  String nameField;
  FileType fileType;
  String? localId;
  String? extension;

  // الإصلاح هنا: إضافة جميع الحقول لضمان عدم ضياع البيانات عند النسخ
  UploadFile copyWith({
    Uint8List? fileBytes,
    String? nameField,
    FileType? fileType,
    String? localId,
    String? extension,
  }) {
    return UploadFile(
      fileBytes: fileBytes ?? this.fileBytes,
      nameField: nameField ?? this.nameField,
      fileType: fileType ?? this.fileType,
      localId: localId ?? this.localId,
      extension: extension ?? this.extension,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileBytes': fileBytes?.toList(), // يفضل تحويله لـ List عند التحويل لـ JSON
      'nameField': nameField,
      'localId': localId,
      'extension': extension,
      'fileType': fileType.name, // أو حسب طريقة تخزينك للـ Enum
    };
  }

  factory UploadFile.fromJson(Map<String, dynamic> map) {
    return UploadFile(
      fileBytes: map['fileBytes'] != null ? Uint8List.fromList(List<int>.from(map['fileBytes'])) : null,
      nameField: map['nameField'] ?? 'File',
      localId: map['localId'],
      extension: map['extension'],
      // تأكد من طريقة استرجاع الـ Enum من الـ JSON
    );
  }
}