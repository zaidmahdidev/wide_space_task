import 'package:flutter/material.dart';

mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  @protected
  set isLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }
}