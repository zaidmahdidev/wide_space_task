// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:get/get.dart';
//
// import '../app_theme.dart';
// import '../utils/screen_util.dart';
//
// class SubwalletChooserBottomSheet extends StatefulWidget {
//   final List<TargetWalletModel> wallets;
//
//   const SubwalletChooserBottomSheet({
//     Key? key,
//     required this.wallets,
//   }) : super(key: key);
//
//   @override
//   State<SubwalletChooserBottomSheet> createState() => _SubwalletChooserBottomSheetState();
//
//   static Future<TargetWalletModel?> show({
//     required List<TargetWalletModel> wallets,
//   }) async {
//     TargetWalletModel? selectedWallet = await Get.bottomSheet(
//         SubwalletChooserBottomSheet(
//           wallets: wallets,
//         ),
//         isScrollControlled: true,
//         isDismissible: false);
//     return selectedWallet;
//   }
// }
//
// class _SubwalletChooserBottomSheetState extends State<SubwalletChooserBottomSheet> {
//   TargetWalletModel? selectedWallet;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedWallet = widget.wallets.first;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: [
//         Stack(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24.0).copyWith(bottom: 0),
//               decoration: BoxDecoration(
//                 color: AppTheme.scaffoldBackgroundColor,
//                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 8, offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       AppLocalizations.of(context)!.chooseWalletForSend,
//                       style: AppTheme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Center(
//                     child: Text(
//                       AppLocalizations.of(context)!.userHasMoreThanWallet,
//                       style: AppTheme.textTheme.subtitle2!.copyWith(
//                         color: AppTheme.primarySwatch.shade400,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Container(
//                     constraints: BoxConstraints(
//                       maxHeight: ScreenUtil.screenHeight / 3,
//                     ),
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                           onTap: () {
//                             setState(() {
//                               selectedWallet = widget.wallets[index];
//                             });
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               boxShadow: [
//                                 BoxShadow(color: Colors.black.withOpacity(.03), blurRadius: 8, offset: const Offset(0, 4)),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 IgnorePointer(
//                                   child: Radio(
//                                       activeColor: AppTheme.primarySwatch,
//                                       value: widget.wallets[index],
//                                       groupValue: selectedWallet,
//                                       onChanged: (val) {}),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         widget.wallets[index].name.split(' ').take(3).join(' ').toCapitalized(),
//                                         style: AppTheme.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       itemCount: widget.wallets.length,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Get.back(result: selectedWallet);
//                           },
//                           child: Text(
//                             AppLocalizations.of(context)!.done,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 8,
//                   )
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 0,
//               right: 70,
//               child: IgnorePointer(
//                 child: Opacity(
//                   opacity: .025,
//                   child: Image.asset(
//                     'assets/images/logo.png',
//                     height: ScreenUtil.screenHeight / 1.5,
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topCenter,
//               child: Icon(
//                 Icons.drag_handle,
//                 color: AppTheme.primarySwatch.shade400,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
