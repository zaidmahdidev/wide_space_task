import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/constants.dart';
import '../states manager/locale_cubit.dart';
import 'onboarding.dart';

class LanguageSelector extends StatelessWidget {
  LanguageSelector({Key? key}) : super(key: key);

  late int index;
  final items = [
    "العربية",
    "English",
  ];

  @override
  Widget build(BuildContext context) {
    index = Localizations.localeOf(context).toString() == "en" ? 1 : 0;
    return BlocProvider.value(
      value: BlocProvider.of<LocaleCubit>(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: -500,
                right: -160,
                child: Transform.rotate(
                  angle: 95 * math.pi / 180,
                  child: SvgPicture.asset(
                    "${iconsPath}main_shape.svg",
                    width: 400,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Positioned(
                bottom: -520,
                right: 20,
                child: Transform.rotate(
                  angle: 95 * math.pi / 180,
                  child: SvgPicture.asset(
                    "${iconsPath}main_shape.svg",
                    width: 400,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: SvgPicture.asset(
                      "${imagesPath}welcome_logo.svg",
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          width: 250,
                          child: RichText(
                            softWrap: true,
                            textDirection: TextDirection.ltr,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Welcome to',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                                TextSpan(
                                  text: ' Ebn Balady',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                                TextSpan(
                                  text: ' Please chooes a language',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: SizedBox(
                          width: 250,
                          child: RichText(
                            textDirection: TextDirection.rtl,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'أهلا بك في',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                                TextSpan(
                                  text: '  إبن بلدي',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                                TextSpan(
                                  text: ' من فضلك قم بإختيار لغة',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 120,
                      child: BlocBuilder<LocaleCubit, LocaleState>(
                        builder: (context, state) {
                          if (state is ChangedLocalState) {
                            return CupertinoPicker(
                                selectionOverlay:
                                    CupertinoPickerDefaultSelectionOverlay(
                                  background: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.2),
                                ),
                                itemExtent: 56,
                                scrollController: FixedExtentScrollController(
                                    initialItem: index),
                                onSelectedItemChanged: (int value) {
                                  index = value;
                                  if (kDebugMode) {
                                    print(value);
                                  }
                                  print(Localizations.localeOf(context));
                                  Get.updateLocale(
                                      Locale(value == 1 ? 'en' : 'ar'));
                                },
                                children: List.generate(items.length, (index) {
                                  final isSelected = this.index == index;
                                  final item = items[index];
                                  final color = isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.black38;
                                  return Center(
                                    child: Text(
                                      item,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: color,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }));
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: CupertinoButton(
                        child: ClipOval(
                          child: Container(
                            color: Theme.of(context).colorScheme.primary,
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.navigate_next,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => const Onboarding(),
                              transition: Transition.native,
                              duration: const Duration(seconds: 1));
                        }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
