class InputChipData {
  final String label;
  final String urlAvatar;

  InputChipData({
    required this.label,
    required this.urlAvatar,
  });

  InputChipData copy({
    required String label,
    required String urlAvatar,
  }) =>
      InputChipData(
        label: label,
        urlAvatar: urlAvatar,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputChipData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          urlAvatar == other.urlAvatar;

  @override
  int get hashCode => label.hashCode ^ urlAvatar.hashCode;
}
