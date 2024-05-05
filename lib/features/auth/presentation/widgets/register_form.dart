// import 'package:ebn_balady/core/constants.dart';
// import 'package:ebn_balady/features/auth/data/models/auth_model.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_pw_validator/flutter_pw_validator.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import '../../../../core/app_theme.dart';
// import '../../../../core/utils/validator.dart';
// import '../../../../core/widgets/app_dropdown_menu.dart';
// import '../../../../core/widgets/primary_button.dart';
// import '../../../../core/widgets/primary_text_field.dart';
// import '../states manager/auth_bloc/auth_bloc.dart';
//
// class RegisterForm extends StatefulWidget {
//   const RegisterForm({
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
//   State<RegisterForm> createState() => _RegisterFormState();
// }
//
// class _RegisterFormState extends State<RegisterForm> {
//   bool obscureText = true;
//   bool obscureText2 = true;
//   bool passwordValid = false;
//
//   String? genderSelectedValue;
//   String? countrySelectedValue;
//   String? citySelectedValue;
//   String? districtSelectedValue;
//
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _firstNameController = TextEditingController();
//   static final TextEditingController _middleNameController =
//       TextEditingController();
//   static final TextEditingController _lastNameController =
//       TextEditingController();
//   static final TextEditingController _emailController = TextEditingController();
//   static final TextEditingController _phoneNumberController =
//       TextEditingController();
//   static final TextEditingController _neighborhoodController =
//       TextEditingController();
//   static final TextEditingController _passwordController =
//       TextEditingController();
//
//   final List<String> countryItems = ['Yemen', 'Saudi Arabia', 'Egypt'];
//   final List<String> cityItems = ["Sana'a", 'Alhodaida', 'Aden'];
//   final List<String> districtItems = [
//     "Alsabeen",
//     'Maeen',
//     'Alwehda',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final List<String> genderItems = [
//       AppLocalizations.of(context)!.male,
//       AppLocalizations.of(context)!.female
//     ];
//
//     return AnimatedOpacity(
//       opacity: widget.isLogin ? 0.0 : 1.0,
//       duration: widget.animationDuration * 5,
//       child: Visibility(
//         visible: !widget.isLogin,
//         child: Align(
//           alignment: Alignment.bottomCenter,
//           child: SizedBox(
//             width: widget.size.width,
//             height: widget.defaultLoginSize,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 8),
//                   Text(
//                     AppLocalizations.of(context)!.welcome,
//                     style: AppTheme.textTheme.headlineMedium,
//                   ),
//                   const SizedBox(height: 32),
//                   SizedBox(
//                       height: 250,
//                       child: SvgPicture.asset('${imagesPath}boarding_2.svg')),
//                   const SizedBox(height: 32),
//                   Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           AppTextFormField(
//                             hintStyle: AppTheme.textTheme.labelLarge!.copyWith(
//                                 color: AppTheme.primarySwatch.shade700),
//                             errorStyle: AppTheme.textTheme.labelLarge!
//                                 .copyWith(color: AppTheme.errorColor),
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             hintText: AppLocalizations.of(context)!.firstName,
//                             color: AppTheme.primarySwatch.shade200,
//                             validator: (val) =>
//                                 validateEditTextField(val, firstNameKey),
//                             icon: const Icon(Icons.person),
//                             suffixIcon: Icon(
//                               Icons.star_rate_rounded,
//                               color: AppTheme.red,
//                               size: 8,
//                             ),
//                             controller: _firstNameController,
//                             keyboardType: TextInputType.name,
//                           ),
//                           AppTextFormField(
//                             hintStyle: AppTheme.textTheme.labelLarge!.copyWith(
//                                 color: AppTheme.primarySwatch.shade700),
//                             errorStyle: AppTheme.textTheme.labelLarge!
//                                 .copyWith(color: AppTheme.errorColor),
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             hintText: AppLocalizations.of(context)!.middleName,
//                             color: AppTheme.primarySwatch.shade200,
//                             icon: const Icon(Icons.person),
//                             controller: _middleNameController,
//                             keyboardType: TextInputType.name,
//                           ),
//                           AppTextFormField(
//                             hintStyle: AppTheme.textTheme.labelLarge!.copyWith(
//                                 color: AppTheme.primarySwatch.shade700),
//                             errorStyle: AppTheme.textTheme.labelLarge!
//                                 .copyWith(color: AppTheme.errorColor),
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             hintText: AppLocalizations.of(context)!.lastName,
//                             color: AppTheme.primarySwatch.shade200,
//                             validator: (val) =>
//                                 validateEditTextField(val, lastNameKey),
//                             icon: const Icon(Icons.person),
//                             suffixIcon: Icon(
//                               Icons.star_rate_rounded,
//                               color: AppTheme.red,
//                               size: 8,
//                             ),
//                             controller: _lastNameController,
//                             keyboardType: TextInputType.name,
//                           ),
//                           AppDropDownMenu(
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             selectedValue: genderSelectedValue,
//                             color: AppTheme.primarySwatch.shade200,
//                             text: AppLocalizations.of(context)!.selectGender,
//                             items: genderItems
//                                 .map((item) => DropdownMenuItem<String>(
//                                       value: item,
//                                       child: Text(
//                                         item,
//                                         style: AppTheme.textTheme.labelLarge!
//                                             .copyWith(
//                                           color: AppTheme.primaryColor,
//                                         ),
//                                       ),
//                                     ))
//                                 .toList(),
//                             textValidator: AppLocalizations.of(context)!
//                                 .pleaseSelectGender,
//                             onSaved: (value) {
//                               genderSelectedValue = value.toString();
//                             },
//                             onChanged: (value) {},
//                           ),
//                           AppTextFormField(
//                             hintStyle: AppTheme.textTheme.labelLarge!.copyWith(
//                                 color: AppTheme.primarySwatch.shade700),
//                             errorStyle: AppTheme.textTheme.labelLarge!
//                                 .copyWith(color: AppTheme.errorColor),
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             hintText: AppLocalizations.of(context)!.phoneNumber,
//                             color: AppTheme.primarySwatch.shade200,
//                             validator: (val) =>
//                                 validateEditTextField(val, phoneNumberKey),
//                             icon: const Icon(Icons.phone),
//                             suffixIcon: Icon(
//                               Icons.star_rate_rounded,
//                               color: AppTheme.red,
//                               size: 8,
//                             ),
//                             controller: _phoneNumberController,
//                             keyboardType: TextInputType.phone,
//                           ),
//                           AppTextFormField(
//                             hintStyle: AppTheme.textTheme.labelLarge!.copyWith(
//                                 color: AppTheme.primarySwatch.shade700),
//                             errorStyle: AppTheme.textTheme.labelLarge!
//                                 .copyWith(color: AppTheme.errorColor),
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             hintText: AppLocalizations.of(context)!.email,
//                             color: AppTheme.primarySwatch.shade200,
//                             validator: (val) => validateEmail(val, emailKey),
//                             icon: const Icon(Icons.mail),
//                             suffixIcon: Icon(
//                               Icons.star_rate_rounded,
//                               color: AppTheme.red,
//                               size: 8,
//                             ),
//                             controller: _emailController,
//                             keyboardType: TextInputType.emailAddress,
//                           ),
//                           AppDropDownMenu(
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             selectedValue: countrySelectedValue,
//                             color: AppTheme.primarySwatch.shade200,
//                             text: AppLocalizations.of(context)!.selectCountry,
//                             items: countryItems
//                                 .map((item) => DropdownMenuItem<String>(
//                                       value: item,
//                                       child: Text(
//                                         item,
//                                         style: AppTheme.textTheme.labelLarge!
//                                             .copyWith(
//                                           color: AppTheme.primaryColor,
//                                         ),
//                                       ),
//                                     ))
//                                 .toList(),
//                             textValidator: AppLocalizations.of(context)!
//                                 .pleaseSelectCountry,
//                             onSaved: (value) {
//                               countrySelectedValue = value.toString();
//                             },
//                             onChanged: (value) {},
//                           ),
//                           AppDropDownMenu(
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             selectedValue: citySelectedValue,
//                             color: AppTheme.primarySwatch.shade200,
//                             text: AppLocalizations.of(context)!.selectCity,
//                             items: cityItems
//                                 .map((item) => DropdownMenuItem<String>(
//                                       value: item,
//                                       child: Text(
//                                         item,
//                                         style: AppTheme.textTheme.labelLarge!
//                                             .copyWith(
//                                           color: AppTheme.primaryColor,
//                                         ),
//                                       ),
//                                     ))
//                                 .toList(),
//                             textValidator:
//                                 AppLocalizations.of(context)!.pleaseSelectCity,
//                             onSaved: (value) {
//                               citySelectedValue = value.toString();
//                             },
//                             onChanged: (value) {},
//                           ),
//                           AppDropDownMenu(
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             selectedValue: districtSelectedValue,
//                             color: AppTheme.primarySwatch.shade200,
//                             text: AppLocalizations.of(context)!.selectDistrict,
//                             items: districtItems
//                                 .map((item) => DropdownMenuItem<String>(
//                                       value: item,
//                                       child: Text(
//                                         item,
//                                         style: AppTheme.textTheme.labelLarge!
//                                             .copyWith(
//                                           color: AppTheme.primaryColor,
//                                         ),
//                                       ),
//                                     ))
//                                 .toList(),
//                             textValidator: AppLocalizations.of(context)!
//                                 .pleaseSelectDistrict,
//                             onSaved: (value) {
//                               districtSelectedValue = value.toString();
//                             },
//                             onChanged: (value) {},
//                           ),
//                           AppTextFormField(
//                             hintStyle: AppTheme.textTheme.labelLarge!.copyWith(
//                                 color: AppTheme.primarySwatch.shade700),
//                             errorStyle: AppTheme.textTheme.labelLarge!
//                                 .copyWith(color: AppTheme.errorColor),
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             hintText:
//                                 AppLocalizations.of(context)!.neighborhood,
//                             color: AppTheme.primarySwatch.shade200,
//                             icon: const Icon(Icons.location_city),
//                             controller: _neighborhoodController,
//                             keyboardType: TextInputType.name,
//                           ),
//                           AppTextFormField(
//                             hintStyle: AppTheme.textTheme.labelLarge!.copyWith(
//                                 color: AppTheme.primarySwatch.shade700),
//                             errorStyle: AppTheme.textTheme.labelLarge!
//                                 .copyWith(color: AppTheme.errorColor),
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             controller: _passwordController,
//                             hintText: AppLocalizations.of(context)!.password,
//                             color: AppTheme.primarySwatch.shade200,
//                             validator: (val) =>
//                                 validateEditTextField(val, passwordKey),
//                             obscureText: obscureText,
//                             icon: const Icon(Icons.lock),
//                             suffixIcon: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   obscureText = !obscureText;
//                                 });
//                               },
//                               icon: obscureText
//                                   ? const Icon(Icons.visibility_off)
//                                   : const Icon(Icons.visibility),
//                             ),
//                           ),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 16.0),
//                             child: FlutterPwValidator(
//                                 controller: _passwordController,
//                                 minLength: 6,
//                                 uppercaseCharCount: 1,
//                                 numericCharCount: 1,
//                                 width: MediaQuery.of(context).size.width,
//                                 height: 120,
//                                 successColor: AppTheme.successColor,
//                                 failureColor: AppTheme.errorColor,
//                                 onSuccess: () {
//                                   passwordValid = true;
//                                 },
//                                 onFail: () {
//                                   passwordValid = false;
//                                 }),
//                           ),
//                           AppTextFormField(
//                             hintStyle: AppTheme.textTheme.labelLarge!.copyWith(
//                                 color: AppTheme.primarySwatch.shade700),
//                             errorStyle: AppTheme.textTheme.labelLarge!
//                                 .copyWith(color: AppTheme.errorColor),
//                             style: AppTheme.textTheme.labelLarge!.copyWith(
//                               color: AppTheme.primaryColor,
//                             ),
//                             hintText: AppLocalizations.of(context)!
//                                 .passwordConfirmation,
//                             color: AppTheme.primarySwatch.shade200,
//                             obscureText: obscureText2,
//                             validator: (val) => validateConfirmPassword(
//                                 val, _passwordController.text),
//                             icon: const Icon(Icons.lock),
//                             suffixIcon: IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   obscureText2 = !obscureText2;
//                                 });
//                               },
//                               icon: obscureText2
//                                   ? const Icon(Icons.visibility_off)
//                                   : Icon(Icons.visibility),
//                             ),
//                           ),
//                           PrimaryButton(
//                             onTap: () {
//                               validateSignup();
//                             },
//                             text: AppLocalizations.of(context)!.signUp,
//                           ),
//                         ],
//                       ))
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   validateSignup() {
//     final isValid = _formKey.currentState!.validate();
//
//     if (isValid && passwordValid) {
//       _formKey.currentState!.save();
//       print("firstname is : " + _firstNameController.text.trim());
//       print("middleName is : " + _middleNameController.text.trim());
//       print("lastName is : " + _lastNameController.text.trim());
//       print("phones is : " + _phoneNumberController.text.trim());
//       print("city is : " + citySelectedValue.toString());
//       print("country is : " + countrySelectedValue.toString());
//       print("district is : " + districtSelectedValue.toString());
//       print("email is : " + _emailController.text.trim());
//       print("neighborhood is : " + _neighborhoodController.text.trim());
//       print("gender is : " + genderSelectedValue.toString());
//       print("password is : " + _passwordController.text);
//
//       AuthModel auth = AuthModel(
//         firstName: _firstNameController.text.trim(),
//         middleName: _middleNameController.text.trim(),
//         lastName: _lastNameController.text.trim(),
//         phones: [_phoneNumberController.text.trim()],
//         city: citySelectedValue,
//         country: countrySelectedValue,
//         district: districtSelectedValue,
//         email: _emailController.text.trim(),
//         neighborhood: _neighborhoodController.text.trim(),
//         gender: genderSelectedValue,
//         password: _passwordController.text,
//       );
//       print("password inside ui is ${_passwordController.text}");
//       print("neighborhood inside ui is ${_neighborhoodController.text}");
//       print("user inside ui is $auth");
//       BlocProvider.of<AuthBloc>(context).add(Signup(auth: auth));
//     } else {
//       Fluttertoast.showToast(
//           msg: wrongDataInput,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: AppTheme.errorColor,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//   }
//
//   validateEmail(String? val, String email) {
//     String? text = validateEditTextField(val, email);
//     if (text != null) {
//       return text;
//     } else if (!EmailValidator.validate(val!)) {
//       return wrongEmailFormat;
//     }
//   }
//
//   validateConfirmPassword(String? val, String text) {
//     if (val != _passwordController.text) {
//       return dontMatch;
//     }
//   }
// }
