import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/round_image_widget.dart';

import '../../../../../core/util/bottom_sheets.dart';
import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../bloc/accidents_cubit/accidents_cubit.dart';

class AccidentInfo extends StatefulWidget {
  const AccidentInfo({super.key});

  @override
  State<AccidentInfo> createState() => _AccidentInfoState();
}

class _AccidentInfoState extends State<AccidentInfo> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccidentsCubit, AccidentsInitial>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            ListTile(
              title: DrawableText(
                text: S.of(context).generalInformation,
                fontWeight: FontWeight.bold,
              ),
              subtitle: DrawableText(text: S.of(context).pleaseEnterRequiredAccidentInfo),
            ),
            10.0.verticalSpace,
            MyTextFormOutLineWidget(
              onChanged: (p0) => state.mRequest.description = p0,
              initialValue: state.mRequest.description,
              labelText: S.of(context).accidentDetails,
              hint: S.of(context).pleaseSpecifyAccidentDetails,
            ),
            10.0.verticalSpace,
            MyTextFormOutLineWidget(
              onChanged: (p0) => state.mRequest.location = p0,
              initialValue: state.mRequest.location,
              labelText: S.of(context).accidentLocation,
              hint: S.of(context).pleaseSpecifyAccidentLocation,
              maxLines: 4,
            ),
            20.0.verticalSpace,
            UploadContainerWidget(
              title: S.of(context).uploadOneFileOnly,
              child: state.mRequest.policeReport.notHaveValue
                  ? null
                  : ListTile(
                      leading: ImageMultiType(
                        url: Assets.iconsFolder,
                        height: 50.0.dg,
                        width: 50.0.dg,
                      ),
                      title: DrawableText(text: state.mRequest.policeReport.localId ?? '-'),
                    ),
              onTap: () {
                showFileUploadBottomSheet(
                  context,
                  (value) {
                    setState(() {
                      state.mRequest.policeReport = value;
                    });
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
