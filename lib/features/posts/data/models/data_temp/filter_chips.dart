import 'package:ebn_balady/core/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../filters/filter_chip_data.dart';

class FilterChips {
  static List<FilterChipData> all = <FilterChipData>[
    FilterChipData(
      label: AppLocalizations.of(Get.context!)!.hospitals,
      isSelected: false,
      color: AppTheme.green,
    ),
    FilterChipData(
      label: AppLocalizations.of(Get.context!)!.hotels,
      isSelected: false,
      color: AppTheme.red,
    ),
    FilterChipData(
      label: AppLocalizations.of(Get.context!)!.work,
      isSelected: false,
      color: AppTheme.blue,
    ),
    FilterChipData(
      label: AppLocalizations.of(Get.context!)!.studying,
      isSelected: false,
      color: AppTheme.gold,
    ),
    FilterChipData(
      label: AppLocalizations.of(Get.context!)!.eating,
      isSelected: false,
      color: AppTheme.silver,
    ),
  ];
  static initAll() {
    all = [
      FilterChipData(
        label: AppLocalizations.of(Get.context!)!.hospitals,
        isSelected: false,
        color: AppTheme.green,
      ),
      FilterChipData(
        label: AppLocalizations.of(Get.context!)!.hotels,
        isSelected: false,
        color: AppTheme.red,
      ),
      FilterChipData(
        label: AppLocalizations.of(Get.context!)!.work,
        isSelected: false,
        color: AppTheme.blue,
      ),
      FilterChipData(
        label: AppLocalizations.of(Get.context!)!.studying,
        isSelected: false,
        color: AppTheme.gold,
      ),
      FilterChipData(
        label: AppLocalizations.of(Get.context!)!.eating,
        isSelected: false,
        color: AppTheme.silver,
      ),
    ];
  }
}
