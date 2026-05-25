import 'package:flutter/material.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/widgets/app_bar/app_bar_widget.dart';

class HtmlViewerWidget extends StatefulWidget {
  const HtmlViewerWidget({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  State<HtmlViewerWidget> createState() => _HtmlViewerWidgetState();
}

class _HtmlViewerWidgetState extends State<HtmlViewerWidget> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(titleText: widget.title, zeroHeight: widget.title.isBlank),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
