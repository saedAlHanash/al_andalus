import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/assets.dart';
import '../../../../router/go_router.dart';
import '../../bloc/all_notification_cubit/all_notification_cubit.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationsInitial>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            context.pushNamed(RouteName.notifications);
          },
          icon: ImageMultiType(
            url: Assets.iconsNotification,
            color: state.result.any((element) => !element.isRead) ? Colors.red : null,
          ),
        );
      },
    );
  }
}
