import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/helper/launcher_helper.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/util/snack_bar_message.dart';
import 'package:al_andalus/core/widgets/refresh_widget/refresh_widget.dart';
import 'package:al_andalus/router/go_router.dart';
import 'package:al_andalus/services/app_info_service.dart';
import 'package:al_andalus/services/biometric_auth_service.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../../core/strings/app_color_manager.dart';
import '../../../../../core/util/bottom_sheets.dart';
import '../../../../../core/widgets/need_login_widget.dart';
import '../../../../../generated/assets.dart';
import '../../../../../generated/l10n.dart';
import '../../../../auth/bloc/delete_account_cubit/delete_account_cubit.dart';
import '../../../../profile/bloc/get_me_cubit/get_me_cubit.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    if (AppProvider.isGuest) {
      return NeedLoginWidget();
    }
    return Scaffold(
      body: BlocBuilder<GetMeCubit, GetMeInitial>(
        builder: (context, state) {
          return RefreshWidget(
            isLoading: state.loading,
            onRefresh: () {
              context.read<GetMeCubit>().getData(newData: true);
            },
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0).r,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0).r,
                    image: DecorationImage(image: AssetImage(Assets.iconsProfileBack), fit: BoxFit.cover),
                  ),
                  child: ListTile(
                    tileColor: Colors.transparent,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0).r,
                    title: DrawableText(
                      fontWeight: FontWeight.bold,
                      size: 24.0.sp,
                      color: Colors.white,
                      text: state.result.name,
                    ),
                    subtitle: DrawableText(
                      text: '${S.of(context).phoneNumber}: ${state.result.phone.replaceAll('+', '00')}',
                      color: Colors.white,
                      size: 16.0.sp,
                    ),
                  ),
                ),
                20.0.verticalSpace,
                DrawableText(
                  text: S.of(context).personalData,
                  fontWeight: FontWeight.bold,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ).r,
                  matchParent: true,
                  size: 18.0.sp,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColorManager.cd),
                    borderRadius: BorderRadius.circular(14.0.r),
                  ),
                  child: Column(
                    children: [
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(RouteName.editPhonePage).then(
                            (value) {
                              context.read<GetMeCubit>().getData(newData: true);
                            },
                          );
                        },
                        name: S.of(context).phoneData,
                        subTitle: S.of(context).manageYourPhoneNumber,
                        image: Assets.iconsPerson,
                        withD: false,
                      ),
                    ],
                  ),
                ),
                20.0.verticalSpace,
                DrawableText(
                  text: S.of(context).securityData,
                  fontWeight: FontWeight.bold,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ).r,
                  matchParent: true,
                  size: 18.0.sp,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColorManager.cd),
                    borderRadius: BorderRadius.circular(14.0.r),
                  ),
                  child: Column(
                    children: [
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(RouteName.biometricEnroll);
                        },
                        name: S.of(context).biometricData,
                        subTitle: S.of(context).manageBiometricSettings,
                        image: Assets.iconsPerson,
                      ),
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(RouteName.changePasswordPage);
                        },
                        name: S.of(context).changePasscode,
                        subTitle: S.of(context).manageLoginPasscode,
                        image: Assets.iconsPerson,
                        withD: false,
                      ),
                    ],
                  ),
                ),

                20.0.verticalSpace,
                DrawableText(
                  text: S.of(context).info,
                  fontWeight: FontWeight.bold,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ).r,
                  matchParent: true,
                  size: 18.0.sp,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColorManager.cd),
                    borderRadius: BorderRadius.circular(14.0.r),
                  ),
                  child: Column(
                    children: [
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(RouteName.editIdentityInfo).then(
                            (value) {
                              context.read<GetMeCubit>().getData(newData: true);
                            },
                          );
                        },
                        name: S.of(context).unifiedCardInfo,
                        subTitle: S.of(context).manageUnifiedCardInfo,
                        image: Assets.iconsPerson,
                      ),
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(RouteName.editDrivingLicense).then(
                            (value) {
                              context.read<GetMeCubit>().getData(newData: true);
                            },
                          );
                        },
                        name: S.of(context).drivingLicenseInfo,
                        subTitle: S.of(context).manageDrivingLicenseInfo,
                        image: Assets.iconsPerson,
                        withD: false,
                      ),
                      // ItemMenu(
                      //   onTap: () {
                      //     context.pushNamed(RouteName.carsPage);
                      //   },
                      //   name: S.of(context).myCars,
                      //   subTitle: S.of(context).manageMyCars,
                      //   image: Assets.iconsPerson,
                      //   withD: false,
                      // ),
                    ],
                  ),
                ),
                20.0.verticalSpace,

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColorManager.cd),
                    borderRadius: BorderRadius.circular(14.0.r),
                  ),
                  child: Column(
                    children: [
                      ItemMenu(
                        onTap: () {
                          showLanguageDialog(context);
                        },
                        name: S.of(context).language,
                        image: Assets.iconsFileList,
                      ),
                      ItemMenu(
                        onTap: () {
                          showThemeDialog(context);
                        },
                        name: S.of(context).theme,
                        image: ImageMultiType(
                          url: Icons.dark_mode,
                          color: AppColorManager.mainColor,
                        ),
                      ),
                      ItemMenu(
                        onTap: () {
                          showFontDialog(context);
                        },
                        name: 'الخط',
                        image: ImageMultiType(
                          url: Icons.font_download_outlined,
                          color: AppColorManager.mainColor,
                        ),
                      ),
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(
                            RouteName.dataPage,
                            queryParameters: {'type': DataPageType.terms.index.toString()},
                          );
                        },
                        name: S.of(context).termsAndConditions,
                        image: Assets.iconsPhoneFlip,
                      ),
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(
                            RouteName.dataPage,
                            queryParameters: {'type': DataPageType.policy.index.toString()},
                          );
                        },
                        name: S.of(context).policy,
                        image: Assets.iconsFileList,
                      ),
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(
                            RouteName.dataPage,
                            queryParameters: {'type': DataPageType.aboutUs.index.toString()},
                          );
                        },
                        name: S.of(context).aboutUs,
                        image: Assets.iconsFileList,
                      ),
                      // ItemMenu(
                      //   onTap: () {
                      //     context.pushNamed(
                      //       RouteName.dataPage,
                      //       queryParameters: {'type': DataPageType.ourService.index.toString()},
                      //     );
                      //   },
                      //   name: S.of(context).ourService,
                      //   image: Assets.iconsFileList,
                      // ),
                      ItemMenu(
                        onTap: () {
                          showSupportCall(context);
                        },
                        name: S.of(context).support,
                        image: Assets.iconsPhoneFlip,
                      ),
                      ItemMenu(
                        onTap: () {
                          AppProvider.logout(withDialog: true);
                        },
                        name: S.of(context).logout,
                        image: ImageMultiType(
                          url: Icons.logout,
                          color: AppColorManager.mainColor,
                        ),
                      ),
                      if (AppProvider.isStoreTest)
                        ItemMenu(
                          onTap: () {
                            NoteMessage.showCheckDialog(
                              context,
                              text: S.of(context).deleteAccount,
                              textButton: S.of(context).sure,
                              image: ImageMultiType(url: Assets.iconsDelete, height: 120.0.r, width: 120.0.r),
                              onConfirm: (confirm) {
                                if (!confirm) return;
                                context.read<DeleteAccountCubit>().deleteAccount(context);
                              },
                            );
                          },
                          name: S.of(context).deleteAccount,
                          subTitle: S.of(context).subTitleDeleteAccount,
                          image: Assets.iconsDelete,
                          withD: false,
                        ),
                      ItemMenu(
                        onTap: () {},
                        name: S.of(context).buildNumber,
                        subTitle: AppInfoService.fullVersionName,
                        trailing: 0.0.verticalSpace,
                      ),
                      ItemMenu(
                        onTap: () {
                          LauncherHelper.openPage('https://bandtech.co/');
                        },
                        name: S.of(context).devBy,
                        subTitle: S.of(context).technicalPackage,
                        withD: false,
                        trailing: ImageMultiType(
                          url: Assets.imagesBandtechLogo,
                          height: 70.0.h,
                          width: 70.0.w,
                        ),
                      ),
                    ],
                  ),
                ),
                100.0.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}

class ItemMenu extends StatelessWidget {
  const ItemMenu({
    super.key,
    required this.name,
    this.subTitle,
    this.leading,
    this.image,
    this.trailing,
    this.withD = true,
    this.onTap,
  });

  final String name;

  final String? subTitle;

  final dynamic image;
  final Function()? onTap;
  final Widget? trailing;
  final Widget? leading;
  final bool withD;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0).w,
      padding: const EdgeInsets.symmetric(vertical: 2.0).r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0.r),
      ),
      child: Column(
        children: [
          ListTile(
            tileColor: Colors.transparent,
            leading: leading,
            onTap: () => onTap?.call(),
            title: DrawableText(
              text: name,
              fontFamily: FontManager.bold.name,
            ),
            minLeadingWidth: 0,
            subtitle: subTitle == null
                ? null
                : DrawableText(
                    text: subTitle!,
                    size: 12.0.sp,
                    color: Colors.grey,
                  ),
            trailing:
                trailing ??
                ImageMultiType(
                  url: Icons.arrow_forward_ios,
                  height: 15.0.r,
                  color: Color(0xff667085),
                ),
          ),

          if (withD)
            Divider(
              height: 0,
              color: AppColorManager.cd,
              endIndent: 5.0.w,
              indent: 5.0.w,
            ),
        ],
      ),
    );
  }
}
