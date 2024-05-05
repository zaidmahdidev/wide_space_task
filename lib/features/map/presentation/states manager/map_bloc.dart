import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapListView()) {
    on<MapEvent>((event, emit) {
      if (event is ToMapView) {
        emit(MapView());
      }
      if (event is ToListView) {
        emit(MapListView());
      }
    });
  }
}
