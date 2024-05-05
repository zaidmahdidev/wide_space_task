import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_validation/flutter_validation.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/mixins/loading_mixin.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../../../../injection_container.dart';
import '../manager/user_bloc.dart';

class ForgetPasswordBottomSheet extends StatefulWidget {
  final String? phoneNumber;

  const ForgetPasswordBottomSheet({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  State<ForgetPasswordBottomSheet> createState() =>
      _ForgetPasswordBottomSheetState();

  static Future<String?> show({
    String? phoneNumber,
  }) async {
    await Get.bottomSheet(
        ForgetPasswordBottomSheet(
          phoneNumber: phoneNumber,
        ),
        isScrollControlled: true,
        isDismissible: false,
        ignoreSafeArea: true);
  }
}

enum ForgetStep {
  phoneStep,
  otpStep,
  resetPasswordStep,
}

class _ForgetPasswordBottomSheetState extends State<ForgetPasswordBottomSheet>
    with LoadingStateMixin {
  static final _phoneKey = GlobalKey<FormFieldState>();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ForgetStep _forgetStep = ForgetStep.phoneStep;
  String _phoneNumber = "";
  String _otp = "";
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();

  late String _newPassword;
  bool newPasswordObscureText = true;
  bool newPasswordConfirmationObscureText = true;
  IconData newPasswordIcon = Icons.visibility;
  IconData newPasswordConfirmationIcon = Icons.visibility;

  @override
  void initState() {
    if (widget.phoneNumber != null) {
      setState(() {
        _phoneNumber = widget.phoneNumber!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sl<UserBloc>(),
      child: Builder(builder: (context) {
        return BlocProvider(
          create: (context) => sl<UserBloc>(),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (_context, state) {
              logger.d("state listener is $state");
              if (state is UserError) {
                isLoading = false;
                showFlushBar(state.message, context: context);
              } else if (state is ReSendOTPError) {
                showFlushBar(state.message, context: context);
                isLoading = false;
              } else if (state is ReSendOTPLoaded) {
                isLoading = false;
                showFlushBar(AppLocalizations.of(context)!.otpReSent,
                    error: false, context: context);
              } else if (state is ForgetPasswordOtpSent) {
                showFlushBar(AppLocalizations.of(context)!.otpSent,
                    error: false, context: context);
                isLoading = false;
                setState(() {
                  _forgetStep = ForgetStep.otpStep;
                });
              } else if (state is PasswordResetCompleted) {
                isLoading = false;
                Get.back(result: _phoneNumber);
                showFlushBar(AppLocalizations.of(context)!.passwordChanged,
                    error: false, context: context);
              }
            },
            listenWhen: (oldState, newState) => true,
            buildWhen: (oldState, newState) => false,
            builder: (_context, state) {
              logger.d("state builder is $state");
              return Wrap(
                children: [
                  Stack(
                    children: [
                      Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(24.0).copyWith(bottom: 0),
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
                            if (_forgetStep == ForgetStep.phoneStep) {
                              return _buildPhoneStep(_context);
                            } else if (_forgetStep == ForgetStep.otpStep) {
                              return _buildOtpStep(_context);
                            } else if (_forgetStep ==
                                ForgetStep.resetPasswordStep) {
                              return _buildResetPasswordStep(_context);
                            }
                            return const SizedBox();
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
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  _buildPhoneStep(_context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Center(
          child: Text(
            AppLocalizations.of(_context)!.forgetPassword,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          AppLocalizations.of(_context)!.forgetPasswordDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(
          height: 24,
        ),
        AppTextFormField(
          context: context,
          widgetKey: _phoneKey,
          initialValue: _phoneNumber,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
          margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 18.0),
          hintText: AttributeLocalizations.of(context)!.phone,
          validator: MultiValidator([
            Validator.of(context)!.pattern(
              AttributeLocalizations.of(context)!.phone,
              r'\d+',
            ),
            Validator.of(context)!
                .required(AttributeLocalizations.of(context)!.phone),
            Validator.of(context)!.pattern(
                AttributeLocalizations.of(context)!.phone, r'[7][7|1|3|7|0]'),
            Validator.of(context)!.length(
              AttributeLocalizations.of(context)!.phone,
              9,
            )
          ]),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'\d+')),
            LengthLimitingTextInputFormatter(9),
          ],
          keyboardType: const TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),
          onChanged: (phoneValue) {
            setState(() {
              _phoneNumber = phoneValue;
            });
          },
        ),
        PrimaryButton(
          edgeInsetsMargin: EdgeInsets.zero,
          edgeInsetsPadding: const EdgeInsets.symmetric(vertical: 12),
          text: AppLocalizations.of(context)!.sendOTP,
          pending: isLoading,
          onTap: () {
            if (_phoneKey.currentState!.validate()) {
              isLoading = true;
              BlocProvider.of<UserBloc>(_context).add(ForgetPassword(
                phoneNumber: parsePhone(_phoneNumber)!,
              ));
            }
          },
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  _buildOtpStep(_context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Text(
          AppLocalizations.of(_context)!.enterSixDigitsCode,
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(
          AppLocalizations.of(_context)!.enterSixDigitsCodeDescription,
          style: Theme.of(context).textTheme.subtitle2?.copyWith(
                color: Colors.black54,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                child: PinCodeTextField(
                  autoFocus: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appContext: context,
                  length: 6,
                  controller: TextEditingController(text: _otp),
                  obscureText: false,
                  animationType: AnimationType.scale,
                  pinTheme: PinTheme(
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    borderWidth: .8,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: sameOnRotate(divideOn: 8.5),
                    fieldWidth: sameOnRotate(divideOn: 9),
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                    LengthLimitingTextInputFormatter(9),
                  ],
                  keyboardType: const TextInputType.numberWithOptions(
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
                  onCompleted: (v) {
                    setState(() {
                      _otp = v;
                      _forgetStep = ForgetStep.resetPasswordStep;
                    });
                  },
                  onChanged: (value) {
                    _otp = value;
                  },
                  beforeTextPaste: (text) {
                    logger.d("Allowing to paste $text");
                    return isNumeric(text);
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _forgetStep = ForgetStep.phoneStep;
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!.previous,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: PrimaryButton(
                      edgeInsetsMargin: EdgeInsets.zero,
                      edgeInsetsPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                      text: AppLocalizations.of(context)!.next,
                      pending: isLoading,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (_otp.length != 6) {
                          errorController.add(ErrorAnimationType.shake);
                          return;
                        }
                        setState(() {
                          _forgetStep = ForgetStep.resetPasswordStep;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ArgonTimerButton(
          splashColor: Colors.transparent,
          height: 50,
          width: ScreenUtil.screenWidth,
          minWidth: ScreenUtil.screenWidth,
          highlightColor: Colors.transparent,
          highlightElevation: 0,
          onTap: (startTimer, btnState) {
            if (btnState == ButtonState.Idle) {
              BlocProvider.of<UserBloc>(_context).add(const ReSendOTP());
              startTimer(60);
            }
            if (btnState == ButtonState.Busy) {
              showFlushBar(AppLocalizations.of(context)!.waitForTimer,
                  context: context);
            }
          },
          initialTimer: 60,
          loader: (timeLeft) {
            return Text(
              "${AppLocalizations.of(context)!.resendCode} $timeLeft",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.grey),
            );
          },
          color: Colors.transparent,
          elevation: 0,
          child: Text(
            AppLocalizations.of(context)!.resendCode,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  _buildResetPasswordStep(_context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: ScreenUtil.screenHeightNoPadding * .8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12.0,
            ),
            Text(
              AppLocalizations.of(_context)!.resetPassword,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              AppLocalizations.of(_context)!.resetPasswordDescription,
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(
              height: 24,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12.0,
                  ),
                  AppTextFormField(
                    context: context,
                    enabled: !isLoading,
                    obscureText: newPasswordObscureText,
                    hintText: AppLocalizations.of(context)!.newPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        newPasswordIcon,
                        color: Colors.grey,
                      ),
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          newPasswordIcon == Icons.visibility
                              ? newPasswordIcon = Icons.visibility_off
                              : newPasswordIcon = Icons.visibility;
                          newPasswordObscureText = !newPasswordObscureText;
                        });
                      },
                    ),
                    onChanged: (newPassword) {
                      _newPassword = newPassword;
                    },
                    validator: MultiValidator([
                      Validator.of(context)!.required(
                        AppLocalizations.of(context)!.newPassword,
                      ),
                    ]),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {},
                  ),
                  AppTextFormField(
                    context: context,
                    enabled: !isLoading,
                    obscureText: newPasswordConfirmationObscureText,
                    hintText:
                        AppLocalizations.of(context)!.newPasswordConfirmation,
                    suffixIcon: IconButton(
                      icon: Icon(
                        newPasswordConfirmationIcon,
                        color: Colors.grey,
                      ),
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          newPasswordConfirmationIcon == Icons.visibility
                              ? newPasswordConfirmationIcon =
                                  Icons.visibility_off
                              : newPasswordConfirmationIcon = Icons.visibility;
                          newPasswordConfirmationObscureText =
                              !newPasswordConfirmationObscureText;
                        });
                      },
                    ),
                    validator: MultiValidator([
                      Validator.of(context)!.required(
                        AppLocalizations.of(context)!.newPasswordConfirmation,
                      ),
                      Validator.of(context)!.match(
                        AppLocalizations.of(context)!.newPasswordConfirmation,
                        AppLocalizations.of(context)!.newPassword,
                        () => _newPassword,
                      ),
                    ]),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {},
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _forgetStep = ForgetStep.otpStep;
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!.previous,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PrimaryButton(
                      edgeInsetsMargin: EdgeInsets.zero,
                      edgeInsetsPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                      text: AppLocalizations.of(context)!.resetPassword,
                      pending: isLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          _formKey.currentState!.save();

                          BlocProvider.of<UserBloc>(_context).add(ResetPassword(
                            phoneNumber: _phoneNumber,
                            password: _newPassword,
                            otp: _otp,
                          ));
                          isLoading = true;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
