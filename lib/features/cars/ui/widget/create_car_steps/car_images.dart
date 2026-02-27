import 'package:flutter/material.dart';

import '../../../../../generated/assets.dart';

class CarInspectionScreen extends StatelessWidget {
  const CarInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;

            return Stack(
              children: [
                // 1. The Main Car Image
                Center(
                  child: Transform.scale(
                    scale: 0.87,
                    child: Image.asset(
                      Assets.imagesCarImages, // تأكد من المسار الصحيح
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // 2. Front Hotspot (الجزء الأمامي)
                _buildHotspot(
                  label: "الجزء الأمامي",
                  top: height * 0.10,
                  left: width * 0.50,
                  onTap: () => _handleCapture("Front"),
                ),

                // 3. Engine Hotspot (محرك السيارة)
                _buildHotspot(
                  label: "محرك السيارة",
                  top: height * 0.20,
                  left: width * 0.75,
                  onTap: () => _handleCapture("Engine"),
                ),

                // 4. Right Side Hotspot (الجانب الأيمن)
                _buildHotspot(
                  label: "الجانب الأيمن",
                  top: height * 0.40,
                  left: width * 0.77,
                  onTap: () => _handleCapture("Right Side"),
                ),

                // 5. Left Side Hotspot (الجانب الأيسر)
                _buildHotspot(
                  label: "الجانب الأيسر",
                  top: height * 0.39,
                  left: width * 0.22,
                  onTap: () => _handleCapture("Left Side"),
                ),

                // 6. Interior Hotspot (الجزء الداخلي - بالمنتصف)
                _buildHotspot(
                  label: "الجزء الداخلي",
                  top: height * 0.55,
                  left: width * 0.50,
                  onTap: () => _handleCapture("Interior"),
                ),

                // 7. Rear Hotspot (الجزء الخلفي)
                _buildHotspot(
                  label: "الجزء الخلفي",
                  top: height * 0.95,
                  left: width * 0.50,
                  onTap: () => _handleCapture("Rear"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHotspot({
    required String label,
    required double top,
    required double left,
    required VoidCallback onTap,
    bool isCompleted = false,
  }) {
    return Positioned(
      top: top - 35, // Adjusting for center alignment
      left: left - 40,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 80,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.8), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.camera_alt_outlined,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCapture(String zone) {
    debugPrint("Initiating camera for: $zone");
  }
}
