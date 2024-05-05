import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrimaryTextButton extends StatelessWidget {
  final String text;
  final Function onTap;
  TextStyle? style;
  final EdgeInsets padding;

  PrimaryTextButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.style,
      this.padding = const EdgeInsets.all(8.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    style ??= Theme.of(context).textTheme.subtitle2!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: style,
          ),
        ),
        onTap: () {
          onTap();
        },
      ),
    );
  }
}
