import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../utils/screen_util.dart';

class LostScreen extends StatelessWidget {
  const LostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("404"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 8,
                offset: const Offset(0, 4)),
          ],
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/error.json',
                height: ScreenUtil.screenHeight * .24),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.lost,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(height: 1.2),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
