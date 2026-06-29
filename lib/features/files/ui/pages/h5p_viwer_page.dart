import 'package:flutter/material.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

// تأكد من المسار الصحيح للـ AppBarWidget الخاص بك
import '../../../../core/widgets/app_bar/app_bar_widget.dart';

class H5PViewerPage extends StatefulWidget {
  const H5PViewerPage({super.key, required this.url, this.title});

  final String url; // رابط الـ Embed الخاص بـ H5P
  final String? title;

  @override
  State<H5PViewerPage> createState() => _H5PViewerPageState();
}

class _H5PViewerPageState extends State<H5PViewerPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  double _loadingProgress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent) // لجعل خلفية الـ WebView متوافقة مع خلفية التطبيق
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() => _loadingProgress = progress / 100);
          },
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
            // اختياري: إخفاء عناصر واجهة المستخدم غير الضرورية في H5P (مثل الـ Footer) عبر JS
            _controller.runJavaScript(
              "document.getElementsByClassName('h5p-content-controls')[0].style.display='none';",
            );
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      )
      ..addJavaScriptChannel(
        'H5PTracker',
        onMessageReceived: (message) {
          // هنا تستقبل النتائج إذا كان الـ H5P يرسل بيانات xAPI
          debugPrint("H5P Event: ${message.message}");
        },
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _reload() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _loadingProgress = 0;
    });
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    // نستخدم Scaffold بملف شفاف ليظهر الـ Pattern الذي وضعناه في الـ builder
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarWidget(titleText: widget.title, zeroHeight: widget.title.isBlank),
      body: Stack(
        children: [
          /// عرض المحتوى مع تأثير ظهور ناعم
          AnimatedOpacity(
            opacity: _isLoading ? 0 : 1,
            duration: const Duration(milliseconds: 500),
            child: WebViewWidget(controller: _controller),
          ),

          /// مؤشر التحميل العصري (Linear Progress) في أعلى الشاشة
          if (_isLoading && !_hasError)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _loadingProgress > 0 ? _loadingProgress : null,
                backgroundColor: Colors.transparent,
                color: Theme.of(context).primaryColor,
                minHeight: 3,
              ),
            ),

          /// واجهة انتظار بتصميم لطيف
          if (_isLoading && !_hasError)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(strokeWidth: 2),
                  const SizedBox(height: 16),
                  Text( 'preparingInteractiveContent',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),

          /// واجهة الخطأ
          if (_hasError) _buildErrorWidget(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text( 'failedToLoadInteractiveContent',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text( 'checkInternetConnection',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh),
              label: Text( 'retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
