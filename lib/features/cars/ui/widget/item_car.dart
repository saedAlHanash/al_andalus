import 'package:al_andalus/core/strings/app_color_manager.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/strings/enum_manager.dart';
import '../../data/response/cars_response.dart';

class ItemCar extends StatelessWidget {
  const ItemCar({super.key, required this.car});

  final CarPolicy car;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  color: AppColorManager.mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Icon(Icons.directions_car, color: AppColorManager.mainColor, size: 30.r),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DrawableText(
                      text: car.vehicle.name.isEmpty
                          ? '${car.vehicle.brand} ${car.vehicle.manufactureYear}'
                          : car.vehicle.name,
                      size: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    4.verticalSpace,
                    DrawableText(
                      text: car.vehicle.plateNumber,
                      color: Colors.grey,
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(car.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: DrawableText(
                  text: car.status.name,
                  color: _getStatusColor(car.status),
                  size: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(Icons.settings_input_component, car.vehicle.cylinders),
              _buildInfoItem(Icons.calendar_month, car.vehicle.manufactureYear),
              _buildInfoItem(Icons.color_lens, car.vehicle.color),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: Colors.grey),
        6.horizontalSpace,
        DrawableText(text: value, size: 12.sp, color: Colors.grey.shade700),
      ],
    );
  }

  Color _getStatusColor(InsurancePolicyStatus status) {
    switch (status) {
      case InsurancePolicyStatus.active:
        return Colors.green;
      case InsurancePolicyStatus.missingInfo:
        return Colors.orange;
      case InsurancePolicyStatus.expired:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
