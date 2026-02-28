import 'package:al_andalus/features/cars/data/generic_car_internal_option.dart';
import 'package:al_andalus/features/cars/ui/widget/generic_car_external_widget.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/l10n.dart';
import '../../../bloc/cars_cubit/cars_cubit.dart';

class CarPreview extends StatefulWidget {
  const CarPreview({super.key});

  @override
  State<CarPreview> createState() => _CarPreviewState();
}

class _CarPreviewState extends State<CarPreview> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCubit, CarsInitial>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0).r,
          children: [
            GenericCarExternalWidget(
              title: S.of(context).exteriorBody,
              options: [
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.metalBody,
                  onOptionChanged: (e) => state.mRequest.metalBody = e,
                  onDetailsButtonTap: (e) => state.mRequest.metalBodyNote = e,
                  note: () => state.mRequest.metalBodyNote,
                  title: S.of(context).metalBody,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.chromeNickel,
                  onOptionChanged: (e) => state.mRequest.chromeNickel = e,
                  onDetailsButtonTap: (e) => state.mRequest.chromeNickelNote = e,
                  note: () => state.mRequest.chromeNickelNote,
                  title: S.of(context).chromeNickel,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.brandSign,
                  onOptionChanged: (e) => state.mRequest.brandSign = e,
                  onDetailsButtonTap: (e) => state.mRequest.brandSignNote = e,
                  note: () => state.mRequest.brandSignNote,
                  title: S.of(context).brandSign,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.windshieldWipers,
                  onOptionChanged: (e) => state.mRequest.windshieldWipers = e,
                  onDetailsButtonTap: (e) => state.mRequest.windshieldWipersNote = e,
                  note: () => state.mRequest.windshieldWipersNote,
                  title: S.of(context).windshieldWipers,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.radioAntenna,
                  onOptionChanged: (e) => state.mRequest.radioAntenna = e,
                  onDetailsButtonTap: (e) => state.mRequest.radioAntennaNote = e,
                  note: () => state.mRequest.radioAntennaNote,
                  title: S.of(context).radioAntenna,
                ),
              ],
            ),
            20.0.verticalSpace,
            GenericCarExternalWidget(
              title: S.of(context).interiorBody,
              options: [
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.seats,
                  onOptionChanged: (e) => state.mRequest.seats = e,
                  onDetailsButtonTap: (e) => state.mRequest.seatsNote = e,
                  note: () => state.mRequest.seatsNote,
                  title: S.of(context).seats,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.floorCover,
                  onOptionChanged: (e) => state.mRequest.floorCover = e,
                  onDetailsButtonTap: (e) => state.mRequest.floorCoverNote = e,
                  note: () => state.mRequest.floorCoverNote,
                  title: S.of(context).floorCover,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.radio,
                  onOptionChanged: (e) => state.mRequest.radio = e,
                  onDetailsButtonTap: (e) => state.mRequest.radioNote = e,
                  note: () => state.mRequest.radioNote,
                  title: S.of(context).radioAndType,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.airConditioner,
                  onOptionChanged: (e) => state.mRequest.airConditioner = e,
                  onDetailsButtonTap: (e) => state.mRequest.airConditionerNote = e,
                  note: () => state.mRequest.airConditionerNote,
                  title: S.of(context).airConditionerAndType,
                ),
              ],
            ),
            20.0.verticalSpace,
            GenericCarExternalWidget(
              title: S.of(context).glassAndLamps,
              options: [
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.glassAndLamps,
                  onOptionChanged: (e) => state.mRequest.glassAndLamps = e,
                  onDetailsButtonTap: (e) => state.mRequest.glassAndLampsNote = e,
                  note: () => state.mRequest.glassAndLampsNote,
                  title: S.of(context).glassAndLamps,
                ),
              ],
            ),
            20.0.verticalSpace,
            GenericCarExternalWidget(
              title: S.of(context).tiresAndAccessories,
              options: [
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.frontTires,
                  onOptionChanged: (e) => state.mRequest.frontTires = e,
                  onDetailsButtonTap: (e) => state.mRequest.frontTiresNote = e,
                  note: () => state.mRequest.frontTiresNote,
                  title: S.of(context).frontTires,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.backTires,
                  onOptionChanged: (e) => state.mRequest.backTires = e,
                  onDetailsButtonTap: (e) => state.mRequest.backTiresNote = e,
                  note: () => state.mRequest.backTiresNote,
                  title: S.of(context).backTires,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.spareTire,
                  onOptionChanged: (e) => state.mRequest.spareTire = e,
                  onDetailsButtonTap: (e) => state.mRequest.spareTireNote = e,
                  note: () => state.mRequest.spareTireNote,
                  title: S.of(context).spareTire,
                ),
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.tiresCovers,
                  onOptionChanged: (e) => state.mRequest.tiresCovers = e,
                  onDetailsButtonTap: (e) => state.mRequest.tiresCoversNote = e,
                  note: () => state.mRequest.tiresCoversNote,
                  title: S.of(context).tiresCovers,
                ),
              ],
            ),
            20.0.verticalSpace,
            GenericCarExternalWidget(
              title: S.of(context).spareToolsGroup,
              options: [
                GenericCarInternalOption(
                  groupValue: () => state.mRequest.spareTools,
                  onOptionChanged: (e) => state.mRequest.spareTools = e,
                  onDetailsButtonTap: (e) => state.mRequest.spareToolsNote = e,
                  note: () => state.mRequest.spareToolsNote,
                  title: S.of(context).spareTools,
                ),
              ],
            ),
            20.0.verticalSpace,
            StatefulBuilder(
              builder: (context, setStateChecked) {
                return CheckboxListTile(
                  value: state.mRequest.carPreviewInfoCheck,
                  onChanged: (value) {
                    setStateChecked(() => state.mRequest.carPreviewInfoCheck = value ?? false);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: DrawableText(
                    size: 12.0.sp,
                    text: S.of(context).declarationText,
                  ),
                );
              },
            ),
            20.0.verticalSpace,
          ],
        );
      },
    );
  }
}
