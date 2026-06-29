import 'package:flutter/material.dart';

import '../../../../core/strings/enum_manager.dart';
import '../pages/docx_viewer_page.dart';
import '../pages/h5p_viwer_page.dart';
import '../pages/html_viewer_page.dart';
import '../pages/image_viewer_page.dart';
import '../pages/pdf_viewer_page.dart';
import '../pages/text_viewer_page.dart';



class MediaWidgetByUrl extends StatelessWidget {
  const MediaWidgetByUrl({super.key, required this.resourceUrl, required this.mediaType});

  final String resourceUrl;
  final ResourceType mediaType;

  @override
  Widget build(BuildContext context) {
    switch (mediaType) {
      case .pdf:
        return PdfViewerWidget(url: resourceUrl);
      case .html:
        return HtmlViewerWidget(url: resourceUrl);
      case .txt:
        return TextViewerWidget(url: resourceUrl);
      case .mp4:
      case .jpeg:
        return ImageViewerWidget(url: resourceUrl);
      case .pptx:
      case .docx:
      case .xlsx:
        return DocxViewerPage(url: resourceUrl);
      case .h5p:
        return H5PViewerPage(url: resourceUrl);
    }
  }
}
