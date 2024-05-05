// import 'package:ebn_balady/core/app_theme.dart';
// import 'package:ebn_balady/features/auth/presentation/states%20manager/auth_bloc/auth_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../../../core/constants.dart';
// import '../../../../core/utils/validator.dart';
// import '../../../../core/widgets/primary_button.dart';
// import '../../../../core/widgets/primary_text_field.dart';
//
// class LoginForm extends StatefulWidget {
//   const LoginForm({
//     Key? key,
//     required this.isLogin,
//     required this.animationDuration,
//     required this.size,
//     required this.defaultLoginSize,
//   }) : super(key: key);
//
//   final bool isLogin;
//   final Duration animationDuration;
//   final Size size;
//   final double defaultLoginSize;
//
//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }
//
// class _LoginFormState extends State<LoginForm> {
//   static final TextEditingController _usernameController =
//       TextEditingController();
//   static final _formKey = GlobalKey<FormState>();
//   static final TextEditingController _passwordController =
//       TextEditingController();
//   bool obscureText = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       opacity: widget.isLogin ? 1.0 : 0.0,
//       duration: widget.animationDuration * 4,
//       child: Align(
//         alignment: Alignment.center,
//         child: SizedBox(
//           width: widget.size.width,
//           height: widget.defaultLoginSize,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   AppLocalizations.of(context)!.welcomeBack,
//                   style: AppTheme.textTheme.headlineMedium!
//                       .copyWith(color: Colors.white),
//                 ),
//                 const SizedBox(height: 32),
//                 SizedBox(
//                     height: 250,
//                     child: SvgPicture.asset('${imagesPath}boarding_1.svg')),
//                 const SizedBox(height: 32),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       AppTextFormField(
//                         cursorColor: Colors.white,
//                         controller: _usernameController,
//                         hintText: AppLocalizations.of(context)!
//                             .emailOrUsernameOrPhone,
//                         color: AppTheme.secondarySwatch.shade200,
//                         hintStyle: AppTheme.textTheme.labelLarge!
//                             .copyWith(color: Colors.white70),
//                         errorStyle: AppTheme.textTheme.labelLarge!
//                             .copyWith(color: Colors.redAccent),
//                         style: AppTheme.textTheme.labelLarge!
//                             .copyWith(color: Colors.white),
//                         validator: (val) =>
//                             validateEditTextField(val, usernameKey),
//                         icon: const Icon(
//                           Icons.person,
//                           color: Colors.white,
//                         ),
//                       ),
//                       AppTextFormField(
//                         cursorColor: Colors.white,
//                         controller: _passwordController,
//                         hintText: AppLocalizations.of(context)!.password,
//                         color: AppTheme.secondarySwatch.shade200,
//                         obscureText: obscureText,
//                         hintStyle: AppTheme.textTheme.labelLarge!
//                             .copyWith(color: Colors.white70),
//                         style: AppTheme.textTheme.labelLarge!
//                             .copyWith(color: Colors.white),
//                         icon: const Icon(
//                           Icons.lock,
//                           color: Colors.white,
//                         ),
//                         errorStyle: AppTheme.textTheme.labelLarge!
//                             .copyWith(color: Colors.redAccent),
//                         validator: (val) =>
//                             validateEditTextField(val, passwordKey),
//                         suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 obscureText = !obscureText;
//                               });
//                             },
//                             icon: obscureText
//                                 ? const Icon(
//                                     Icons.visibility_off,
//                                     color: Colors.white,
//                                   )
//                                 : const Icon(
//                                     Icons.visibility,
//                                     color: Colors.white,
//                                   )),
//                       ),
//                       PrimaryButton(
//                         edgeInsetsMargin: const EdgeInsets.all(32),
//                         onTap: () {
//                           validateLogin();
//                         },
//                         color: Colors.white,
//                         text: AppLocalizations.of(context)!.logIn,
//                         textColor: AppTheme.primaryColor,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   validateLogin() {
//     final isValid = _formKey.currentState!.validate();
//     if (isValid) {
//       _formKey.currentState!.save();
//       // AuthModel auth = AuthModel(
//       //     password: _passwordController.text,
//       //     username: _usernameController.text.trim());
//       BlocProvider.of<AuthBloc>(context).add(Login(
//           password: _passwordController.text,
//           id: _usernameController.text.trim()));
//     }
//   }
// }
