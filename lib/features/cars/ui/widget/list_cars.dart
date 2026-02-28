import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/refresh_widget/refresh_widget.dart';
import '../../bloc/cars_cubit/cars_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'item_car.dart';

class ListCars extends StatelessWidget {
  const ListCars({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCubit, CarsInitial>(
      builder: (context, state) {
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          itemCount: state.result.length,
          itemBuilder: (context, index) {
            return ItemCar(car: state.result[index]);
          },
        );
      },
    );
  }
}
