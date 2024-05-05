import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../../../core/constants.dart';
import '../utils/products.dart';

class AboutDeveloper extends StatefulWidget {
  const AboutDeveloper({Key? key}) : super(key: key);

  @override
  State<AboutDeveloper> createState() => _AboutDeveloperState();
}

class _AboutDeveloperState extends State<AboutDeveloper> {
  final products = [
    Product(name: 'WidePay', iconPath: "${iconsPath}widespace_logo.svg"),
    Product(name: 'LikeBird', iconPath: "${iconsPath}likebird_logo.svg"),
    Product(name: 'WideLoan', iconPath: "${iconsPath}widespace_logo.svg"),
    Product(name: 'WideEvents', iconPath: "${iconsPath}widespace_logo.svg"),
  ];

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
        title: Text(AppLocalizations.of(Get.context!)!.aboutDeveloper),
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
            SingleChildScrollView(
              child: Column(
                children: [
                  SvgPicture.asset(
                    "${iconsPath}widespace_logo.svg",
                    width: 250,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.aboutWideSpaceText,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context)!.ourProducts,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: products
                            .map((product) => Row(
                                  children: [
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                          product.iconPath,
                                          width: 96,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          product.name,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
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
