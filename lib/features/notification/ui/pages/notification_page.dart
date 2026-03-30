import 'package:al_andalus/core/api_manager/api_service.dart';
import 'package:al_andalus/core/app/app_provider.dart';
import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:al_andalus/core/strings/enum_manager.dart';
import 'package:al_andalus/core/util/shared_preferences.dart';
import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/refresh_widget/refresh_widget.dart';
import 'package:collection/collection.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../../../core/app/app_widget.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/need_login_widget.dart';
import '../../../../core/widgets/not_found_widget.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/go_router.dart';
import '../../bloc/all_notification_cubit/all_notification_cubit.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    context.read<NotificationCubit>().getData();
    AppSharedPreference.clearNotificationCount();
    super.initState();
  }

  @override
  void dispose() {
    ctx!.read<NotificationCubit>().getData(newData: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppProvider.isNotLogin) {
      return NeedLoginWidget();
    }
    return BlocConsumer<NotificationCubit, NotificationsInitial>(
      listenWhen: (p, c) => c.done,
      listener: (context, state) {
        context.read<NotificationCubit>().readAll();
      },
      builder: (context, state) {
        final gList = state.result.groupListsBy((element) => element.created?.formatDate).values.toList();

        return state.isDataEmpty
            ? NotFoundNotificationsWidget(
                icon: Assets.iconsBellNotification,
                text: S.of(context).noNotifications,
              )
            : RefreshWidget(
                isLoading: state.loading,
                onRefresh: () {
                  context.read<NotificationCubit>().getData(newData: true);
                },
                child: ListView.separated(
                  itemCount: gList.length,
                  separatorBuilder: (context, i) => 10.0.verticalSpace,
                  itemBuilder: (context, i) {
                    final list = gList[i];
                    if (list.isEmpty) return 0.0.verticalSpace;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 15.0,
                            children: [
                              DrawableText(text: list.first.created?.formatDateNowOrYesterday ?? '-'),
                              Expanded(child: Divider()),
                            ],
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, i) => 10.0.verticalSpace,
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final item = list[i];
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0).r,
                              decoration: BoxDecoration(
                                color: i % 2 != 0 ? null : AppColorManager.cardColor,
                                borderRadius: BorderRadius.circular(10.0.r),
                                boxShadow: i % 2 != 0
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Color(0x14000000),
                                          blurRadius: 26.86,
                                          offset: Offset(0, 3.58),
                                          spreadRadius: 0,
                                        ),
                                      ],
                              ),
                              child: ListTile(
                                onTap: () {
                                  // if (!item.productId.isBlankNumber) {
                                  //   context.pushNamed(
                                  //     RouteName.product,
                                  //     queryParameters: {'id': item.productId.toString()},
                                  //   );
                                  // } else if (!item.orderId.isBlankNumber) {
                                  //   context.pushNamed(
                                  //     RouteName.order,
                                  //     queryParameters: {'id': item.orderId.toString()},
                                  //   );
                                  // }
                                },
                                leading: ImageMultiType(
                                  url: Assets.iconsNotificationCardIcon,
                                  color: AppColorManager.mainColorDynamic,
                                ),
                                title: DrawableText(
                                  text: item.title,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  fontWeight: .bold,
                                  size: 16.0.sp,
                                ),
                                subtitle: DrawableText(
                                  text: item.body,
                                  maxLines: 2,
                                  fontFamily: FontManager.regular.name,
                                  textAlign: TextAlign.start,
                                ),
                                trailing: DrawableText(
                                  text: item.created?.formatDuration() ?? '-',
                                  size: 10.0.sp,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
      },
    );
  }
}
