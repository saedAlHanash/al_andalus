import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/uploade_utl.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:al_andalus/router/go_router.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type_pakage.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../../core/util/bottom_sheets.dart';
import '../../../../../generated/assets.dart';
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
                color: AppColorManager.cardColor,
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
                    child: state.mRequest.inspectionReport.notHaveValue
                        ? null
                        : Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  if (!state.mRequest.inspectionReport.remoteUrl.isBlank) {
                                    context.pushNamed(
                                      RouteName.pdf,
                                      queryParameters: {'url': state.mRequest.inspectionReport.remoteUrl},
                                    );
                                  }
                                },
                                leading: ImageMultiType(
                                  url: Assets.iconsFolder,
                                  height: 50.0.dg,
                                  width: 50.0.dg,
                                ),
                                title: DrawableText(text: state.mRequest.inspectionReport.localId ?? '-'),
                              ),
                              10.0.verticalSpace,
                              MyButton(
                                icon: ImageMultiType(url: Icons.upload_outlined),
                                text: S.of(context).reUpload,
                                onTap: () {
                                  showFileUploadBottomSheet(
                                    context,
                                    (value) {
                                      setState(() {
                                        state.mRequest.inspectionReport = value;
                                      });
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                    onTap: () {
                      showFileUploadBottomSheet(
                        context,
                        (value) {
                          setState(() {
                            state.mRequest.inspectionReport = value;
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
