import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_expansion/item_expansion.dart';
import 'package:al_andalus/core/widgets/my_expansion/my_expansion_widget.dart';
import 'package:al_andalus/core/widgets/shimmer_widget.dart';
import 'package:al_andalus/features/profile/bloc/update_profile_cubit/update_profile_cubit.dart';
import 'package:al_andalus/generated/l10n.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:m_cubit/m_cubit.dart';
import 'package:al_andalus/router/go_router.dart';

import '../../../../core/util/snack_bar_message.dart';
import '../../bloc/transfer_ownership_cubit/transfer_ownership_cubit.dart';
import '../widget/driving_license_fields_widget.dart';
import '../widget/identity_info_fields_widget.dart';
import '../widget/payment_transfer_screen.dart';

class TransferOwnershipPage extends StatefulWidget {
  const TransferOwnershipPage({super.key});

  @override
  State<TransferOwnershipPage> createState() => _TransferOwnershipPageState();
}

class _TransferOwnershipPageState extends State<TransferOwnershipPage> {
  int _step = 0; // 0: Confirm Personal Info, 1: Payment details
  final List<bool> _panelExpanded = [true, false];
  bool _agreementAccepted = false;

  String? _getValidationError(BuildContext context) {
    final req = context.read<UpdateProfileCubit>().state.mRequest;
    final profile = AppProvider.getMe;

    if ((req.name ?? profile.name).isEmpty) {
      return S.of(context).pleaseEnterFullName;
    }
    if ((req.identityId ?? profile.identityId).isEmpty) {
      return S.of(context).pleaseEnterIdNumber;
    }
    if ((req.address ?? profile.address).isEmpty) {
      return S.of(context).pleaseEnterAddress;
    }
    if ((req.birthday ?? profile.birthDate) == null) {
      return S.of(context).pleaseSelectBirthday;
    }

    final currentGender =
        req.gender ??
        (profile.gender.toLowerCase() == 'male'
            ? GenderEnum.male
            : profile.gender.toLowerCase() == 'female'
            ? GenderEnum.female
            : null);
    if (currentGender == null) {
      return S.of(context).pleaseSelectGender;
    }

    if (!req.identityFrontImage.haveValue && profile.identityFrontImage.isEmpty) {
      return S.of(context).pleaseAttachFrontId;
    }
    if (!req.identityBackImage.haveValue && profile.identityBackImage.isEmpty) {
      return S.of(context).pleaseAttachBackId;
    }

    if ((req.licenseNumber ?? profile.licenseNumber).isEmpty) {
      return S.of(context).pleaseEnterLicenseNumber;
    }

    final currentLicenseType =
        req.licenseType ?? (LicenseType.values.where((element) => element.nameApi == profile.licenseType).firstOrNull);
    if (currentLicenseType == null) {
      return S.of(context).pleaseEnterLicenseType;
    }

    if ((req.licenseStartDate ?? profile.licenseStartDate) == null) {
      return S.of(context).pleaseSelectIssueDate;
    }
    if ((req.licenseEndDate ?? profile.licenseEndDate) == null) {
      return S.of(context).pleaseSelectExpiryDate;
    }

    if (!req.licenseFrontImage.haveValue && profile.licenseFrontImage.isEmpty) {
      return S.of(context).pleaseAttachFrontLicense;
    }
    if (!req.licenseBackImage.haveValue && profile.licenseBackImage.isEmpty) {
      return S.of(context).pleaseAttachBackLicense;
    }

    if (!_agreementAccepted) {
      return S.of(context).pleaseAcceptDeclaration;
    }

    return null;
  }

  Future<void> _saveAndContinue() async {
    final validationError = _getValidationError(context);
    if (validationError != null) {
      NoteMessage.showSnakeBar(context: context, message: validationError);
      return;
    }

    final cubit = context.read<UpdateProfileCubit>();

    await cubit.updateIdentity();
    if (cubit.state.statuses == CubitStatuses.error) {
      return;
    }

    await cubit.updateDrivingLicense();
    if (cubit.state.statuses == CubitStatuses.error) {
      return;
    }

    setState(() {
      _step = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferOwnershipCubit, TransferOwnershipState>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        NoteMessage.showSnakeBar(context: context, message: state.result?.message ?? '');
        context.go(RouteName.home);
      },
      child: Scaffold(
        appBar: AppBarWidget(
          titleText: _step == 0 ? S.of(context).confirmPersonalInfo : S.of(context).transferOwnership,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0).r,
          child: _step == 0
              ? BlocBuilder<UpdateProfileCubit, UpdateProfileInitial>(
                  builder: (context, profileState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (profileState.loading) ...[
                          ShimmerWidget(
                            child: DrawableText(
                              textAlign: TextAlign.center,
                              text: 'يتم الآن تحميل الملفات: ${(profileState.uploadProgress * 100).toInt()}%',
                            ),
                          ),
                          10.verticalSpace,
                        ],
                        MyButton(
                          loading: profileState.loading,
                          onTap: _saveAndContinue,
                          text: S.of(context).continueTo,
                        ),
                      ],
                    );
                  },
                )
              : BlocBuilder<TransferOwnershipCubit, TransferOwnershipState>(
                  builder: (context, state) {
                    return MyButton(
                      enable: state.mRequest.canSend,
                      loading: state.loading,
                      onTap: () {
                        context.read<TransferOwnershipCubit>().transferOwnership();
                      },
                      text: S.of(context).confirm,
                    );
                  },
                ),
        ),
        body: _step == 0
            ? ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 24.0.h),
                children: [
                  MyExpansionWidget(
                    items: [
                      ItemExpansion(
                        id: 0,
                        header: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                          alignment: Alignment.centerRight,
                          child: DrawableText(
                            text: S.of(context).unifiedCardInfo,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColorManager.black,
                            ),
                          ),
                        ),
                        body: const IdentityInfoFieldsWidget(),
                        isExpanded: _panelExpanded[0],
                      ),
                      ItemExpansion(
                        id: 1,
                        header: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                          alignment: Alignment.centerRight,
                          child: DrawableText(
                            text: S.of(context).drivingLicenseInfo,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColorManager.black,
                            ),
                          ),
                        ),
                        body: const DrivingLicenseFieldsWidget(),
                        isExpanded: _panelExpanded[1],
                      ),
                    ],
                    onExpansion: (index, isExpanded) {
                      setState(() {
                        _panelExpanded[index] = isExpanded;
                      });
                    },
                  ),
                  20.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        activeColor: AppColorManager.mainColor,
                        value: _agreementAccepted,
                        onChanged: (val) {
                          setState(() {
                            _agreementAccepted = val ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 12.0.h),
                          child: Text(
                            S.of(context).declarationText,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Almarai',
                              color: AppColorManager.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : BlocBuilder<TransferOwnershipCubit, TransferOwnershipState>(
                builder: (context, state) {
                  return const PaymentTransferScreen();
                },
              ),
      ),
    );
  }
}
