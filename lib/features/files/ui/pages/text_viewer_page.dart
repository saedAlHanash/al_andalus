import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:m_cubit/util.dart';

import '../../../../core/widgets/app_bar/app_bar_widget.dart';

class TextViewerWidget extends StatelessWidget {
  const TextViewerWidget({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(titleText: title, zeroHeight: title.isBlank),
      body: DrawableText(text: url),
    );
  }
}
