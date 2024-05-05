import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ebn_balady/core/app_theme.dart';
import 'package:flutter/material.dart';

class AppDropDownMenu extends StatefulWidget {
  const AppDropDownMenu(
      {Key? key,
      required this.text,
      this.items,
      this.style,
      this.onChanged,
      this.onSaved,
      this.textValidator,
      required this.color,
      required this.selectedValue})
      : super(key: key);
  final String text;
  final String? selectedValue;
  final TextStyle? style;
  final Color color;
  final List<DropdownMenuItem<Object>>? items;
  final String? textValidator;
  final void Function(Object?)? onChanged, onSaved;

  @override
  State<AppDropDownMenu> createState() => _AppDropDownMenuState();
}

class _AppDropDownMenuState extends State<AppDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField2(
        value: widget.selectedValue,
        decoration: InputDecoration(
          fillColor: widget.color,
          filled: true,
          errorStyle: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: AppTheme.errorColor),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          labelStyle: widget.style,
        ),
        isExpanded: true,
        hint: Text(
          widget.text,
          style: widget.style,
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
        buttonHeight: 60,
        buttonPadding: const EdgeInsets.only(left: 20, right: 10),
        dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).scaffoldBackgroundColor),
        items: widget.items,
        validator: (value) {
          if (value == null) {
            return widget.textValidator;
          }
          return null;
        },
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
      ),
    );
  }
}
