import 'package:ebn_balady/features/user/data/models/service_point_model.dart';

class MapServicePoints {
  List<ServicePointModel> merchantPoints = [];
  List<ServicePointModel> agentPoints = [];

  List<ServicePointModel> get all => [...merchantPoints, ...agentPoints];

  MapServicePoints({
    required this.merchantPoints,
    required this.agentPoints,
  });

  factory MapServicePoints.init() {
    return MapServicePoints(
      merchantPoints: [],
      agentPoints: [],
    );
  }

  MapServicePoints.fromJson(Map<String, dynamic> json) {
    merchantPoints = json['merchants'] != null
        ? ServicePointModel.merchantsFromJsonList(json['merchants'])
        : [];
    agentPoints = json['agents'] != null
        ? ServicePointModel.agentsFromJsonList(json['agents'])
        : [];
  }

  fromJson(Map<String, dynamic> json) {
    return MapServicePoints.fromJson(json);
  }
}
