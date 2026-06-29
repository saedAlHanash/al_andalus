import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/features/files/ui/widget/media_widget.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../../../generated/l10n.dart';

class PdfViewerWidget extends StatelessWidget {
  const PdfViewerWidget({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(titleText: title),
      body: Builder(
        builder: (context) {
          if (url.isEmpty) {
            return Center(child: DrawableText(text: S.of(context).theRequestedInformationIsNotCurrentlyAvailable));
          }
          return const PDF(
            swipeHorizontal: false,
          ).cachedFromUrl(url);
        },
      ),
    );
  }
}

class MediaTypePage extends StatelessWidget {
  const MediaTypePage({super.key, required this.url, this.title, required this.mediaType});

  final String url;
  final String? title;
  final ResourceType mediaType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarWidget(titleText: title),
      body: Builder(
        builder: (context) {
          if (url.isEmpty) {
            return Center(child: DrawableText(text: S.of(context).theRequestedInformationIsNotCurrentlyAvailable));
          }
          return MediaWidgetByUrl(resourceUrl: url, mediaType: mediaType,title: title);
        },
      ),
    );
  }
}
