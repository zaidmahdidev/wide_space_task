import 'package:flutter/material.dart';

import '../app_theme.dart';

class OutlinePrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final void Function() onTap;
  final EdgeInsets edgeInsets;

  const OutlinePrimaryButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.color = AppTheme.primaryColor,
    this.edgeInsets =
        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: edgeInsets,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: color, width: 1.5)),
            child: Center(
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontSize: 18.0, fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
