import 'package:flutter/material.dart';

class ChoiceChipData {
  final String label;
  final bool isSelected;
  Color textColor;
  Color selectedColor;

  ChoiceChipData({
    required this.label,
    required this.isSelected,
    required this.textColor,
    required this.selectedColor,
  });

  ChoiceChipData copy({
    required String label,
    required bool isSelected,
    required Color textColor,
    required Color selectedColor,
  }) =>
      ChoiceChipData(
        label: label,
        isSelected: isSelected,
        textColor: textColor,
        selectedColor: selectedColor,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChoiceChipData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          textColor == other.textColor &&
          selectedColor == other.selectedColor;

  @override
  int get hashCode =>
      label.hashCode ^ textColor.hashCode ^ selectedColor.hashCode;
}
