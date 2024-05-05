import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_validation/flutter_validation.dart';

import '../../../../../core/mixins/loading_mixin.dart';
import '../../../../../core/utils/common_utils.dart';
import '../../../../../core/utils/screen_util.dart';
import '../../../../../core/widgets/primary_text_field.dart';
import '../../../../../injection_container.dart';
import '../manager/user_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage>
    with LoadingStateMixin {
  late String _oldPassword;
  late String _newPassword;
  bool obscureText = true;
  bool newPasswordObscureText = true;
  bool newPasswordConfirmationObscureText = true;
  IconData passwordIcon = Icons.visibility;
  IconData newPasswordIcon = Icons.visibility;
  IconData newPasswordConfirmationIcon = Icons.visibility;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);
    return SafeArea(
      child: BlocProvider(
        create: (context) => sl<UserBloc>(),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) async {
            logger.d('state listener is $state');
            if (state is UserError) {
              await showFlushBar(state.message, context: context);
              isLoading = false;
            }
            if (state is PasswordChanged) {
              isLoading = false;
              await showSuccessFlushBar(
                      context: context,
                      message: AppLocalizations.of(context)!.passwordChanged)
                  .then((value) async {
                await logout(redirect: true, clearCache: true);
              });
            }
          },
          listenWhen: (oldState, newState) => true,
          buildWhen: (oldState, newState) => true,
          builder: (_context, state) {
            logger.d('state builder is $state');

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context)!.changePassword,
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 16.0),
                  child: Form(
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
                          obscureText: obscureText,
                          hintText: AppLocalizations.of(context)!.oldPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordIcon,
                              color: Colors.grey,
                            ),
                            splashRadius: 20,
                            onPressed: () {
                              setState(() {
                                passwordIcon == Icons.visibility
                                    ? passwordIcon = Icons.visibility_off
                                    : passwordIcon = Icons.visibility;
                                obscureText = !obscureText;
                              });
                            },
                          ),
                          onChanged: (oldPasswordValue) {
                            _oldPassword = oldPasswordValue;
                          },
                          validator: MultiValidator([
                            Validator.of(context)!.required(
                              AppLocalizations.of(context)!.oldPassword,
                            ),
                          ]),
                          textInputAction: TextInputAction.next,
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
                                newPasswordObscureText =
                                    !newPasswordObscureText;
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
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {},
                        ),
                        AppTextFormField(
                          context: context,
                          enabled: !isLoading,
                          obscureText: newPasswordConfirmationObscureText,
                          hintText: AppLocalizations.of(context)!
                              .newPasswordConfirmation,
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
                                    : newPasswordConfirmationIcon =
                                        Icons.visibility;
                                newPasswordConfirmationObscureText =
                                    !newPasswordConfirmationObscureText;
                              });
                            },
                          ),
                          validator: MultiValidator([
                            Validator.of(context)!.required(
                              AppLocalizations.of(context)!
                                  .newPasswordConfirmation,
                            ),
                            Validator.of(context)!.match(
                              AppLocalizations.of(context)!
                                  .newPasswordConfirmation,
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
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      BlocProvider.of<UserBloc>(_context)
                          .add(ChangePasswordRequest(
                        oldPassword: _oldPassword,
                        newPassword: _newPassword,
                      ));
                      isLoading = true;
                    }
                  },
                  child: isLoading
                      ? const Center(
                          child: SpinKitThreeBounce(
                            color: Colors.white,
                            size: 14,
                          ),
                        )
                      : const Icon(
                          Icons.done,
                          color: Colors.white,
                        )),
            );
          },
        ),
      ),
    );
  }
}
