import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../../core/strings/enum_manager.dart';
import '../../../../../core/util/bottom_sheets.dart';
import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../bloc/cars_cubit/cars_cubit.dart';

class CarInspectionScreen extends StatelessWidget {
  const CarInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<CarsCubit, CarsInitial>(
          builder: (context, state) {
            return LayoutBuilder(
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
                      label: S.of(context).front,
                      top: height * 0.10,
                      left: width * 0.50,
                      onTap: () => _handleCapture(context, .front, state.mRequest.frontImage),
                      isCompleted: state.mRequest.frontImage.fileBytes != null,
                    ),

                    // 3. Engine Hotspot (محرك السيارة)
                    _buildHotspot(
                      label: S.of(context).engine,
                      top: height * 0.20,
                      left: width * 0.75,
                      onTap: () => _handleCapture(context, .engine, state.mRequest.backImage),
                      isCompleted: state.mRequest.backImage.fileBytes != null,
                    ),

                    // 4. Right Side Hotspot (الجانب الأيمن)
                    _buildHotspot(
                      label: S.of(context).right,
                      top: height * 0.40,
                      left: width * 0.77,
                      onTap: () => _handleCapture(context, .right, state.mRequest.rightSideImage),
                      isCompleted: state.mRequest.rightSideImage.fileBytes != null,
                    ),

                    // 5. Left Side Hotspot (الجانب الأيسر)
                    _buildHotspot(
                      label: S.of(context).left,
                      top: height * 0.39,
                      left: width * 0.22,
                      onTap: () => _handleCapture(context, .left, state.mRequest.leftSideImage),
                      isCompleted: state.mRequest.leftSideImage.fileBytes != null,
                    ),

                    // 6. Interior Hotspot (الجزء الداخلي - بالمنتصف)
                    _buildHotspot(
                      label: S.of(context).interior,
                      top: height * 0.55,
                      left: width * 0.50,
                      onTap: () => _handleCapture(context, .interior, state.mRequest.interiorImage),
                      isCompleted: state.mRequest.interiorImage.fileBytes != null,
                    ),

                    // 7. Rear Hotspot (الجزء الخلفي)
                    _buildHotspot(
                      label: S.of(context).rear,
                      top: height * 0.95,
                      left: width * 0.50,
                      onTap: () => _handleCapture(context, .rear, state.mRequest.engineImage),
                      isCompleted: state.mRequest.engineImage.fileBytes != null,
                    ),
                  ],
                );
              },
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
              DrawableText(
                text: label,
                textAlign: TextAlign.center,
              ),
              5.0.verticalSpace,
              ImageMultiType(
                url: isCompleted ? Assets.iconsDoneTake : Assets.imagesCamera,
                color: Colors.black,
                width: 35.0.r,
                height: 35.0.r,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCapture(BuildContext context, ImageZone zone, UploadFile file) {
    if (file.fileBytes != null) {
      showImageReviewDialog(
        context,
        file,
        (reTake) {
          context.read<CarsCubit>().removeImage(zone);
          _handleCapture(context, zone, UploadFile(nameField: file.nameField));
        },
      );
      return;
    }
    showOptionBottomSheet(
      context,
      (value) {
        context.read<CarsCubit>().setImage(value, zone);
      },
    );
  }
}
