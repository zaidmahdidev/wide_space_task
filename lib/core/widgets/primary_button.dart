import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final void Function() onTap;
  final EdgeInsets? edgeInsetsMargin;
  final EdgeInsets? edgeInsetsPadding;
  final bool pending;
  final bool fullWidth;
  final TextStyle? textStyle;
  final BorderRadius? radius;
  final double loadingIconSize;
  final double? textHeight;
  final bool disabled;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
    this.edgeInsetsMargin,
    this.edgeInsetsPadding,
    this.pending = false,
    this.textColor,
    this.fullWidth = true,
    this.textStyle,
    this.radius,
    this.textHeight = 1.5,
    this.loadingIconSize = 18.0,
    this.disabled = false,
  }) : super(key: key);

  const PrimaryButton.small({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
    this.edgeInsetsMargin,
    this.edgeInsetsPadding,
    this.pending = false,
    this.textColor,
    this.fullWidth = true,
    this.textStyle,
    this.radius,
    this.textHeight,
    this.loadingIconSize = 12.0,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: edgeInsetsMargin ?? const EdgeInsets.all(16),
      child: Material(
        color: disabled
            ? (color ?? Theme.of(context).colorScheme.primary).withOpacity(.5)
            : (color ?? Theme.of(context).colorScheme.primary),
        borderRadius: radius ?? BorderRadius.circular(8.0),
        child: InkWell(
          highlightColor: Theme.of(context).colorScheme.surface,
          onTap: !pending ? onTap : null,
          child: Container(
            padding: edgeInsetsPadding ??
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
            width: fullWidth ? double.infinity : null,
            decoration: BoxDecoration(
                color: disabled
                    ? (color ?? Theme.of(context).colorScheme.primary)
                        .withOpacity(.5)
                    : (color ?? Theme.of(context).colorScheme.primary),
                borderRadius: radius ?? BorderRadius.circular(8.0)),
            child: Center(
              child: pending
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SpinKitThreeBounce(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: loadingIconSize,
                      ),
                    )
                  : Text(
                      text,
                      textAlign: TextAlign.center,
                      style: textStyle ??
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: (textColor ??
                                  Theme.of(context).colorScheme.onPrimary),
                              height: textHeight),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryButtonWithIcon extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final void Function() onTap;
  final EdgeInsets edgeInsets;
  final bool pending;
  final Widget? icon;

  const PrimaryButtonWithIcon({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
    this.edgeInsets =
        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
    this.pending = false,
    this.icon,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      onTap: onTap,
      child: Container(
        margin: edgeInsets,
        padding: const EdgeInsets.all(12.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: (color ?? Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(8.0)),
        child: Center(
          child: pending
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SpinKitThreeBounce(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 16.0,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        text,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: (textColor ??
                                    Theme.of(context).colorScheme.onPrimary)),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      icon ?? const SizedBox.shrink()
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
