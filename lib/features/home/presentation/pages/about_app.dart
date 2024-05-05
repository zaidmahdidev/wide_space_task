import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../../../core/constants.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => openMenu(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(Get.context!)!.aboutEbnBalady),
        centerTitle: false,
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: -200,
              right: -120,
              child: Transform.rotate(
                angle: math.pi / 180 * 90,
                child: SvgPicture.asset(
                  "${iconsPath}main_shape.svg",
                  width: 250,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
              ),
            ),
            Column(
              children: [
                SvgPicture.asset(
                  "${iconsPath}logo_white.svg",
                  width: 250,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.aboutEbnBaladyText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  openMenu() {
    ZoomDrawer.of(context)!.toggle();
  }
}
