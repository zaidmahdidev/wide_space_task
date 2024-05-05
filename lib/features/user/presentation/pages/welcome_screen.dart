import 'package:ebn_balady/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../../core/data_providers/local_data_provider.dart';
import '../../../../core/utils/screen_util.dart';
import '../../../../injection_container.dart';
import '../../../on_bording/pages/onboarding.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Container(
                      height: 36,
                      width: 36,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      margin: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: FittedBox(
                        child: Icon(
                          Icons.translate,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )),
                  onTap: () async {
                    if (Get.locale!.languageCode == "ar") {
                      await Get.updateLocale(const Locale('en', 'US'));
                      await sl<LocalDataProvider>().addToSingleValueCacheData(
                          boxName: 'CACHED_LANGUAGE', data: "en");
                    } else {
                      await Get.updateLocale(const Locale('ar', 'YE'));
                      await sl<LocalDataProvider>().addToSingleValueCacheData(
                          boxName: 'CACHED_LANGUAGE', data: "ar");
                    }
                  },
                )
              ],
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: "header_title",
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: AppLocalizations.of(context)!.appName,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                          ],
                        ),
                      ),
                    ),
                    Hero(
                        tag: "header_sub_title",
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            AppLocalizations.of(context)!.appSlogan,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            ScreenUtil.orientation == Orientation.portrait
                ? Flexible(
                    flex: 6,
                    child: Hero(
                      tag: "app_logo",
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.screenWidth * .12),
                        child: Image.asset(
                          Get.isDarkMode
                              ? '${imagesPath}logo_dark.png'
                              : '${imagesPath}logo.png',
                          width: ScreenUtil.screenWidth * .4,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const Spacer(
              flex: 1,
            ),
            CupertinoButton(
                child: ClipOval(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.navigate_next,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                onPressed: () {
                  Get.to(() => const Onboarding(),
                      transition: Transition.cupertino,
                      duration: const Duration(milliseconds: 500));
                }),
            SizedBox(
              height: ScreenUtil.screenWidth * .07,
            ),
          ],
        ),
      ),
    );
  }
}
