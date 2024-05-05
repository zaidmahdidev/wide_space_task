import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../core/app_theme.dart';
import '../../../core/constants.dart';
import '../../user/presentation/pages/login_screen.dart';

class MyThemeSwitcher extends StatefulWidget {
  const MyThemeSwitcher({Key? key}) : super(key: key);

  @override
  State<MyThemeSwitcher> createState() => _MyThemeSwitcherState();
}

class _MyThemeSwitcherState extends State<MyThemeSwitcher>
    with TickerProviderStateMixin {
  bool isDarkTheme =
      false; //di.sl<SharedPreferences>().getBool(isDarkMode) ?? false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.changeTheme,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              ThemeSwitcher(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      if (isDarkTheme) {
                        _controller.animateTo(.4);
                      } else {
                        _controller.animateTo(1);
                      }
                      final switcher = ThemeSwitcher.of(context);
                      switcher.changeTheme(
                          theme: isDarkTheme
                              ? AppTheme.lightTheme
                              : AppTheme.darkTheme);
                      isDarkTheme = !isDarkTheme;
                    },
                    child: LottieBuilder.asset(
                      "${lottieAnimationsPath}theme_toggle.json",
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller.duration = composition.duration;
                        _controller.animateTo(!isDarkTheme ? .4 : 1);
                      },
                    ),
                  );
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24)),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => LoginScreen(),
                        transition: Transition.cupertino);
                  },
                  child: Text(
                    'Sign in',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24)),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => LoginScreen(),
                        transition: Transition.cupertino);
                  },
                  child: Text(
                    'Sign up',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
