import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/data_providers/local_data_provider.dart';
import '../../../../core/utils/common_utils.dart';
import '../../../../injection_container.dart';
import '../../../user/presentation/pages/change_email_screen.dart';
import '../../../user/presentation/pages/change_password_screen.dart';
import '../../../user/presentation/widgets/log_password_bottom_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool requestPending = false;
  PackageInfo? packageInfo;

  bool get localAuthEnabled =>
      sl<LocalDataProvider>()
          .getSingleValueCachedData(boxName: 'USE_LOCAL_AUTH') ??
      true;
  int lastTap = 0;
  int consecutiveTaps = 0;
  GlobalKey<EnsureVisibleState> ensureVisibleGlobalKey =
      GlobalKey<EnsureVisibleState>();

  @override
  void initState() {
    getPackageInfo().whenComplete(() {
      setState(() {});
    });
    runSettingFeaturesDiscovery(context);
    super.initState();
  }

  openMenu() {
    ZoomDrawer.of(context)!.toggle();
  }

  Future<void> getPackageInfo() async {
    await PackageInfo.fromPlatform().then((value) => packageInfo = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => openMenu(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(Get.context!)!.settings),
        centerTitle: false,
      ),
      body: (packageInfo != null)
          ? SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.security,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const ChangePasswordPage());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18.0),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 3,
                                offset: const Offset(0, 4)),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.changePassword,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const ChangeEmailPage());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18.0),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 3,
                                offset: const Offset(0, 4)),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.changeEmail,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    InkWell(
                      onTap: () async {
                        await sl<LocalDataProvider>()
                            .addToSingleValueCacheData(
                                boxName: 'USE_LOCAL_AUTH',
                                data: !localAuthEnabled)
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18.0),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 3,
                                offset: const Offset(0, 4)),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .enableLockScreenLogin,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                            ),
                            SizedBox(
                              height: 10,
                              width: 40,
                              child: DescribedFeatureOverlay(
                                featureId: 'biometric_login',
                                tapTarget: IgnorePointer(
                                  child: Switch(
                                    activeColor:
                                        Theme.of(context).colorScheme.surface,
                                    value: localAuthEnabled,
                                    onChanged: (val) async {},
                                  ),
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .featureDiscoveryLockScreenLogin,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold),
                                ),
                                description: Text(
                                  AppLocalizations.of(context)!
                                      .featureDiscoveryLockScreenLoginDesc,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.4),
                                      ),
                                ),
                                contentLocation: ContentLocation.above,
                                overflowMode: OverflowMode.extendBackground,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                targetColor:
                                    Theme.of(context).colorScheme.primary,
                                textColor:
                                    Theme.of(context).colorScheme.primary,
                                barrierDismissible: false,
                                backgroundDismissible: true,
                                onOpen: () async {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                      (Duration duration) {
                                    ensureVisibleGlobalKey.currentState
                                        ?.ensureVisible();
                                  });
                                  return true;
                                },
                                child: IgnorePointer(
                                  child: Switch(
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    value: localAuthEnabled,
                                    onChanged: (val) async {},
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    EnsureVisible(
                      key: ensureVisibleGlobalKey,
                      child: const SizedBox(
                        height: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.app,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (String value) async {
                        if (value == 'en') {
                          updateLanguage(const Locale('en', 'US'));
                          await sl<LocalDataProvider>()
                              .addToSingleValueCacheData(
                                  boxName: 'CACHED_LANGUAGE', data: 'en');
                        } else {
                          updateLanguage(const Locale('ar', 'YE'));
                          await sl<LocalDataProvider>()
                              .addToSingleValueCacheData(
                                  boxName: 'CACHED_LANGUAGE', data: 'ar');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18.0),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 3,
                                offset: const Offset(0, 4)),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.language,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                            ),
                            Text(
                              Get.locale!.languageCode,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'en',
                          child: Text(
                            'English',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'ar',
                          child: Text(
                            'العربية',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    PopupMenuButton<String>(
                      onSelected: (String value) async {
                        AppTheme.changeTheme(value == "dark");
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18.0),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 4,
                                offset: const Offset(0, 4)),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.changeTheme,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'dark',
                          child: Text(
                            AppLocalizations.of(Get.context!)!.darkMode,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'light',
                          child: Text(
                            AppLocalizations.of(Get.context!)!.lightMode,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.about,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        launchURL(sl<FirebaseRemoteConfig>()
                            .getString('privacyPolicy'));
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18.0),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 3,
                                offset: const Offset(0, 4)),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.privacyPolicy,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        launchURL(
                            sl<FirebaseRemoteConfig>().getString('termsOfUse'));
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18.0),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 3,
                                offset: const Offset(0, 4)),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.termsOfUse,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        int now = DateTime.now().millisecondsSinceEpoch;
                        if (now - lastTap < 1000) {
                          consecutiveTaps++;
                          if (consecutiveTaps == 7) {
                            bool? show = await LogPasswordBottomSheet.show();
                            if (show ?? false) {
                              setState(() {
                                logger = Logger(filter: ProductionFilter());
                                enableLoggerDebugMode = true;
                              });
                            }
                          }
                        } else {
                          consecutiveTaps = 0;
                          if (enableLoggerDebugMode) {
                            setState(() {
                              logger = Logger(filter: DevelopmentFilter());
                              enableLoggerDebugMode = false;
                            });
                          }
                        }
                        lastTap = now;
                      },
                      child: Center(
                        child: Text(
                          '${AppLocalizations.of(context)!.appVersion}${packageInfo!.version} (${packageInfo!.buildNumber})',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: enableLoggerDebugMode
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.4)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            )
          : Shimmer.fromColors(
              enabled: true,
              baseColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              highlightColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(.1),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    padding: const EdgeInsets.all(18.0),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surface.withOpacity(.2),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            blurRadius: 4,
                            offset: const Offset(0, 4)),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'xxx xxx xxx xxx',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: 12,
              )),
    );
  }
}
