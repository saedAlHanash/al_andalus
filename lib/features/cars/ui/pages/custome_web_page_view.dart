import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';

var _isSusses = false;
final _successUrls = [
  'success',
  'callback',
  'qicard/callback',
  'zaincash/callback',
  'payment-success',
  'status=success',
];

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
