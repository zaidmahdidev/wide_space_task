import 'package:flutter/material.dart';

class AppDropDownField extends StatelessWidget {
  const AppDropDownField(
      {Key? key,
      required this.context,
      this.initialValue,
      required this.items,
      this.onChanged,
      this.hint = '',
      this.hintStyle,
      this.padding,
      this.margin,
      this.backgroundColor,
      this.validator})
      : super(key: key);

  final BuildContext context;
  final dynamic initialValue;
  final List<Map>? items;
  final Function(dynamic)? onChanged;
  final String hint;
  final TextStyle? hintStyle;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        hint: Text(
          hint,
          style: hintStyle ??
              TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.8)),
        ),
        value: initialValue,
        style: TextStyle(
            fontSize: 16.0, color: Theme.of(context).colorScheme.onSurface),
        validator: validator,
        items: (items!
            .map((Map item) => DropdownMenuItem<String>(
                  value: item['name'],
                  child: Text(item['name'],
                      style: const TextStyle(fontSize: 16.0)),
                ))
            .toList()),
        onChanged: onChanged,
        focusColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  width: 0)),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 0)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surface, width: 0)),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  width: 0)),
        ),
      ),
    );
  }
}
