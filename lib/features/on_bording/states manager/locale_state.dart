part of 'locale_cubit.dart';

@immutable
abstract class LocaleState extends Equatable {}

class LocalInitial extends LocaleState {
  @override
  List<Object?> get props => [];
}

class ChangedLocalState extends LocaleState {
  final Locale locale;

  ChangedLocalState({required this.locale});

  @override
  List<Object?> get props => [locale];
}
