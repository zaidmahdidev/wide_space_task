import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:ebn_balady/features/home/presentation/pages/main_screen.dart';
import 'package:ebn_balady/features/user/data/models/user_model.dart';
import 'package:ebn_balady/features/user/presentation/pages/login_screen.dart';
import 'package:ebn_balady/features/user/presentation/pages/verify_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_validation/flutter_validation.dart';
import 'package:get/get.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/constants.dart';
import '../../../../core/models/current_provider.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../../../../injection_container.dart';
import '../../utils/PWStrings.dart';
import '../manager/user_bloc.dart';
import '../widgets/details_dropdown_field.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? genderValue, countryValue, cityValue, districtValue;
  String phoneCode = '';

  bool autoValidate = false,
      requestPending = false,
      obscureText = true,
      confirmPasswordObscureText = true,
      isPasswordValid = false;
  IconData passwordIcon = Icons.visibility,
      confirmPasswordIcon = Icons.visibility;
  TextEditingController passwordController = TextEditingController(text: ''),
      passwordConfirmationController = TextEditingController(text: ''),
      firstNameController = TextEditingController(text: ''),
      middleNameController = TextEditingController(text: ''),
      lastNameController = TextEditingController(text: ''),
      neighborhoodController = TextEditingController(text: ''),
      emailController = TextEditingController(text: ''),
      phoneNumberController = TextEditingController(text: '');

  FocusNode passwordConfirmationFocusNode = FocusNode();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);
    return WillPopScope(
      onWillPop: () {
        if (requestPending) {
          showFlushBar(AppLocalizations.of(context)!.waitTillFinished,
              error: false, info: true, context: context);
        }
        return Future.value(!requestPending);
      },
      child: SafeArea(
          child: Scaffold(
              key: _scaffoldKey,
              body: BlocProvider.value(
                value: BlocProvider.of<UserBloc>(context),
                child: BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) async {
                    logger.d('state listener is $state');
                    if (state is RegisterError) {
                      await showFlushBar(state.message, context: context);
                      setState(() {
                        requestPending = false;
                      });
                    } else if (state is RegisterLoaded) {
                      BlocProvider.of<UserBloc>(context).add(LoginRequest(
                          id: emailController.text,
                          password: passwordController.text));
                      setState(() {
                        requestPending = false;
                      });
                    }

                    if (state is LoginError) {
                      await showFlushBar(state.message, context: context);
                      setState(() {
                        requestPending = false;
                      });
                    } else if (state is LoginLoaded) {
                      if (state.user.id != 0 && state.user.verified == false) {
                        await Get.offAll(() => (VerifyScreen(
                              currentUser: state.user,
                            )));
                      } else {
                        // BlocProvider.of<UserBloc>(context)
                        //     .add(const GetMyProfileData());
                        await Get.offAll(() => (const MainScreen()));
                        Current.isLoggedIn = true;
                      }
                      Current.user = state.user;
                      setState(() {
                        requestPending = false;
                      });
                    }
                  },
                  listenWhen: (oldState, newState) => true,
                  buildWhen: (oldState, newState) => true,
                  builder: (context, state) {
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
                                  height: ScreenUtil.screenHeight * .1,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Hero(
                                        tag: 'app_logo',
                                        child: Image.asset(
                                          Get.isDarkMode
                                              ? '${imagesPath}logo_dark.png'
                                              : '${imagesPath}logo.png',
                                          width: ScreenUtil.screenWidth * .3,
                                        ),
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
                                                    text: AppLocalizations.of(
                                                            context)!
                                                        .appName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
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
                                            AppLocalizations.of(context)!
                                                .appSlogan,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Form(
                                    autovalidateMode: autoValidate
                                        ? AutovalidateMode.always
                                        : AutovalidateMode.disabled,
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AppTextFormField(
                                          context: context,
                                          controller: firstNameController,
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          suffixIcon: Icon(
                                            Icons.star_rate_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            size: 8,
                                          ),
                                          enabled: !requestPending,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8.0),
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .firstName,
                                          enableSuggestions: true,
                                          textInputAction: TextInputAction.next,
                                          validator: MultiValidator([
                                            Validator.of(context)!.required(
                                              AppLocalizations.of(context)!
                                                  .firstName,
                                            ),
                                          ]),
                                        ),
                                        AppTextFormField(
                                            context: context,
                                            controller: middleNameController,
                                            enabled: !requestPending,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 18.0,
                                                vertical: 8.0),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .middleName,
                                            enableSuggestions: true,
                                            onChanged: (val) {
                                              setState(() {});
                                            },
                                            textInputAction:
                                                TextInputAction.next),
                                        AppTextFormField(
                                          context: context,
                                          controller: lastNameController,
                                          suffixIcon: Icon(
                                            Icons.star_rate_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            size: 8,
                                          ),
                                          enabled: !requestPending,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8.0),
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .lastName,
                                          enableSuggestions: true,
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          textInputAction: TextInputAction.next,
                                          validator: MultiValidator([
                                            Validator.of(context)!.required(
                                              AppLocalizations.of(context)!
                                                  .lastName,
                                            ),
                                          ]),
                                        ),
                                        AppTextFormField(
                                          context: context,
                                          controller: emailController,
                                          suffixIcon: Icon(
                                            Icons.star_rate_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            size: 8,
                                          ),
                                          enabled: !requestPending,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8.0),
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .email,
                                          enableSuggestions: true,
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          textInputAction: TextInputAction.next,
                                          validator: MultiValidator([
                                            Validator.of(context)!.required(
                                              AppLocalizations.of(context)!
                                                  .email,
                                            ),
                                            Validator.of(context)!.pattern(
                                                AttributeLocalizations.of(
                                                        context)!
                                                    .email,
                                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$"),
                                          ]),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                        AppDropDownField(
                                          context: context,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          items: getGenders(context),
                                          hint: AppLocalizations.of(context)!
                                              .selectGender,
                                          initialValue: genderValue,
                                          onChanged: (genderSelectedValue) {
                                            genderValue = genderSelectedValue;
                                            log("new genderValue is $genderValue");
                                            setState(() {
                                              genderValue = genderSelectedValue;
                                            });
                                          },
                                          validator: (value) => value == null
                                              ? AppLocalizations.of(context)!
                                                  .pleaseSelectGender
                                              : null,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 18,
                                            ),
                                            IconButton(
                                              padding: const EdgeInsets.only(
                                                  top: 16),
                                              icon: const Icon(Icons.flag),
                                              onPressed: () {
                                                showCountryPicker(
                                                  context: context,
                                                  exclude: <String>['IL'],
                                                  favorite: <String>['YE'],
                                                  showPhoneCode: true,
                                                  onSelect: (Country country) {
                                                    setState(() {
                                                      phoneCode =
                                                          country.phoneCode;
                                                    });
                                                  },
                                                  countryListTheme:
                                                      CountryListThemeData(
                                                    flagSize: 20,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                    textStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary),
                                                    bottomSheetHeight: 600,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(24.0),
                                                      topRight:
                                                          Radius.circular(24.0),
                                                    ),
                                                    inputDecoration:
                                                        InputDecoration(
                                                      hintText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .search,
                                                      hintStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onSurface),
                                                      prefixIcon: const Icon(
                                                          Icons.search),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    16)),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                    ),
                                                    searchTextStyle:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary),
                                                  ),
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18),
                                              child: Text(phoneCode,
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface)),
                                            ),
                                            Expanded(
                                              child: AppTextFormField(
                                                context: context,
                                                controller:
                                                    phoneNumberController,
                                                suffixIcon: Icon(
                                                  Icons.star_rate_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                  size: 8,
                                                ),
                                                enableSuggestions: true,
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .phoneNumber,
                                                margin: const EdgeInsets.only(
                                                    right: 18.0,
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    left: 4),
                                                validator: MultiValidator([
                                                  Validator.of(context)!
                                                      .pattern(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .phoneNumber,
                                                    r'\d+',
                                                  ),
                                                  Validator.of(context)!
                                                      .pattern(
                                                          AttributeLocalizations
                                                                  .of(context)!
                                                              .phone,
                                                          r'[7][7|1|3|0]'),

                                                  Validator.of(context)!
                                                      .required(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .phoneNumber),
                                                  Validator.of(context)!.length(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .phoneNumber,
                                                    9,
                                                  )
                                                  // ...
                                                ]),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'\d+')),
                                                  LengthLimitingTextInputFormatter(
                                                      9),
                                                ],
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                  decimal: false,
                                                  signed: false,
                                                ),
                                                onChanged: (val) {
                                                  setState(() {});
                                                },
                                                textInputAction:
                                                    TextInputAction.next,
                                              ),
                                            ),
                                          ],
                                        ),
                                        AppDropDownField(
                                          context: context,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          items: getCities(context),
                                          hint: AppLocalizations.of(context)!
                                              .selectCity,
                                          initialValue: cityValue,
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          validator: (value) => value == null
                                              ? AppLocalizations.of(context)!
                                                  .pleaseSelectCity
                                              : null,
                                        ),
                                        AppDropDownField(
                                          context: context,
                                          items: getDistricts(context),
                                          hint: AppLocalizations.of(context)!
                                              .selectDistrict,
                                          initialValue: districtValue,
                                          onChanged: (districtSelectedValue) {
                                            log("new districtValue is $districtValue");
                                            setState(() {
                                              log("districtValue is $districtValue");
                                              districtValue =
                                                  districtSelectedValue;
                                            });
                                            log("new districtValue is $districtValue");
                                          },
                                          validator: (value) => value == null
                                              ? AppLocalizations.of(context)!
                                                  .pleaseSelectDistrict
                                              : null,
                                        ),
                                        AppTextFormField(
                                          context: context,
                                          enabled: !requestPending,
                                          controller: neighborhoodController,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .neighborhood,
                                          enableSuggestions: true,
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          textInputAction: TextInputAction.next,
                                        ),
                                        AppTextFormField(
                                          context: context,
                                          controller: passwordController,
                                          enabled: !requestPending,
                                          obscureText: obscureText,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8.0),
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .password,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              passwordIcon,
                                              color: Colors.grey,
                                            ),
                                            splashRadius: 20,
                                            onPressed: () {
                                              setState(() {
                                                passwordIcon == Icons.visibility
                                                    ? passwordIcon =
                                                        Icons.visibility_off
                                                    : passwordIcon =
                                                        Icons.visibility;
                                                obscureText = !obscureText;
                                              });
                                            },
                                          ),
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          validator: MultiValidator([
                                            Validator.of(context)!.required(
                                              AppLocalizations.of(context)!
                                                  .password,
                                            ),
                                            Validator.of(context)!.minLength(
                                              AppLocalizations.of(context)!
                                                  .password,
                                              6,
                                            )
                                          ]),
                                          onFieldSubmitted: (value) {
                                            FocusScope.of(context).requestFocus(
                                                passwordConfirmationFocusNode);
                                          },
                                          textInputAction: TextInputAction.next,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: FlutterPwValidator(
                                              strings: ArabicStrings(),
                                              controller: passwordController,
                                              minLength: 6,
                                              uppercaseCharCount: 1,
                                              numericCharCount: 1,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 120,
                                              successColor: Get.isDarkMode
                                                  ? AppTheme.darkSuccessColor
                                                  : AppTheme.successColor,
                                              failureColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              onSuccess: () {
                                                isPasswordValid = true;
                                              },
                                              onFail: () {
                                                isPasswordValid = false;
                                              }),
                                        ),
                                        AppTextFormField(
                                          context: context,
                                          enabled: !requestPending,
                                          controller:
                                              passwordConfirmationController,
                                          focusNode:
                                              passwordConfirmationFocusNode,
                                          obscureText:
                                              confirmPasswordObscureText,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 8.0),
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .confirmPassword,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              confirmPasswordIcon,
                                              color: Colors.grey,
                                            ),
                                            splashRadius: 20,
                                            onPressed: () {
                                              setState(() {
                                                confirmPasswordIcon ==
                                                        Icons.visibility
                                                    ? confirmPasswordIcon =
                                                        Icons.visibility_off
                                                    : confirmPasswordIcon =
                                                        Icons.visibility;
                                                confirmPasswordObscureText =
                                                    !confirmPasswordObscureText;
                                              });
                                            },
                                          ),
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                          validator: MultiValidator([
                                            Validator.of(context)!.required(
                                              AppLocalizations.of(context)!
                                                  .passwordConfirmation,
                                            ),
                                            Validator.of(context)!.match(
                                              AttributeLocalizations.of(
                                                      context)!
                                                  .passwordConfirmation,
                                              AppLocalizations.of(context)!
                                                  .passwordConfirmation,
                                              () => passwordController.text,
                                            ),
                                          ]),
                                          textInputAction: TextInputAction.done,
                                          onFieldSubmitted: (value) {
                                            _submitSignUpForm(context);
                                          },
                                        ),
                                      ],
                                    )),
                                Hero(
                                    tag: 'signUp',
                                    child: PrimaryButton(
                                        text: AppLocalizations.of(context)!
                                            .signUp,
                                        pending: requestPending,
                                        onTap: () {
                                          _submitSignUpForm(context);
                                        })),
                                PrimaryTextButton(
                                    text: AppLocalizations.of(context)!
                                        .registerYourAccount,
                                    onTap: () {
                                      Get.off(() => const LoginScreen());
                                    }),
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
              ))),
    );
  }

  void _submitSignUpForm(BuildContext context) async {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate() && isPasswordValid) {
      FocusScope.of(context).unfocus();
      if (await isDeviceEligibleToUseTheApp(context: context)) {
        UserModel user = UserModel(
          firstName: firstNameController.text,
          middleName: middleNameController.text,
          lastName: lastNameController.text,
          phones: [phoneNumberController.text],
          city: cityValue,
          country: countryValue,
          district: districtValue,
          email: emailController.text,
          neighborhood: neighborhoodController.text,
          gender: genderValue,
        );
        BlocProvider.of<UserBloc>(context).add(RegisterRequest(
          user: user,
          password: passwordController.text,
        ));
        setState(() {
          requestPending = true;
        });
      }
    } else {
      autoValidate = true;
    }
  }
}
