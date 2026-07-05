import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/spinner_widget.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/cities_cubit/cities_cubit.dart';

class CitySpinner extends StatelessWidget {
  const CitySpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesInitial>(
      builder: (context, state) {
        return SpinnerWidget(
          loading: state.loading,
          hintText: S.of(context).city,
          hintLabel: S.of(context).city,
          items: state.getSpinnerItems(selectedId: state.selectedId),
          onChanged: (spinnerItem) {
            context.read<CitiesCubit>().selectCity(spinnerItem.id.toString());
          },
        );
      },
    );
  }
}
