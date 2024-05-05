// import 'package:ebn_balady/core/app_theme.dart';
// import 'package:ebn_balady/features/auth/presentation/states%20manager/auth_bloc/auth_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// import '../../../../core/constants.dart';
// import '../../../../core/widgets/loading.dart';
// import '../../../home/presentation/pages/main_screen.dart';
// import '../../../profile/presentation/states manager/profile_bloc.dart';
// import '../widgets/cancel_button.dart';
// import '../widgets/login_form.dart';
// import '../widgets/register_form.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   bool isLogin = true;
//   late Animation<double> containerSize;
//   AnimationController? animationController;
//   Duration animationDuration = const Duration(milliseconds: 300);
//
//   @override
//   void initState() {
//     super.initState();
//     animationController =
//         AnimationController(vsync: this, duration: animationDuration);
//   }
//
//   @override
//   void dispose() {
//     animationController!.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//     double viewInset = MediaQuery.of(context)
//         .viewInsets
//         .bottom; // we are using this to determine Keyboard is opened or not
//     double defaultLoginSize = size.height - (size.height * 0.2);
//     double defaultRegisterSize = size.height - (size.height * 0.1);
//
//     containerSize =
//         Tween<double>(begin: size.height * 0.08, end: defaultRegisterSize)
//             .animate(CurvedAnimation(
//                 parent: animationController!, curve: Curves.linear));
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: MultiBlocProvider(
//         providers: [
//           BlocProvider.value(
//             value: BlocProvider.of<AuthBloc>(context),
//           ),
//           BlocProvider.value(
//             value: BlocProvider.of<ProfileBloc>(context),
//           ),
//         ],
//         child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
//           if (state is AuthError) {
//             Fluttertoast.showToast(
//               msg: state.message == serverFailureMessage && isLogin
//                   ? wrongUsernameOrPassword
//                   : state.message,
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               backgroundColor: AppTheme.errorColor,
//               textColor: Colors.white,
//               fontSize: 16.0,
//             );
//           } else if (state is AuthLoaded) {
//             BlocProvider.of<ProfileBloc>(context).add(const GetMyProfileData());
//             Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => const MainScreen()),
//                 (Route<dynamic> route) => false);
//           } else if (state is AuthRegistered) {
//             Fluttertoast.showToast(
//                 msg: "You have been registered successfully",
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.BOTTOM,
//                 timeInSecForIosWeb: 1,
//                 backgroundColor: AppTheme.successColor,
//                 textColor: Colors.white,
//                 fontSize: 16.0);
//
//             setState(() {
//               animationController!.reverse();
//               setState(() {
//                 isLogin = !isLogin;
//               });
//             });
//           }
//         }, builder: (context, state) {
//           return Stack(
//             children: [
//               CancelButton(
//                 isLogin: isLogin,
//                 animationDuration: animationDuration,
//                 size: size,
//                 animationController: animationController,
//                 tapEvent: isLogin
//                     ? null
//                     : () {
//                         animationController!.reverse();
//                         setState(() {
//                           isLogin = !isLogin;
//                         });
//                       },
//               ),
//               if (state is AuthLoading) const LoadingWidget(),
//               LoginForm(
//                   isLogin: isLogin,
//                   animationDuration: animationDuration,
//                   size: size,
//                   defaultLoginSize: defaultLoginSize),
//               AnimatedBuilder(
//                 animation: animationController!,
//                 builder: (context, child) {
//                   if (viewInset == 0 && isLogin || !isLogin) {
//                     return buildRegisterContainer(size);
//                   }
//                   return Container();
//                 },
//               ),
//               if (state is AuthLoading) const LoadingWidget(),
//               RegisterForm(
//                   isLogin: isLogin,
//                   animationDuration: animationDuration,
//                   size: size,
//                   defaultLoginSize: defaultRegisterSize),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget buildRegisterContainer(size) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         width: double.infinity,
//         height: containerSize.value,
//         decoration: BoxDecoration(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//           color: Theme.of(context).scaffoldBackgroundColor,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.25),
//               blurRadius: 16,
//               offset: const Offset(0, 8), // changes position of shadow
//             ),
//           ],
//         ),
//         alignment: Alignment.center,
//         child: GestureDetector(
//           onTap: !isLogin
//               ? null
//               : () {
//                   animationController!.forward();
//
//                   setState(() {
//                     isLogin = !isLogin;
//                   });
//                 },
//           child: isLogin
//               ? Text(
//                   AppLocalizations.of(context)!.dontHaveAccount,
//                   style: AppTheme.textTheme.bodyMedium!
//                       .copyWith(color: AppTheme.primaryColor),
//                 )
//               : null,
//         ),
//       ),
//     );
//   }
// }
