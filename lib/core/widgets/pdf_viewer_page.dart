import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../generated/l10n.dart';

class PdfViewerWidget extends StatelessWidget {
  const PdfViewerWidget({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleText: S.of(context).packageDetails,
      ),
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
