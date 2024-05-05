import 'package:contacts_service/contacts_service.dart';
import 'package:ebn_balady/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pages/qr_code_scanner.dart';
import '../utils/common_utils.dart';

//ignore: must_be_immutable
class AppTextFormField extends StatefulWidget {
  final BuildContext context;
  final String? hintText;
  final String? initialValue;
  final Widget? icon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool? enabled;
  final bool readOnly;
  final EdgeInsets padding;
  final double radius;
  final Color? color;
  final Color? cursorColor;
  final bool autoFocus;
  final BoxDecoration? decoration;
  final EdgeInsets? margin;
  final TextEditingController? controller;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextStyle? style;
  final TextInputAction textInputAction;
  final bool enablePhonePicker;
  final bool enableSuggestions;
  final bool enableQRScanner;
  final GlobalKey<FormFieldState>? widgetKey;

  AppTextFormField({
    Key? key,
    required this.context,
    this.widgetKey,
    this.hintText,
    this.initialValue,
    this.icon,
    this.suffixIcon,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.decoration,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines = 1,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.validator,
    this.enabled = true,
    this.radius = 8,
    this.margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.obscureText = false,
    this.color,
    this.cursorColor,
    this.autoFocus = false,
    this.controller,
    this.textInputAction = TextInputAction.none,
    this.hintStyle,
    this.style,
    this.errorStyle,
    this.readOnly = false,
    this.enablePhonePicker = false,
    this.enableSuggestions = false,
    this.enableQRScanner = false,
  }) : super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: widget.decoration,
      child: TextFormField(
        textAlign: isRTL(widget.controller?.text ?? "", widget.context)
            ? TextAlign.right
            : TextAlign.left
        // isRTL(widget.controller?.text ?? "", widget.context)
        //     ? Get.locale == const Locale('ar', 'YE')
        //         ? isRTL(widget.controller?.text ?? "", widget.context)
        //         : TextAlign.end
        //     : Get.locale == const Locale('en', 'US')
        //         ? TextAlign.end
        //         : TextAlign.start,
        ,
        cursorColor: widget.cursorColor,
        key: widget.widgetKey,
        style: widget.style ??
            Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold),
        initialValue: widget.initialValue,
        autofocus: widget.autoFocus,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        enableInteractiveSelection: true,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTap: widget.onTap,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        decoration: InputDecoration(
            filled: true,
            fillColor: widget.color ?? Theme.of(context).colorScheme.surface,
            prefixIcon: widget.icon,
            suffixIcon: widgetInputSuffixIcon(
                context: context, suffixIcon: widget.suffixIcon),
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ??
                Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8)),
            contentPadding: widget.padding,
            border: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: BorderSide.none,
            ),
            errorStyle: widget.errorStyle ??
                Theme.of(context).inputDecorationTheme.errorStyle),
        textInputAction: widget.textInputAction,
        readOnly: widget.readOnly,
        enableSuggestions: widget.enableSuggestions,
      ),
    );
  }

  Future<void> pickContact(context) async {
    final hasPermission = await Permission.contacts.isGranted;
    if (hasPermission) {
      if (widget.controller != null && widget.onChanged != null) {
        try {
          widget.controller!.text = await getPhoneFromNativeContact();
          widget.onChanged!(widget.controller!.text);
          FocusScope.of(context).nextFocus();
        } catch (e) {
          logger.d(e);
        }
      }
    } else {
      final permission = await Permission.contacts.request();
      if (permission.isGranted) {
        if (widget.controller != null && widget.onChanged != null) {
          try {
            widget.controller!.text = await getPhoneFromNativeContact();
            widget.onChanged!(widget.controller!.text);
            FocusScope.of(context).nextFocus();
          } catch (e) {
            logger.d(e);
          }
        }
      }
    }
  }

  Future<void> pickQRCode(context) async {
    String? codeOrPhone = await Get.to(
      QRCodeScanPage(
        title: AppLocalizations.of(context)!.scan(widget.hintText ?? ''),
      ),
    );
    if (codeOrPhone != null && widget.controller != null) {
      if (widget.validator == null ||
          (widget.validator != null &&
              widget.validator!(codeOrPhone) == null)) {
        // if there is validator validate
        widget.controller!.text = codeOrPhone;
      } else {
        await showFlushBar(
          AppLocalizations.of(context)!.wrongQRFormat,
          context: context,
        );
      }
    }
  }

  Future<String> getPhoneFromNativeContact() async {
    return await ContactsService.openDeviceContactPicker().then((value) {
      return value!.phones!.first.value
          .toString()
          .replaceAll(' ', '')
          .replaceAll(RegExp(r'^(967|\+967|00967)|(\s|\W)'), '');
    });
  }

  Widget? widgetInputSuffixIcon(
      {required BuildContext context, Widget? suffixIcon}) {
    if (widget.enablePhonePicker) {
      return IconButton(
        splashRadius: 1,
        icon: const Icon(Icons.perm_contact_calendar),
        onPressed: () async {
          await pickContact(context);
        },
      );
    } else if (widget.enableQRScanner) {
      return IconButton(
        splashRadius: 1,
        icon: const Icon(Icons.qr_code_scanner),
        onPressed: () async {
          await pickQRCode(context);
        },
      );
    } else {
      return suffixIcon;
    }
  }
}
