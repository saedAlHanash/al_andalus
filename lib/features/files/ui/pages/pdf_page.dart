// import 'package:drawable_text/drawable_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
//
// import '../../../../core/widgets/app_bar/app_bar_widget.dart';
//
// class PdfPage extends StatelessWidget {
//   const PdfPage({super.key, required this.url,  this.header});
//
//   final String url;
//   final String? header;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarWidget(titleText: header),
//       body: Builder(builder: (context) {
//         if (url.isEmpty) {
//           return const Center(child: DrawableText(text: S.of(context).error));
//         }
//         return const PDF(
//           swipeHorizontal: false,
//         ).cachedFromUrl(url);
//       }),
//     );
//   }
// }
