import 'package:flutter/material.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/widgets/app_bar/app_bar_widget.dart';

class ImageViewerWidget extends StatelessWidget {
  const ImageViewerWidget({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarWidget(titleText: title, zeroHeight: title.isBlank),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          constrained: true,
          scaleEnabled: true,
          minScale: 0.1,
          maxScale: 4.0,

          child: ImageMultiType(
            url: url,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
