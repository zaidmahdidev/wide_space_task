part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

class ToMapView extends MapEvent {
  const ToMapView();

  @override
  List<Object?> get props => [];
}

class ToListView extends MapEvent {
  const ToListView();

  @override
  List<Object?> get props => [];
}
