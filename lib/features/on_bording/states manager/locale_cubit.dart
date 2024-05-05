import 'package:ebn_balady/core/utils/language_cache_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocalInitial());

  Future<void> getSavedLanguage() async {
    final String? cachedLanguageCode =
        await LanguageCacheHelper().getCachedLanguageCode();
    emit(ChangedLocalState(locale: Locale(cachedLanguageCode!)));
  }

  Future<void> changeLanguage(String languageCode) async {
    await LanguageCacheHelper().cacheLanguageCode(languageCode);
    emit(ChangedLocalState(locale: Locale(languageCode)));
    print("emitting language$languageCode");
  }
}
