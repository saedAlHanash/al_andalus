import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../generated/l10n.dart';
import '../strings/app_color_manager.dart';
import 'my_button.dart';

class DocumentScannerWidget extends StatefulWidget {
  final Function(String croppedImagePath, Uint8List croppedImageBytes) onCapture;

  const DocumentScannerWidget({
    super.key,
    required this.onCapture,
  });

  @override
  State<DocumentScannerWidget> createState() => _DocumentScannerWidgetState();
}

class _DocumentScannerWidgetState extends State<DocumentScannerWidget> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  bool _isPermissionGranted = false;
  bool _isInitializing = true;
  bool _isProcessing = false;
  int _selectedCameraIndex = 0;
  String? _croppedImagePath;
  Uint8List? _croppedImageBytes;

  // Custom frame state
  double? _rectWidth;
  double? _rectHeight;
  Offset? _rectCenter;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndInitCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _checkPermissionAndInitCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      if (mounted) {
        setState(() {
          _isPermissionGranted = true;
        });
      }
      await _initializeCamera();
    } else {
      if (mounted) {
        setState(() {
          _isPermissionGranted = false;
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _isInitializing = false;
          });
        }
        return;
      }

      int backCameraIndex = _cameras.indexWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );
      if (backCameraIndex != -1) {
        _selectedCameraIndex = backCameraIndex;
      }

      await _setupCameraController();
    } catch (e) {
      debugPrint("Error availableCameras: $e");
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _setupCameraController() async {
    if (_cameras.isEmpty) return;

    setState(() {
      _isInitializing = true;
    });

    if (_controller != null) {
      await _controller!.dispose();
    }

    final camera = _cameras[_selectedCameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high, // max is overkill and very slow to decode
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      try {
        await _controller!.setFlashMode(FlashMode.off);
      } catch (_) {}
    } catch (e) {
      debugPrint("Camera initialize error: $e");
    }

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _setupCameraController();
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final currentMode = _controller!.value.flashMode;
    FlashMode nextMode = currentMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    try {
      await _controller!.setFlashMode(nextMode);
      setState(() {});
    } catch (e) {
      debugPrint("Toggle flash error: $e");
    }
  }

  /// Runs entirely in a background isolate via [compute].
  static Future<Uint8List> _cropIsolate(_CropParams p) async {
    img.Image? original = img.decodeImage(p.bytes);
    if (original == null) throw Exception('Failed to decode image');

    original = img.bakeOrientation(original);

    final double scale = math.max(p.screenWidth / original.width, p.screenHeight / original.height);
    final double offsetX = (p.screenWidth - original.width * scale) / 2;
    final double offsetY = (p.screenHeight - original.height * scale) / 2;

    final int x = ((p.frameLeft - offsetX) / scale).round().clamp(0, original.width - 1);
    final int y = ((p.frameTop - offsetY) / scale).round().clamp(0, original.height - 1);
    final int w = (p.frameWidth / scale).round().clamp(1, original.width - x);
    final int h = (p.frameHeight / scale).round().clamp(1, original.height - y);

    final img.Image cropped = img.copyCrop(original, x: x, y: y, width: w, height: h);
    return Uint8List.fromList(img.encodeJpg(cropped, quality: 85));
  }

  Future<void> _captureAndProcess(Rect frameRect, Size screenSize) async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final XFile photo = await _controller!.takePicture();
      final Uint8List rawBytes = await photo.readAsBytes();

      // Heavy decode+crop+encode runs in background isolate — UI stays smooth
      final Uint8List croppedBytes = await compute(
        _cropIsolate,
        _CropParams(
          bytes: rawBytes,
          screenWidth: screenSize.width,
          screenHeight: screenSize.height,
          frameLeft: frameRect.left,
          frameTop: frameRect.top,
          frameWidth: frameRect.width,
          frameHeight: frameRect.height,
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final String croppedPath = '${tempDir.path}/cropped_doc_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(croppedPath).writeAsBytes(croppedBytes, flush: true);

      setState(() {
        _croppedImagePath = croppedPath;
        _croppedImageBytes = croppedBytes;
        _isProcessing = false;
      });
    } catch (e) {
      debugPrint('Capture and process error: $e');
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: DrawableText(text: S.of(context).oops),
            backgroundColor: AppColorManager.red,
          ),
        );
      }
    }
  }

  void _retake() => setState(() {
    _croppedImagePath = null;
    _croppedImageBytes = null;
  });

  @override
  Widget build(BuildContext context) {
    if (!_isPermissionGranted && !_isInitializing) {
      return Scaffold(
        backgroundColor: AppColorManager.mainColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 80.r, color: Colors.white70),
                20.verticalSpace,
                DrawableText(
                  text: S.of(context).cameraPermissionRequired,
                  size: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,

                  textAlign: TextAlign.center,
                ),
                10.verticalSpace,
                MyButton(text: S.of(context).grantPermission, onTap: _checkPermissionAndInitCamera),
              ],
            ),
          ),
        ),
      );
    }

    if (_isInitializing) {
      return Scaffold(
        backgroundColor: AppColorManager.mainColor,
        body: const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
      );
    }

    final Size screenSize = MediaQuery.of(context).size;
    _rectWidth ??= screenSize.width * 0.85;
    _rectHeight ??= _rectWidth! / 1.2;
    _rectCenter ??= Offset(screenSize.width / 2, screenSize.height / 2);

    final Rect frameRect = Rect.fromCenter(
      center: _rectCenter!,
      width: _rectWidth!,
      height: _rectHeight!,
    );

    if (_croppedImagePath != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: _retake,
          ),
          title: DrawableText(text: S.of(context).documentPreview, color: Colors.white),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0).r,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0).r,
                      child: Image.file(File(_croppedImagePath!), fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 24.0.w, right: 24.0.w, bottom: 40.0.h, top: 20.0.h),
              color: AppColorManager.mainColor,
              child: Row(
                children: [
                  Expanded(
                    child: MyButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      text: S.of(context).retake,
                      onTap: _retake,
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: OutLineButton(
                      color: Colors.white,
                      textColor: Colors.white,
                      text: S.of(context).confirm,
                      onTap: () => widget.onCapture(_croppedImagePath!, _croppedImageBytes!),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            ClipRect(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.previewSize!.height,
                    height: _controller!.value.previewSize!.width,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          CustomPaint(
            painter: ScannerOverlayPainter(
              scanWindow: frameRect,
              context: context,
              instructionText: S.of(context).placeIdInsideFrame,
            ),
            child: Container(),
          ),

          // Draggable corners for resizing
          Positioned.fromRect(
            rect: frameRect.inflate(20),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _rectWidth = (_rectWidth! + details.delta.dx * 2).clamp(100.0, screenSize.width * 0.95);
                  _rectHeight = (_rectHeight! + details.delta.dy * 2).clamp(100.0, screenSize.height * 0.6);
                });
              },
              child: Container(color: Colors.transparent),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: .spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller?.value.flashMode == FlashMode.torch ? Icons.flash_on : Icons.flash_off,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _isProcessing ? null : _toggleFlash,
                          ),
                          10.horizontalSpace,
                          IconButton(
                            icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 28),
                            onPressed: _isProcessing ? null : _toggleCamera,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: GestureDetector(
                    onTap: _isProcessing ? null : () => _captureAndProcess(frameRect, screenSize),
                    child: AnimatedOpacity(
                      opacity: _isProcessing ? 0.3 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        height: 80.r,
                        width: 80.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Full-screen processing overlay — shown while background isolate is working
          if (_isProcessing)
            Positioned.fill(
              child: IgnorePointer(
                // blocks all touches
                ignoring: false,
                child: Container(
                  color: Colors.black.withOpacity(0.55),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      DrawableText(
                        text: S.of(context).processingImage,
                        color: Colors.white,
                        size: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Parameter bag for [_DocumentScannerWidgetState._cropIsolate].
/// Must be a plain class (no Flutter objects) to cross isolate boundaries.
class _CropParams {
  final Uint8List bytes;
  final double screenWidth;
  final double screenHeight;
  final double frameLeft;
  final double frameTop;
  final double frameWidth;
  final double frameHeight;

  const _CropParams({
    required this.bytes,
    required this.screenWidth,
    required this.screenHeight,
    required this.frameLeft,
    required this.frameTop,
    required this.frameWidth,
    required this.frameHeight,
  });
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  final String instructionText;
  final BuildContext context;

  ScannerOverlayPainter({
    required this.scanWindow,
    required this.instructionText,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(16.0)));

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.65)
      ..style = PaintingStyle.fill;
    canvas.drawPath(Path.combine(PathOperation.difference, backgroundPath, cutoutPath), backgroundPaint);

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(16.0)), borderPaint);

    // Draw resize handles (corners)
    final handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    const double handleSize = 20.0;

    // Bottom Right handle
    canvas.drawCircle(scanWindow.bottomRight, 8.0, handlePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: instructionText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: size.width - 40);

    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, scanWindow.bottom + 30.0));
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) =>
      oldDelegate.scanWindow != scanWindow || oldDelegate.instructionText != instructionText;
}
