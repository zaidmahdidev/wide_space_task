// import 'package:flutter/material.dart';
//
// import '../../../../core/app_theme.dart';
//
// class RoundedButton extends StatelessWidget {
//   const RoundedButton({
//     Key? key,
//     required this.title,
//   }) : super(key: key);
//
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//     return InkWell(
//       onTap: () {},
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         width: size.width * 0.9,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: AppTheme.primaryColor,
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         alignment: Alignment.center,
//         child: Text(
//           title,
//           style: AppTheme.textTheme.bodyLarge!.copyWith(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
