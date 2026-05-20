import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../generated/l10n.dart';
import '../strings/app_color_manager.dart';
import '../util/shared_preferences.dart';
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

class _DocumentScannerWidgetState extends State<DocumentScannerWidget>
    with SingleTickerProviderStateMixin {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  bool _isPermissionGranted = false;
  bool _isInitializing = true;
  bool _isProcessing = false;
  int _selectedCameraIndex = 0;
  String? _croppedImagePath;
  Uint8List? _croppedImageBytes;

  // Animation for the pulsing scan line
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndInitCamera();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
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

      // Default to back camera
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
      ResolutionPreset.max, // Max resolution to ensure high-quality crops
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      // Set flash mode to auto by default if possible
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
    FlashMode nextMode;
    if (currentMode == FlashMode.off) {
      nextMode = FlashMode.torch;
    } else {
      nextMode = FlashMode.off;
    }
    try {
      await _controller!.setFlashMode(nextMode);
      setState(() {});
    } catch (e) {
      debugPrint("Toggle flash error: $e");
    }
  }

  // Crop image in a background thread or standard async operation
  Future<String> _cropImage(
      XFile photo, Rect frameRect, Size screenSize) async {
    final Uint8List bytes = await photo.readAsBytes();

    // Decode and bake Exif orientation
    img.Image? original = img.decodeImage(bytes);
    if (original == null) {
      throw Exception("Failed to decode image");
    }

    original = img.bakeOrientation(original);

    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final double imgWidth = original.width.toDouble();
    final double imgHeight = original.height.toDouble();

    // Calculate BoxFit.cover scale and offsets
    final double scale =
        math.max(screenWidth / imgWidth, screenHeight / imgHeight);
    final double offsetX = (screenWidth - imgWidth * scale) / 2;
    final double offsetY = (screenHeight - imgHeight * scale) / 2;

    // Map screen frame Rect coordinates to image coordinates
    final double cropLeft = (frameRect.left - offsetX) / scale;
    final double cropTop = (frameRect.top - offsetY) / scale;
    final double cropWidth = frameRect.width / scale;
    final double cropHeight = frameRect.height / scale;

    final int x = cropLeft.round().clamp(0, original.width - 1);
    final int y = cropTop.round().clamp(0, original.height - 1);
    final int w = cropWidth.round().clamp(1, original.width - x);
    final int h = cropHeight.round().clamp(1, original.height - y);

    final img.Image cropped = img.copyCrop(
      original,
      x: x,
      y: y,
      width: w,
      height: h,
    );

    // Save cropped image
    final tempDir = await getTemporaryDirectory();
    final String croppedPath =
        '${tempDir.path}/cropped_doc_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File croppedFile = File(croppedPath);

    await croppedFile.writeAsBytes(img.encodeJpg(cropped, quality: 90));
    return croppedPath;
  }

  Future<void> _captureAndProcess(Rect frameRect, Size screenSize) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile photo = await _controller!.takePicture();
      final croppedPath = await _cropImage(photo, frameRect, screenSize);
      final croppedBytes = await File(croppedPath).readAsBytes();

      setState(() {
        _croppedImagePath = croppedPath;
        _croppedImageBytes = croppedBytes;
        _isProcessing = false;
      });
    } catch (e) {
      debugPrint("Capture and process error: $e");
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).errorProcessingImage),
            backgroundColor: AppColorManager.red,
          ),
        );
      }
    }
  }

  void _retake() {
    setState(() {
      _croppedImagePath = null;
      _croppedImageBytes = null;
    });
  }

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
                Text(
                  S.of(context).cameraPermissionRequired,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                10.verticalSpace,
                Text(
                  S.of(context).cameraPermissionDesc,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                30.verticalSpace,
                MyButton(
                  text: S.of(context).grantPermission,
                  onTap: _checkPermissionAndInitCamera,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isInitializing) {
      return Scaffold(
        backgroundColor: AppColorManager.mainColor,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    // Capture screen size and calculate card frame bounds
    final Size screenSize = MediaQuery.of(context).size;
    final double rectWidth = screenSize.width * 0.85;
    // Standard ID card aspect ratio is ~1.586
    final double rectHeight = rectWidth / 1.586;
    final Rect frameRect = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: rectWidth,
      height: rectHeight,
    );

    // If already captured, show cropped preview
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
          title: Text(
            S.of(context).documentPreview,
            style: const TextStyle(color: Colors.white),
          ),
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0).r,
                      child: Image.file(
                        File(_croppedImagePath!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 24.0.w,
                right: 24.0.w,
                bottom: 40.0.h,
                top: 20.0.h,
              ),
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
                    child: MyButton(
                      text: S.of(context).confirm,
                      onTap: () {
                        widget.onCapture(_croppedImagePath!, _croppedImageBytes!);
                      },
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
          // Full-screen camera preview
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

          // Semi-transparent overlay with a cutout and pulsing scan line
          AnimatedBuilder(
            animation: _scanAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: ScannerOverlayPainter(
                  scanWindow: frameRect,
                  progress: _scanAnimation.value,
                  instructionText: S.of(context).placeIdInsideFrame,
                ),
                child: Container(),
              );
            },
          ),

          // Scanning guideline and controls
          SafeArea(
            child: Column(
              children: [
                // Top control bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller?.value.flashMode == FlashMode.torch
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: _toggleFlash,
                          ),
                          10.horizontalSpace,
                          IconButton(
                            icon: const Icon(Icons.cameraswitch,
                                color: Colors.white, size: 28),
                            onPressed: _toggleCamera,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Capture controls
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Column(
                    children: [
                      if (_isProcessing)
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      else
                        GestureDetector(
                          onTap: () => _captureAndProcess(frameRect, screenSize),
                          child: Container(
                            height: 80.r,
                            width: 80.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              color: Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  final double progress;
  final String instructionText;

  ScannerOverlayPainter({
    required this.scanWindow,
    required this.progress,
    required this.instructionText,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the semi-transparent black background
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()
      ..addRRect(
          RRect.fromRectAndRadius(scanWindow, const Radius.circular(16.0)));

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.65)
      ..style = PaintingStyle.fill;

    // Create background with a hole
    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(overlayPath, backgroundPaint);

    // 2. Draw outer border of the window
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(
        RRect.fromRectAndRadius(scanWindow, const Radius.circular(16.0)),
        borderPaint);

    // 3. Draw Corner Brackets (Handles) in Blue
    final cornerPaint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 24.0;
    final RRect rrect =
        RRect.fromRectAndRadius(scanWindow, const Radius.circular(16.0));

    // Top-Left corner
    canvas.drawPath(
      Path()
        ..moveTo(rrect.left, rrect.top + cornerLength)
        ..lineTo(rrect.left, rrect.top + 16.0)
        ..quadraticBezierTo(rrect.left, rrect.top, rrect.left + 16.0, rrect.top)
        ..lineTo(rrect.left + cornerLength, rrect.top),
      cornerPaint,
    );

    // Top-Right corner
    canvas.drawPath(
      Path()
        ..moveTo(rrect.right, rrect.top + cornerLength)
        ..lineTo(rrect.right, rrect.top + 16.0)
        ..quadraticBezierTo(
            rrect.right, rrect.top, rrect.right - 16.0, rrect.top)
        ..lineTo(rrect.right - cornerLength, rrect.top),
      cornerPaint,
    );

    // Bottom-Left corner
    canvas.drawPath(
      Path()
        ..moveTo(rrect.left, rrect.bottom - cornerLength)
        ..lineTo(rrect.left, rrect.bottom - 16.0)
        ..quadraticBezierTo(
            rrect.left, rrect.bottom, rrect.left + 16.0, rrect.bottom)
        ..lineTo(rrect.left + cornerLength, rrect.bottom),
      cornerPaint,
    );

    // Bottom-Right corner
    canvas.drawPath(
      Path()
        ..moveTo(rrect.right, rrect.bottom - cornerLength)
        ..lineTo(rrect.right, rrect.bottom - 16.0)
        ..quadraticBezierTo(
            rrect.right, rrect.bottom, rrect.right - 16.0, rrect.bottom)
        ..lineTo(rrect.right - cornerLength, rrect.bottom),
      cornerPaint,
    );

    // 4. Draw pulsing/scanning line
    final double scanLineY =
        scanWindow.top + 6.0 + (scanWindow.height - 12.0) * progress;
    final scanLinePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF2196F3).withOpacity(0.0),
          const Color(0xFF2196F3).withOpacity(0.8),
          const Color(0xFF2196F3).withOpacity(0.0),
        ],
      ).createShader(
        Rect.fromLTRB(
            scanWindow.left, scanLineY - 2.0, scanWindow.right, scanLineY + 2.0),
      )
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTRB(scanWindow.left + 6.0, scanLineY - 4.0,
          scanWindow.right - 6.0, scanLineY + 4.0),
      scanLinePaint,
    );

    // Draw scanning laser core
    final laserPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(scanWindow.left + 8.0, scanLineY),
      Offset(scanWindow.right - 8.0, scanLineY),
      laserPaint,
    );

    // 5. Draw the guidance text below the window
    final textPainter = TextPainter(
      text: TextSpan(
        text: instructionText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width - 40,
    );

    final xPosition = (size.width - textPainter.width) / 2;
    final yPosition = scanWindow.bottom + 30.0;

    textPainter.paint(canvas, Offset(xPosition, yPosition));
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.scanWindow != scanWindow ||
        oldDelegate.instructionText != instructionText;
  }
}
