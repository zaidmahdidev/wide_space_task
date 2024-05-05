import 'dart:ui';

import 'package:clip/l10n/clip_localizations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:ebn_balady/core/app_theme.dart';
import 'package:ebn_balady/features/home/presentation/pages/main_screen.dart';
import 'package:ebn_balady/features/map/presentation/states%20manager/map_bloc.dart';
import 'package:ebn_balady/features/user/presentation/manager/user_bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_validation/flutter_validation.dart';
import 'package:get/get.dart';
import 'package:regex_router/regex_router.dart';

import 'core/data_providers/local_data_provider.dart';
import 'core/models/current_provider.dart';
import 'features/chat/pages/routes.dart';
import 'features/posts/presentation/states manager/posts_bloc/posts_bloc.dart';
import 'features/user/data/repositories/oauth_repository.dart';
import 'features/user/presentation/pages/login_screen.dart';
import 'features/user/presentation/pages/welcome_screen.dart';
import 'injection_container.dart' as di;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = window.locale;
  late String userLanguage;
  late dynamic page;

  @override
  void initState() {
    try {
      userLanguage = di
          .sl<LocalDataProvider>()
          .getSingleValueCachedData(boxName: 'CACHED_LANGUAGE');
    } catch (e) {
      di.logger.d('No user language has been defined yet!');
      userLanguage = Get.deviceLocale?.languageCode ?? '';
    }

    if (userLanguage == 'en') {
      _locale = const Locale('en', 'US');
    } else {
      _locale = const Locale('ar', 'YE');
    }

    page = const WelcomeScreen();
    if (OAuthRepository.isExists) {
      if (!Current.isLoggedIn) {
        page = const LoginScreen();
      } else {
        page = const MainScreen();
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => di.sl.get<PostsBloc>()
              ..add(const GetPostsEvent(pageNumber: 1))),
        BlocProvider(
          create: (_) => di.sl.get<UserBloc>()..add(SwitchToViewProfile()),
        ),
        BlocProvider(
          create: (_) => di.sl.get<MapBloc>(),
        ),
      ],
      child: GetMaterialApp(
        onGenerateRoute: RegexRouter.create(chatModuleRoutes).generateRoute,
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) {
          return AppLocalizations.of(context)!.appName;
        },
        localizationsDelegates: const [
          CountryLocalizations.delegate,
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          ValidationLocalizations.delegate,
          AttributeLocalizations.delegate,
          ClipLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
          Locale('es'),
          Locale('de'),
          Locale('fr'),
          Locale('el'),
          Locale('et'),
          Locale('nb'),
          Locale('nn'),
          Locale('pl'),
          Locale('pt'),
          Locale('ru'),
          Locale('hi'),
          Locale('ne'),
          Locale('uk'),
          Locale('hr'),
          Locale('tr'),
          Locale('lv'),
          Locale('lt'),
          Locale('ku'),
          Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hans'), // Generic Simplified Chinese 'zh_Hans'
          Locale.fromSubtags(
              languageCode: 'zh',
              scriptCode: 'Hant'), // Generic traditional Chinese 'zh_Hant'
        ],
        themeMode: AppTheme.getThemeMode(),
        // themeMode: ThemeMode.dark,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        locale: _locale,
        home: FeatureDiscovery(
          child: page,
        ),
      ),
    );
  }
}
