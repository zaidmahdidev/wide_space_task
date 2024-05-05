import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_validation/flutter_validation.dart';

import '../../../../core/mixins/loading_mixin.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../../../../injection_container.dart';
import '../manager/user_bloc.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({Key? key}) : super(key: key);

  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage>
    with LoadingStateMixin {
  late String _oldEmail;
  late String _newEmail;
  bool obscureText = true;
  bool newEmailObscureText = true;
  bool newEmailConfirmationObscureText = true;
  IconData EmailIcon = Icons.visibility;
  IconData newEmailIcon = Icons.visibility;
  IconData newEmailConfirmationIcon = Icons.visibility;

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
              await showFlushBar(
                state.message,
                context: context,
              );
              isLoading = false;
            }
            if (state is EmailChanged) {
              isLoading = false;
              await showSuccessFlushBar(
                message: AppLocalizations.of(context)!.emailChanged,
                context: context,
              ).then((value) async {
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
                  AppLocalizations.of(context)!.changeEmail,
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
                          hintText: AppLocalizations.of(context)!.oldEmail,
                          suffixIcon: IconButton(
                            icon: Icon(
                              EmailIcon,
                              color: Colors.grey,
                            ),
                            splashRadius: 20,
                            onPressed: () {
                              setState(() {
                                EmailIcon == Icons.visibility
                                    ? EmailIcon = Icons.visibility_off
                                    : EmailIcon = Icons.visibility;
                                obscureText = !obscureText;
                              });
                            },
                          ),
                          onChanged: (oldEmailValue) {
                            _oldEmail = oldEmailValue;
                          },
                          validator: MultiValidator([
                            Validator.of(context)!.required(
                              AppLocalizations.of(context)!.oldEmail,
                            ),
                          ]),
                          textInputAction: TextInputAction.next,
                        ),
                        AppTextFormField(
                          context: context,
                          enabled: !isLoading,
                          obscureText: newEmailObscureText,
                          hintText: AppLocalizations.of(context)!.newEmail,
                          suffixIcon: IconButton(
                            icon: Icon(
                              newEmailIcon,
                              color: Colors.grey,
                            ),
                            splashRadius: 20,
                            onPressed: () {
                              setState(() {
                                newEmailIcon == Icons.visibility
                                    ? newEmailIcon = Icons.visibility_off
                                    : newEmailIcon = Icons.visibility;
                                newEmailObscureText = !newEmailObscureText;
                              });
                            },
                          ),
                          onChanged: (newEmail) {
                            _newEmail = newEmail;
                          },
                          validator: MultiValidator([
                            Validator.of(context)!.required(
                              AppLocalizations.of(context)!.newEmail,
                            ),
                          ]),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {},
                        ),
                        AppTextFormField(
                          context: context,
                          enabled: !isLoading,
                          obscureText: newEmailConfirmationObscureText,
                          hintText: AppLocalizations.of(context)!
                              .newEmailConfirmation,
                          suffixIcon: IconButton(
                            icon: Icon(
                              newEmailConfirmationIcon,
                              color: Colors.grey,
                            ),
                            splashRadius: 20,
                            onPressed: () {
                              setState(() {
                                newEmailConfirmationIcon == Icons.visibility
                                    ? newEmailConfirmationIcon =
                                        Icons.visibility_off
                                    : newEmailConfirmationIcon =
                                        Icons.visibility;
                                newEmailConfirmationObscureText =
                                    !newEmailConfirmationObscureText;
                              });
                            },
                          ),
                          validator: MultiValidator([
                            Validator.of(context)!.required(
                              AppLocalizations.of(context)!
                                  .newEmailConfirmation,
                            ),
                            Validator.of(context)!.match(
                              AppLocalizations.of(context)!
                                  .newEmailConfirmation,
                              AppLocalizations.of(context)!.newEmail,
                              () => _newEmail,
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
                          .add(ChangeEmailRequest(
                        oldEmail: _oldEmail,
                        newEmail: _newEmail,
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
