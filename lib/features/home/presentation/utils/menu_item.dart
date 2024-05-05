import 'package:flutter/material.dart';

class DrawerMenuItem {
  String title;
  final IconData? icon;
  final String? assetIcon;

  DrawerMenuItem({required this.title, this.icon, this.assetIcon});

  @override
  String toString() {
    return title;
  }
}
