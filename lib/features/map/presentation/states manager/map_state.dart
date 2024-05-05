part of 'map_bloc.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapListView extends MapState {
  @override
  List<Object> get props => [];
}

class MapView extends MapState {
  @override
  List<Object> get props => [];
}
