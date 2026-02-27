import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type_pakage.dart';

import '../../../bloc/cars_cubit/cars_cubit.dart';

class CarInspection extends StatefulWidget {
  const CarInspection({super.key});

  @override
  State<CarInspection> createState() => _CarInspectionState();
}

class _CarInspectionState extends State<CarInspection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCubit, CarsInitial>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            24.0.verticalSpace,
            DrawableText(
              text: S.of(context).uploadInspectionReportTopic,
              fontWeight: FontWeight.bold,
            ),
            5.0.verticalSpace,

            DrawableText(
              text: S.of(context).pleaseUploadInspectionDocument,
              fontFamily: FontManager.regular.name,
            ),
            24.0.verticalSpace,
            Container(
              padding: const EdgeInsets.all(14.62),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.75),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0A212121),
                    blurRadius: 3.65,
                    offset: Offset(0, 2.44),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0x14212121),
                    blurRadius: 30.45,
                    offset: Offset(0, 2.44),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                spacing: 10.0.h,
                children: [
                  DrawableText(
                    text: S.of(context).uploadInspectionReport,
                    matchParent: true,
                  ),
                  UploadContainerWidget(
                    title: S.of(context).uploadOneFileOnly,
                    child: state.mRequest.inspectionReport.fileBytes == null
                        ? null
                        : RoundImageWidget(
                            height: 200.0.h,
                            width: 1.0.sw,
                            url: state.mRequest.inspectionReport.fileBytes,
                            fit: .cover,
                          ),
                    onTap: () {
                      showOptionBottomSheet(
                        context,
                        (value) {
                          setState(() {
                            final nameField = state.mRequest.inspectionReport.nameField;
                            state.mRequest
                              ..inspectionReport = value
                              ..inspectionReport.nameField = nameField;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            20.0.verticalSpace,
          ],
        );
      },
    );
  }
}
