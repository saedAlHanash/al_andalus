import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'document_scanner_widget.dart';

class DocumentScannerPage extends StatelessWidget {
  final Function(String croppedImagePath, Uint8List croppedImageBytes)? onDocumentCaptured;

  const DocumentScannerPage({
    super.key,
    this.onDocumentCaptured,
  });

  @override
  Widget build(BuildContext context) {
    return DocumentScannerWidget(
      onCapture: (croppedImagePath, croppedImageBytes) {
        if (onDocumentCaptured != null) {
          onDocumentCaptured!(croppedImagePath, croppedImageBytes);
        }
        Navigator.pop(context, croppedImagePath);
      },
    );
  }
}
