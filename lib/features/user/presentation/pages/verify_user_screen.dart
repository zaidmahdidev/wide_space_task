import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:ebn_balady/features/home/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/mixins/loading_mixin.dart';
import '../../../../core/models/current_provider.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../injection_container.dart';
import '../../data/models/user_model.dart';
import '../manager/user_bloc.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key, required this.currentUser}) : super(key: key);
  final UserModel currentUser;

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> with LoadingStateMixin {
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // sendOTP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => sl<UserBloc>(),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (_context, state) {
              logger.d('state listener is $state');

              if (state is ReSendOTPError) {
                showFlushBar(state.message, context: context);
                isLoading = false;
              } else if (state is ReSendOTPLoaded) {
                isLoading = false;
                showFlushBar(AppLocalizations.of(context)!.otpReSent,
                    error: false, context: context);
              }

              if (state is VerificationError) {
                showFlushBar(state.message, context: context);
                isLoading = false;
              } else if (state is VerificationLoaded) {
                isLoading = false;
                Current.user = state.user;
                Get.offAll(() => const MainScreen());
              }
            },
            builder: (_context, state) {
              logger.d('state builder is $state');
              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: ScreenUtil.screenHeightNoPadding -
                          (MediaQuery.of(context).viewInsets.bottom / 6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: ScreenUtil.screenHeight * .2,
                          ),
                          Container(
                            margin: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  '${imagesPath}logo.png',
                                  width: ScreenUtil.screenWidth * .3,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Flexible(
                                  child: Hero(
                                    tag: 'header_title',
                                    child: RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .appName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Hero(
                                    tag: 'header_sub_title',
                                    child: Text(
                                      AppLocalizations.of(context)!.appSlogan,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              height: 1.4,
                                              fontWeight: FontWeight.w400),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.enterCode} ${widget.currentUser.phones![0].substring(3)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              ],
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 8.0),
                              child: PinCodeTextField(
                                autoFocus: true,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                appContext: context,
                                length: 6,
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
                                controller: textEditingController,
                                onCompleted: (v) {
                                  if (!isLoading) {
                                    isLoading = true;
                                    BlocProvider.of<UserBloc>(_context).add(
                                        VerifyOTP(
                                            otp: textEditingController.text));
                                  }
                                },
                                onChanged: (value) {
                                  logger.d(value);
                                },
                                beforeTextPaste: (text) {
                                  logger.d('Allowing to paste $text');
                                  return isNumeric(text);
                                },
                              ),
                            ),
                          ),
                          Hero(
                              tag: 'verify',
                              child: PrimaryButton(
                                  text: AppLocalizations.of(context)!.verify,
                                  pending: isLoading,
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    if (textEditingController.text.length !=
                                        6) {
                                      errorController
                                          .add(ErrorAnimationType.shake);
                                      return;
                                    }

                                    isLoading = true;

                                    BlocProvider.of<UserBloc>(_context).add(
                                        VerifyOTP(
                                            otp: textEditingController.text));
                                  })),
                          const SizedBox(
                            height: 8.0,
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
                                BlocProvider.of<UserBloc>(_context)
                                    .add(const ReSendOTP());
                                startTimer(60);
                              }
                              if (btnState == ButtonState.Busy) {
                                showFlushBar(
                                    AppLocalizations.of(context)!.waitForTimer,
                                    info: true,
                                    context: context);
                              }
                            },
                            initialTimer: 60,
                            loader: (timeLeft) {
                              return Text(
                                '${AppLocalizations.of(context)!.resendCode} $timeLeft',
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
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
