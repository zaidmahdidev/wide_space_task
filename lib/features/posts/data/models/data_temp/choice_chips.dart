import 'package:ebn_balady/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../filters/choice_chip_data.dart';

class ChoiceChips {
  static List<ChoiceChipData> filtersList = <ChoiceChipData>[
    ChoiceChipData(
      label: AppLocalizations.of(Get.context!)!.all,
      isSelected: true,
      selectedColor: AppTheme.primaryColor,
      textColor: Colors.white,
    ),
    ChoiceChipData(
      label: AppLocalizations.of(Get.context!)!.mine,
      isSelected: false,
      selectedColor: AppTheme.secondaryColor,
      textColor: Colors.white,
    ),
  ];
  static initFiltersList() {
    filtersList = [
      ChoiceChipData(
        label: AppLocalizations.of(Get.context!)!.all,
        isSelected: true,
        selectedColor: AppTheme.primaryColor,
        textColor: Colors.white,
      ),
      ChoiceChipData(
        label: AppLocalizations.of(Get.context!)!.mine,
        isSelected: false,
        selectedColor: AppTheme.secondaryColor,
        textColor: Colors.white,
      ),
    ];
  }

  static List<ChoiceChipData> getMapList(bool isList) {
    return <ChoiceChipData>[
      ChoiceChipData(
        label: AppLocalizations.of(Get.context!)!.list,
        isSelected: isList,
        selectedColor: AppTheme.primaryColor,
        textColor: Colors.white,
      ),
      ChoiceChipData(
        label: AppLocalizations.of(Get.context!)!.map,
        isSelected: !isList,
        selectedColor: AppTheme.secondaryColor,
        textColor: Colors.white,
      ),
    ];
  }

  static List<ChoiceChipData> getPostList(bool isAll) {
    return <ChoiceChipData>[
      ChoiceChipData(
        label: AppLocalizations.of(Get.context!)!.all,
        isSelected: isAll,
        selectedColor: AppTheme.primaryColor,
        textColor: Colors.white,
      ),
      ChoiceChipData(
        label: AppLocalizations.of(Get.context!)!.mine,
        isSelected: !isAll,
        selectedColor: AppTheme.secondaryColor,
        textColor: Colors.white,
      ),
    ];
  }

  static List<ChoiceChipData> getNotificationList(bool isAll) {
    return <ChoiceChipData>[
      ChoiceChipData(
        label: AppLocalizations.of(Get.context!)!.all,
        isSelected: isAll,
        selectedColor: AppTheme.primaryColor,
        textColor: Colors.white,
      ),
      ChoiceChipData(
        label: AppLocalizations.of(Get.context!)!.unread,
        isSelected: !isAll,
        selectedColor: AppTheme.secondaryColor,
        textColor: Colors.white,
      ),
    ];
  }
}
