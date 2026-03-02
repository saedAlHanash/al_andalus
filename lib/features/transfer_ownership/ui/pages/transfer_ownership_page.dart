import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type_pakage.dart';
import 'package:go_router/go_router.dart';
import 'package:m_cubit/m_cubit.dart';

import '../../../../core/util/snack_bar_message.dart';
import '../../../../core/util/bottom_sheets.dart';
import '../../bloc/transfer_ownership_cubit.dart';

class TransferOwnershipPage extends StatelessWidget {
  const TransferOwnershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TransferOwnershipView();
  }
}

class _TransferOwnershipView extends StatelessWidget {
  const _TransferOwnershipView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferOwnershipCubit, TransferOwnershipState>(
      listenWhen: (p, c) => c.statuses == CubitStatuses.done,
      listener: (context, state) {
        NoteMessage.showSnakeBar(context: context, message: state.result?.message ?? '');
        context.pop();
      },
      child: Scaffold(
        appBar: AppBarWidget(titleText: S.of(context).transferOwnership),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: BlocBuilder<TransferOwnershipCubit, TransferOwnershipState>(
            builder: (context, state) {
              return MyButton(
                loading: state.statuses == CubitStatuses.loading,
                onTap: () {
                  context.read<TransferOwnershipCubit>().transferOwnership();
                },
                text: S.of(context).confirm,
              );
            },
          ),
        ),
        body: BlocBuilder<TransferOwnershipCubit, TransferOwnershipState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0).r,
              children: [
                MyTextFormOutLineWidget(
                  labelText: S.of(context).name,
                  hint: S.of(context).name,
                  onChanged: (p0) => context.read<TransferOwnershipCubit>().updateName(p0),
                ),
                MyTextFormOutLineWidget(
                  labelText: S.of(context).phoneNumber,
                  hint: S.of(context).phoneNumber,
                  onChanged: (p0) => context.read<TransferOwnershipCubit>().updatePhone(p0),
                ),
                MyTextFormOutLineWidget(
                  labelText: S.of(context).idCardNumber,
                  hint: S.of(context).idCardNumber,
                  onChanged: (p0) => context.read<TransferOwnershipCubit>().updateIdentityNumber(p0),
                ),
                20.0.verticalSpace,
                DrawableText(
                  text: S.of(context).attachIdFrontAndBack,
                  matchParent: true,
                ),
                10.0.verticalSpace,
                UploadContainerWidget(
                  title: S.of(context).attachIdFrontHere,
                  child: state.mRequest.identityFrontImage.fileBytes == null
                      ? null
                      : RoundImageWidget(
                          height: 200.0.h,
                          width: 1.0.sw,
                          url: state.mRequest.identityFrontImage.fileBytes,
                          fit: BoxFit.cover,
                        ),
                  onTap: () {
                    showOptionBottomSheet(context, (value) {
                      context.read<TransferOwnershipCubit>().setImage(value, true);
                    });
                  },
                ),
                15.0.verticalSpace,
                UploadContainerWidget(
                  title: S.of(context).attachIdBackHere,
                  child: state.mRequest.identityBackImage.fileBytes == null
                      ? null
                      : RoundImageWidget(
                          height: 200.0.h,
                          width: 1.0.sw,
                          url: state.mRequest.identityBackImage.fileBytes,
                          fit: BoxFit.cover,
                        ),
                  onTap: () {
                    showOptionBottomSheet(context, (value) {
                      context.read<TransferOwnershipCubit>().setImage(value, false);
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
