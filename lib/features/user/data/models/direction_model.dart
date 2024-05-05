import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionModel {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const DirectionModel({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory DirectionModel.init() {
    return DirectionModel(
      bounds: LatLngBounds(southwest: const LatLng(0, 0), northeast: const LatLng(0, 0)),
      polylinePoints: [],
      totalDistance: '',
      totalDuration: '',
    );
  }

  factory DirectionModel.fromJson(Map<String, dynamic> json) {
    // Check if route is not available
    if ((json['routes'] as List).isEmpty) return DirectionModel.init();

    // Get route information
    final data = Map<String, dynamic>.from(json['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return DirectionModel(
      bounds: bounds,
      polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }

  DirectionModel fromJson(Map<String, dynamic> json) {
    return DirectionModel.fromJson(json);
  }
}
