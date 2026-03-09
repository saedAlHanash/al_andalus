import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/core/widgets/my_button.dart';
import 'package:al_andalus/core/widgets/my_text_form_widget.dart';
import 'package:al_andalus/features/auth/ui/widget/upload_container_widget.dart';
import 'package:al_andalus/features/cars/ui/widget/create_car_steps/payment_screen.dart';
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
import '../../bloc/transfer_ownership_cubit/transfer_ownership_cubit.dart';
import '../widget/payment_transfer_screen.dart';

class TransferOwnershipPage extends StatelessWidget {
  const TransferOwnershipPage({super.key});

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
                enable: state.mRequest.canSend,
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
            return PaymentTransferScreen();
          },
        ),
      ),
    );
  }
}
