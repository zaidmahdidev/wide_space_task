import 'dart:async';

import 'package:ebn_balady/core/constants.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/mixins/loading_mixin.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../injection_container.dart';
import '../manager/user_bloc.dart';

class LogPasswordBottomSheet extends StatefulWidget {
  const LogPasswordBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<LogPasswordBottomSheet> createState() => _LogPasswordBottomSheetState();

  static Future<bool?> show() async {
    return await Get.bottomSheet(const LogPasswordBottomSheet(),
        isScrollControlled: true, isDismissible: false, ignoreSafeArea: true);
  }
}

class _LogPasswordBottomSheetState extends State<LogPasswordBottomSheet>
    with LoadingStateMixin {
  String passwordCode = "";
  late String correctKey;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();

  @override
  void initState() {
    correctKey = sl<FirebaseRemoteConfig>().getString('logSecretCode');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sl<UserBloc>(),
      child: Builder(builder: (context) {
        return Wrap(
          children: [
            Stack(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0).copyWith(bottom: 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.03),
                            blurRadius: 8,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Builder(builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .enterLogSecretPassword,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .enterLogSecretPasswordDescription,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0, vertical: 8.0),
                                  child: PinCodeTextField(
                                    autoFocus: true,
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    appContext: context,
                                    length: 6,
                                    controller: TextEditingController(
                                        text: passwordCode),
                                    obscureText: false,
                                    animationType: AnimationType.scale,
                                    pinTheme: PinTheme(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      inactiveColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2),
                                      borderWidth: .8,
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: sameOnRotate(divideOn: 8.5),
                                      fieldWidth: sameOnRotate(divideOn: 9),
                                    ),
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    enableActiveFill: false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'\d+')),
                                      LengthLimitingTextInputFormatter(9),
                                    ],
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false,
                                    ),
                                    boxShadows: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(.01),
                                          blurRadius: 10,
                                          spreadRadius: 4)
                                    ],
                                    errorAnimationController: errorController,
                                    onCompleted: (value) {
                                      setState(() {
                                        passwordCode = value;
                                      });

                                      Get.back(
                                          result: passwordCode == correctKey);
                                    },
                                    onChanged: (value) {
                                      passwordCode = value;
                                    },
                                    beforeTextPaste: (text) {
                                      logger.d("Allowing to paste $text");
                                      return isNumeric(text);
                                    },
                                  ),
                                ),
                                PrimaryButton(
                                  edgeInsetsMargin: EdgeInsets.zero,
                                  edgeInsetsPadding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  text: AppLocalizations.of(context)!.done,
                                  pending: isLoading,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    if (passwordCode.length != 6) {
                                      errorController
                                          .add(ErrorAnimationType.shake);
                                      return;
                                    }
                                    Get.back(
                                        result: passwordCode == correctKey);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      );
                    })),
                Positioned(
                  top: 0,
                  right: 70,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: .02,
                      child: Image.asset(
                        '${imagesPath}logo.png',
                        height: ScreenUtil.screenHeight / 1.5,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.drag_handle,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
