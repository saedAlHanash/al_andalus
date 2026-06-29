import 'package:flutter/material.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/widgets/app_bar/app_bar_widget.dart';

class DocxViewerPage extends StatefulWidget {
  const DocxViewerPage({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  State<DocxViewerPage> createState() => _DocxViewerPageState();
}

class _DocxViewerPageState extends State<DocxViewerPage> with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    final viewerUrl = 'https://view.officeapps.live.com/op/embed.aspx?src=${widget.url}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setBackgroundColor(Colors.transparent)
      ..loadRequest(
        Uri.parse(viewerUrl),
        headers: {
          'Cache-Control': 'max-age=86400', // يوم كامل
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(viewerUrl));
  }

  void _reload() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(titleText: widget.title, zeroHeight: widget.title.isBlank),
      body: Stack(
        children: [
          /// WebView
          AnimatedOpacity(
            opacity: _isLoading ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: WebViewWidget(controller: _controller),
          ),

          /// Loading
          if (_isLoading && !_hasError)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('يتم تحميل الملف'),
                ],
              ),
            ),

          /// Error / Retry
          if (_hasError)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 48),
                  const SizedBox(height: 12),
                  Text('خطا في التحميل'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reload,
                    child: Text('إعادة المحاولة '),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
