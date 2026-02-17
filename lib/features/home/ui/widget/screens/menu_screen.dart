import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/snack_bar_message.dart';
import 'package:go_router/go_router.dart';
import 'package:al_andalus/router/go_router.dart';
import 'package:al_andalus/services/app_info_service.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/round_image_widget.dart';

import '../../../../../core/strings/app_color_manager.dart';
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
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0).r,
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0).r,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
                  tileColor: AppColorManager.mainColor.withValues(alpha: 0.1),
                  title: DrawableText(
                    fontWeight: FontWeight.bold,
                    size: 16.0.sp,
                    text: state.result.name,
                  ),
                  subtitle: DrawableText(
                    text: state.result.phone.replaceAll('+964', '0'),
                    color: Colors.black45,
                  ),
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: RoundImageWidget(
                      url: Assets.imagesUser,
                      width: 30.0.r,
                    ),
                  ),
                ),
                20.0.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColorManager.cardColor),
                    borderRadius: BorderRadius.circular(14.0.r),
                  ),
                  child: Column(
                    children: [
                      10.0.verticalSpace,
                      DrawableText(
                        text: S.of(context).account,
                        fontWeight: FontWeight.bold,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ).r,
                        matchParent: true,
                        size: 20.0.sp,
                      ),
                      Divider(),
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(RouteName.profile).then(
                            (value) {
                              context.read<GetMeCubit>().getData(newData: true);
                            },
                          );
                        },
                        name: S.of(context).editProfile,
                        image: Assets.iconsPerson,
                        trailing: ImageMultiType(
                          url: Icons.arrow_forward_ios,
                          height: 15.0.r,
                        ),
                      ),
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(RouteName.address);
                        },
                        name: S.of(context).addresses,
                        image: Assets.iconsMap,
                        trailing: ImageMultiType(
                          url: Icons.arrow_forward_ios,
                          height: 15.0.r,
                        ),
                      ),
                      ItemMenu(
                        onTap: () {
                          context.pushNamed(RouteName.orders);
                        },
                        name: S.of(context).myOrders,
                        image: Assets.iconsBox,
                        trailing: ImageMultiType(
                          url: Icons.arrow_forward_ios,
                          height: 15.0.r,
                        ),
                        withD: false,
                      ),
                    ],
                  ),
                ),
                20.0.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColorManager.cardColor),
                    borderRadius: BorderRadius.circular(14.0.r),
                  ),
                  child: Column(
                    children: [
                      10.0.verticalSpace,
                      DrawableText(
                        text: S.of(context).support,
                        fontWeight: FontWeight.bold,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ).r,
                        matchParent: true,
                        size: 20.0.sp,
                      ),
                      Divider(),
                      ItemMenu(
                        onTap: () {},
                        name: S.of(context).policy,
                        image: Assets.iconsFileList,
                        trailing: ImageMultiType(
                          url: Icons.arrow_forward_ios,
                          height: 15.0.r,
                        ),
                      ),
                      ItemMenu(
                        onTap: () {},
                        name: S.of(context).support,
                        image: Assets.iconsPhoneFlip,
                        trailing: ImageMultiType(
                          url: Icons.arrow_forward_ios,
                          height: 15.0.r,
                        ),
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
                        trailing: ImageMultiType(
                          url: Icons.arrow_forward_ios,
                          height: 15.0.r,
                        ),
                      ),
                      if (AppProvider.isStoreTest)
                        ItemMenu(
                          onTap: () {
                            NoteMessage.showCheckDialog(
                              context,
                              text: 'حذف الحساب',
                              textButton: 'متأكد',
                              image: ImageMultiType(url: Assets.iconsDelete, height: 120.0.r, width: 120.0.r),
                              onConfirm: () {
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
                      ),
                      ItemMenu(
                        onTap: () {},
                        name: S.of(context).devBy,
                        subTitle: 'الحزمة التقنية',
                        withD: false,
                        trailing: ImageMultiType(
                          url: Assets.imagesBandtechLogo,
                          height: 50.0.h,
                          width: 100.0.w,
                        ),
                      ),
                    ],
                  ),
                ),
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
  final bool withD;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0).w,
      padding: const EdgeInsets.symmetric(vertical: 5.0).r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0.r),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => onTap?.call(),
            leading: image == null
                ? null
                : ImageMultiType(
                    height: 24.0.r,
                    width: 24.0.r,
                    url: image,
                  ),
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
            trailing: trailing,
          ),
          10.0.verticalSpace,
          if (withD)
            Divider(
              height: 0,
              color: AppColorManager.cardColor,
              endIndent: 20.0.w,
              indent: 20.0.w,
            ),
        ],
      ),
    );
  }
}
