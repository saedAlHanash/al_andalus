import 'dart:io';

import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/error/error_manager.dart';
import 'package:al_andalus/core/util/checker_helper.dart';
import 'package:al_andalus/services/app_info_service.dart';
import 'package:al_andalus/services/firebase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:m_cubit/caching_service/caching_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app/app_widget.dart';
import 'core/injection/injection_container.dart' as di;
import 'core/util/shared_preferences.dart';
import 'features/home/bloc/home_cubit/home_cubit.dart';
import 'features/notification/bloc/notification_count_cubit/notification_count_cubit.dart';
import 'package:intl/date_symbol_data_local.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  try {
    await di.init();

    await SharedPreferences.getInstance().then((value) {
      AppSharedPreference.init(value);
    });

    appData = await PackageInfo.fromPlatform();

    await CachingService.initial(
      onError: (second) {
        showErrorFromApi(second);
      },
      version: 3,
      supperFilter: AppProvider.supperFilter,
      timeInterval: 60,
    );

    if (!kIsWeb) {
      await FirebaseService.initial();

      FirebaseService.saveFCM();
    }

    await Note.initialize();

    await AppInfoService.initial();
  } catch (e) {
    loggerObject.e(e);
  }
  if (kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<NotificationCountCubit>()),
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}

class Note {
  static Future initialize() async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(settings: initializationsSettings);
  }

  static Future showBigTextNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
  }) async {
    // var vibrationPattern = Int64List(2);
    // vibrationPattern[0] = 1000;
    // vibrationPattern[1] = 1000;

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'al_andalus',
      'al_andalus App',
      playSound: true,
      // enableVibration: true,
      // sound: RawResourceAndroidNotificationSound('sound'),
      // vibrationPattern: vibrationPattern,
      importance: Importance.defaultImportance,
      priority: Priority.high,
    );

    var not = const NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id: (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      title: title,
      body: body,
      notificationDetails: not,
    );
  }
}

class ProductColor {
  ProductColor({
    required this.id,
    required this.name,
    required this.quantity,
    required this.colors,
    required this.description,
    required this.price,
    required this.priceAfter,
    required this.isOffer,
    required this.images,
    required this.category,
  });

  final int id;
  final String name;
  final num quantity;
  final List<Color> colors;
  final String description;
  final num price;
  final dynamic priceAfter;
  final bool isOffer;
  final List<String> images;
  final Category? category;

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      quantity: json["quantity"] ?? 0,
      colors: json["colors"] == null ? [] : List<Color>.from(json["colors"]!.map((x) => Color.fromJson(x))),
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      priceAfter: json["price_after"],
      isOffer: json["is_offer"] ?? false,
      images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
      category: json["category"] == null ? null : Category.fromJson(json["category"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "quantity": quantity,
    "colors": colors.map((x) => x?.toJson()).toList(),
    "description": description,
    "price": price,
    "price_after": priceAfter,
    "is_offer": isOffer,
    "images": images.map((x) => x).toList(),
    "category": category?.toJson(),
  };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  final int id;
  final String name;
  final String image;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}

class Color {
  Color({
    required this.id,
    required this.name,
    required this.hex,
  });

  final int id;
  final String name;
  final String hex;

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      hex: json["hex"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "hex": hex,
  };
}
