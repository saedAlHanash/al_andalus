import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

import '../strings/app_color_manager.dart';
import '../strings/enum_manager.dart';

/// [MapHelper] is a production-ready utility class for launching map applications.
/// It follows the singleton pattern for efficient resource management.
class MapHelper {
  MapHelper._();

  static final MapHelper _instance = MapHelper._();

  static MapHelper get instance => _instance;


  /// Displays a BottomSheet with all available map apps on the device.
  Future<void> showMapSelectionSheet({
    required BuildContext context,
    required double latitude,
    required double longitude,
    required String title,
  }) async {
    try {
      final installedMaps = await MapLauncher.installedMaps;

      if (!context.mounted) return;

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0.r)),
        ),
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.h, horizontal: 16.0.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DrawableText(
                    text: 'اختر تطبيق الخرائط',
                    size: 18.0.spMin,
                    fontFamily: FontManager.bold.name,
                    color: AppColorManager.mainColor,
                  ),
                  SizedBox(height: 20.0.h),
                  SizedBox(
                    height: 120.0.h,
                    child: installedMaps.isEmpty
                        ? Center(child: _buildNoMapsFound())
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                            itemCount: installedMaps.length,
                            separatorBuilder: (_, __) => SizedBox(width: 20.0.w),
                            itemBuilder: (context, index) {
                              final map = installedMaps[index];
                              return _buildMapCard(
                                context: context,
                                map: map,
                                latitude: latitude,
                                longitude: longitude,
                                title: title,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Error launching map selection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء محاولة فتح الخرائط')),
      );
    }
  }

  /// Builds an individual horizontal card for a map application.
  Widget _buildMapCard({
    required BuildContext context,
    required AvailableMap map,
    required double latitude,
    required double longitude,
    required String title,
  }) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);

        // Opening map without 'origin' - the map app will use its own internal location logic
        await map.showDirections(
          destination: Coords(latitude, longitude),
          destinationTitle: title,
          directionsMode: DirectionsMode.driving,
        );
      },
      borderRadius: BorderRadius.circular(12.0.r),
      child: Container(
        width: 100.0.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0).r,
          color: AppColorManager.lightGray,
        ),
        padding: EdgeInsets.all(8.0.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0.r),
              child: SvgPicture.asset(
                map.icon,
                height: 50.0.r,
                width: 50.0.r,
              ),
            ),
            SizedBox(height: 10.0.h),
            DrawableText(
              text: map.mapName,
              size: 14.0.spMin,
              fontFamily: FontManager.semeBold.name,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  /// Fallback UI when no map apps are detected.
  Widget _buildNoMapsFound() {
    return DrawableText(
      text: 'لم يتم العثور على تطبيقات خرائط مثبتة',
      size: 14.0.spMin,
      color: Colors.grey,
    );
  }
}
