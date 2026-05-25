import 'package:al_andalus/core/widgets/app_bar/app_bar_widget.dart';
import 'package:al_andalus/features/files/ui/pages/pdf_viewer_page.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/util/my_style.dart';
import '../../bloc/policy_cubit/policy_cubit.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PolicyCubit, PolicyInitial>(
      builder: (context, state) {
        if (state.result.data.isUrl) {
          return PdfViewerWidget(url: state.result.data, title: state.mRequest.name);
        }
        return Scaffold(
          appBar: AppBarWidget(titleText: state.mRequest.name),
          body: Builder(
            builder: (context) {
              if (state.loading) {
                return MyStyle.loadingWidget();
              }
              return DrawableText(
                text: state.result.data,
                padding: EdgeInsets.all(20.0).r,
              );
            },
          ),
        );
      },
    );
  }
}
