import 'dart:math' as math;

import 'package:concentric_transition/concentric_transition.dart';
import 'package:ebn_balady/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../user/presentation/pages/login_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    final pages = [
      PageData(
        image: SvgPicture.asset("${imagesPath}boarding_1.svg", height: 250),
        bgColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.onBoardingTitle1,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        shape: Positioned(
          bottom: -150,
          left: -50,
          child: Transform.rotate(
              angle: 160 * math.pi / 180,
              child: SvgPicture.asset(
                "${iconsPath}main_shape.svg",
                height: 300,
                width: 300,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              )),
        ),
        shape2: Positioned(
          bottom: -485,
          right: -110,
          child: Transform.rotate(
            angle: 95 * math.pi / 180,
            child: SvgPicture.asset(
              "${iconsPath}main_shape.svg",
              width: 400,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: Text(
          AppLocalizations.of(context)!.onBoardingBody1,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      PageData(
        image: SvgPicture.asset(
          "${imagesPath}boarding_2.svg",
          height: 250,
        ),
        shape: Positioned(
          bottom: -180,
          left: -120,
          child: Transform.rotate(
              angle: 160 * math.pi / 180,
              child: SvgPicture.asset(
                "${iconsPath}main_shape.svg",
                height: 400,
                width: 400,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              )),
        ),
        shape2: Positioned(
          bottom: -475,
          left: -180,
          child: Transform.rotate(
            angle: 120 * math.pi / 180,
            child: SvgPicture.asset(
              "${iconsPath}main_shape.svg",
              width: 400,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        bgColor: Theme.of(context).colorScheme.primary,
        title: Text(
          AppLocalizations.of(context)!.onBoardingTitle2,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        body: Text(
          AppLocalizations.of(context)!.onBoardingBody2,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      PageData(
        image: SvgPicture.asset(
          "${imagesPath}boarding_3.svg",
          height: 250,
        ),
        shape: Positioned(
          bottom: -200,
          right: -180,
          child: Transform.rotate(
              angle: 0 * math.pi / 180,
              child: SvgPicture.asset(
                "${iconsPath}main_shape.svg",
                width: 250,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
              )),
        ),
        shape2: Positioned(
          bottom: -280,
          right: -100,
          child: Transform.rotate(
            angle: 100 * math.pi / 180,
            child: SvgPicture.asset(
              "${iconsPath}main_shape.svg",
              width: 300,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        bgColor: Theme.of(context).scaffoldBackgroundColor,
        body: Text(
          AppLocalizations.of(context)!.onBoardingBody3,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.055,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 2), // visual center
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.07,
          ),
        ),
        itemCount: pages.length,
        opacityFactor: 12,
        verticalPosition: 0.9,
        direction: Axis.horizontal,
        onFinish: () {
          Get.to(() => const LoginScreen(),
              transition: Transition.cupertino,
              duration: const Duration(seconds: 1));
          // di.sl<SharedPreferences>().setBool(showOnboardingKey, false);
        },
        itemBuilder: (index) {
          final page = pages[index];
          return SafeArea(
            child: Stack(
              children: [
                _Page(page: page),
                Positioned(
                  bottom: screenHeight * 0.1,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle_rounded,
                          color: index == 0
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          size: 8,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.circle_rounded,
                          color: index == 1
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(context).colorScheme.secondary,
                          size: 8,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.circle_rounded,
                          color: index == 2
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          size: 8,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class PageData {
  final Widget? title, body, image, shape, shape2;
  final Color bgColor;

  const PageData({
    this.shape,
    this.shape2,
    this.title,
    this.image,
    this.body,
    required this.bgColor,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Stack(children: [
        if (page.shape != null) page.shape!,
        if (page.shape2 != null) page.shape2!,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Column(
            children: [
              if (page.image != null) Center(child: page.image!),
              if (page.image != null)
                SizedBox(
                  height: screenWidth * 0.1,
                ),
              if (page.title != null) Center(child: page.title!),
              if (page.title != null)
                SizedBox(
                  height: screenWidth * 0.1,
                ),
              if (page.body != null) Center(child: page.body!),
            ],
          ),
        ),
      ]),
    );
  }
}
