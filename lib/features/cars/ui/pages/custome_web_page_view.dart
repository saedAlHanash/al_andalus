import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';

var _isSusses = false;
final _successUrls = [
  'success',
  'payment-success',
  'status=success',
];
//'https://admin.andalusapp.com/qicard/callback?requestId=bf0ff5a5-fc2d-4779-aa33-96efc37fa973&paymentId=2281565f-ddb5-4b0a-b712-ea714a074c97&paymentType=CARD&status=SUCCESS',

class MyCustomWebPage extends StatefulWidget {
  const MyCustomWebPage({super.key, this.urlWebPage});

  final String? urlWebPage;

  @override
  State<MyCustomWebPage> createState() => _MyCustomWebPageState();
}

class _MyCustomWebPageState extends State<MyCustomWebPage> {
  InAppWebViewController? webView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(titleText: S.of(context).payment),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse(widget.urlWebPage ?? '')),
        ),
        onWebViewCreated: (controller) {
          webView = controller;
        },
        onLoadStart: (controller, url) {
          final currentUrl = (url?.uriValue.toString() ?? '').toLowerCase();

          if (_successUrls.any((pattern) => currentUrl.contains(pattern))) {
            _isSusses = true;
          }

          if (currentUrl.contains('status=success') ||
              currentUrl.contains('admin.andalusapp.com/qicard/callback') ||
              currentUrl.contains('admin.andalusapp.com/zaincash/callback')) {
            _isSusses = true;
            context.pop(_isSusses);
          }
        },
        onReceivedServerTrustAuthRequest: (controller, challenge) async {
          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
        },
      ),
    );
  }
}
