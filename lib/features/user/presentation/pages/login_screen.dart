import 'package:avatar_glow/avatar_glow.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:ebn_balady/features/user/presentation/pages/signup_screen.dart';
import 'package:ebn_balady/features/user/presentation/pages/verify_user_screen.dart';
import 'package:ebn_balady/injection_container.dart' as di;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_validation/flutter_validation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:local_auth/local_auth.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/data_providers/local_data_provider.dart';
import '../../../../core/models/current_provider.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/widgets/cached_network_image.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../../../home/presentation/pages/main_screen.dart';
import '../../data/repositories/oauth_repository.dart';
import '../manager/user_bloc.dart';
import '../widgets/forget_password_bottom_sheet.dart';

class LoginScreen extends StatefulWidget {
  final String? username, password;

  const LoginScreen({Key? key, this.username, this.password}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  BuildContext? _blocContext;
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  bool autoValidate = false;
  bool requestPending = false;
  bool obscureText = true;
  IconData passwordIcon = Icons.visibility;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get localAuthEnabled =>
      di
          .sl<LocalDataProvider>()
          .getSingleValueCachedData(boxName: 'USE_LOCAL_AUTH') ??
      true;
  final _localAuth = LocalAuthentication();
  BiometricType? _biometricType;
  bool _canUseBiometric = false;

  @override
  void initState() {
    getCachedUser().then((user) {
      if (user.id != 0) {
        // not found
        setState(() {
          Current.user = user;
          usernameController.text = user.email!;
        });
      }
    });

    if (widget.username != null) {
      usernameController.text = widget.username ?? '';
      passwordController.text = widget.password ?? '';
    }
    Future.microtask(_authenticateWithBiometrics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: BlocProvider.value(
          value: BlocProvider.of<UserBloc>(context),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (kDebugMode) {
                print("state in login is $state");
              }
              if (state is LoginError) {
                showFlushBar(state.message, context: context);
                setState(() {
                  requestPending = false;
                });
              } else if (state is LoginLoaded) {
                if (state.user.verified == false) {
                  Get.offAll(() => (VerifyScreen(
                        currentUser: state.user,
                      )));
                } else {
                  Get.offAll(() => (const MainScreen()));
                  Current.isLoggedIn = true;
                }
                setState(() {
                  requestPending = false;
                  Current.user = state.user;
                });
              }
            },
            listenWhen: (oldState, newState) => true,
            buildWhen: (oldState, newState) => true,
            builder: (context, state) {
              _blocContext ??= context;
              di.logger.d('state builder is $state');
              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: ScreenUtil.screenHeightNoPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (Current.user.exist) ...[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          width: 1.5),
                                    ),
                                    width: ScreenUtil.screenWidth / 3,
                                    height: ScreenUtil.screenWidth / 3,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: cachedNetworkImage(
                                        Current.user.avatar ?? "",
                                        provider: true,
                                        rounded: true,
                                        errorWidget: Icon(
                                          Icons.account_circle,
                                          size: ScreenUtil.screenWidth / 4.5,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: AppLocalizations.of(context)!
                                                .welcomeBack,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary)),
                                        const TextSpan(text: ' '),
                                        TextSpan(
                                            text: Current.user.firstName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary)),
                                      ],
                                    ),
                                  ),
                                ],
                                if (Current.user.notExist) ...[
                                  Hero(
                                    tag: 'app_logo',
                                    child: Image.asset(
                                      Get.isDarkMode
                                          ? '${imagesPath}logo_dark.png'
                                          : '${imagesPath}logo.png',
                                      width: ScreenUtil.screenWidth * .3,
                                    ),
                                  ),
                                ],
                                const SizedBox(
                                  height: 32,
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
                                                  .displayMedium
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Form(
                              autovalidateMode: autoValidate
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AppTextFormField(
                                    context: context,
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                    controller: usernameController,
                                    hintText: AppLocalizations.of(context)!
                                        .emailOrUsernameOrPhone,
                                    validator: MultiValidator([
                                      Validator.of(context)!.required(
                                          AppLocalizations.of(context)!
                                              .emailOrUsernameOrPhone),
                                    ]),
                                    textInputAction: TextInputAction.next,
                                  ),
                                  AppTextFormField(
                                    onChanged: (val) {
                                      setState(() {});
                                    },
                                    context: context,
                                    enabled: !requestPending,
                                    controller: passwordController,
                                    obscureText: obscureText,
                                    hintText:
                                        AppLocalizations.of(context)!.password,
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
                                              : passwordIcon = Icons.visibility;
                                          obscureText = !obscureText;
                                        });
                                      },
                                    ),
                                    validator: MultiValidator([
                                      Validator.of(context)!.required(
                                        AppLocalizations.of(context)!.password,
                                      ),
                                    ]),
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (value) {
                                      _submitLoginForm();
                                    },
                                  ),
                                ],
                              )),
                          Row(
                            children: [
                              _buildFingerprint(),
                              Expanded(
                                child: Hero(
                                    tag: 'login',
                                    child: PrimaryButton(
                                        text:
                                            AppLocalizations.of(context)!.login,
                                        pending: requestPending,
                                        onTap: () {
                                          _submitLoginForm();
                                        })),
                              ),
                              if (_canUseBiometric)
                                if (requestPending)
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.person_remove_alt_1_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error
                                            .withOpacity(0.5),
                                      ),
                                      onPressed: () async {
                                        await logout(
                                            redirect: false, clearCache: true);
                                        setState(() {
                                          usernameController.text = "";
                                          passwordController.text = "";
                                          _canUseBiometric = false;
                                        });
                                      },
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AvatarGlow(
                                      endRadius: 24.0,
                                      glowColor:
                                          Theme.of(context).colorScheme.error,
                                      repeat: true,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.person_remove_alt_1_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        onPressed: () async {
                                          Dialogs.bottomMaterialDialog(
                                              msg: AppLocalizations.of(context)!
                                                  .nextTimeSecurity,
                                              msgStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface),
                                              title: AppLocalizations.of(
                                                      Get.context!)!
                                                  .removeAuth,
                                              titleStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              context: context,
                                              customView: Icon(
                                                Icons.drag_handle,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.4),
                                              ),
                                              onClose: (value) => print(
                                                  "returned value is '$value'"),
                                              actions: [
                                                IconsOutlineButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  text: AppLocalizations.of(
                                                          Get.context!)!
                                                      .cancel,
                                                  iconData:
                                                      Icons.cancel_outlined,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface),
                                                  iconColor: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                                IconsButton(
                                                  onPressed: () async {
                                                    await logout(
                                                        redirect: false,
                                                        clearCache: true);
                                                    setState(() {
                                                      usernameController.text =
                                                          "";
                                                      passwordController.text =
                                                          "";
                                                      _canUseBiometric = false;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  text: AppLocalizations.of(
                                                          Get.context!)!
                                                      .delete,
                                                  iconData:
                                                      Icons.delete_forever,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Colors.white),
                                                  iconColor: Colors.white,
                                                ),
                                              ]);
                                        },
                                      ),
                                    ),
                                  )
                            ],
                          ),
                          PrimaryTextButton(
                              text: AppLocalizations.of(context)!
                                  .dontHaveAccountQuestion,
                              onTap: () {
                                Get.off(() => const SignUpScreen());
                              }),
                          PrimaryTextButton(
                            text: AppLocalizations.of(context)!
                                .didYouForgetPassword,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.75)),
                            onTap: () async {
                              String? resetPhone =
                                  await ForgetPasswordBottomSheet.show(
                                phoneNumber:
                                    usernameController.text.isPhoneNumber
                                        ? usernameController.text.trim()
                                        : "",
                              );
                              if (resetPhone != null) {
                                usernameController.text = resetPhone;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16.0,
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

  void _submitLoginForm() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      if (await isDeviceEligibleToUseTheApp(context: context)) {
        setState(() {
          requestPending = true;
        });

        BlocProvider.of<UserBloc>(_blocContext!).add(
          LoginRequest(
            id: usernameController.text,
            password: passwordController.text,
          ),
        );
      }
    } else {
      autoValidate = true;
    }
  }

  void _authenticateWithBiometrics() async {
    _canUseBiometric = localAuthEnabled &&
        await _localAuth.isDeviceSupported() &&
        Current.user.exist &&
        OAuthRepository.isExists;

    if (_canUseBiometric) {
      await _localAuth.getAvailableBiometrics().then((value) async {
        setState(() {
          _biometricType = value.first;
        });
      }).whenComplete(() async {
        final didAuthenticate = await _localAuth.authenticate(
          localizedReason: AppLocalizations.of(context)!.pleaseAuth,
          // stickyAuth: true,
        );
        if (didAuthenticate &&
            await isDeviceEligibleToUseTheApp(context: context)) {
          setState(() {
            requestPending = true;
          });
          FocusScope.of(context).unfocus();

          BlocProvider.of<UserBloc>(_blocContext!).add(
            LoginRequest(
              id: usernameController.text,
              password: '',
            ),
          );
        }
      }).onError((error, stackTrace) {
        _localAuth.stopAuthentication();
      });
    }
  }

  Widget _buildFingerprint() {
    if (_canUseBiometric) {
      Widget icon;

      switch (_biometricType) {
        case BiometricType.fingerprint:
          icon = const Icon(
            Icons.fingerprint_outlined,
            size: 28,
          );
          break;

        case BiometricType.face:
          icon = SvgPicture.asset(
            '${iconsPath}face_id.svg',
            width: 20,
            height: 20,
            color: Theme.of(context).colorScheme.primary,
          );
          break;

        default:
          icon = const Icon(Icons.lock_outline);
      }

      if (requestPending) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: IconButton(icon: icon, onPressed: null),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AvatarGlow(
            endRadius: 24.0,
            glowColor: Theme.of(context).colorScheme.primary,
            repeat: true,
            child: IconButton(
              icon: icon,
              onPressed: _authenticateWithBiometrics,
            ),
          ),
        );
      }
    }

    return const SizedBox();
  }

  bool isRTL(String text) {
    if (text.isEmpty) return Directionality.of(context) == TextDirection.rtl;
    return intl.Bidi.detectRtlDirectionality(text);
  }
}
