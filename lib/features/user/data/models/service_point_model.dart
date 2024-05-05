import 'package:ebn_balady/features/user/data/models/service_point_image_model.dart';

class ServicePointModel {
  int? id;
  String? name;
  int? roleId;
  double? longitude;
  double? latitude;
  List<ServicePointImageModel> images = [];
  String? locationDescription;
  bool servicePointVisible = true;
  bool isAgentPoint = false;
  bool isMerchantPoint = false;

  ServicePointModel({
    this.id,
    this.name,
    this.roleId,
    this.longitude,
    this.latitude,
    required this.images,
    this.locationDescription,
    this.servicePointVisible = true,
  });

  factory ServicePointModel.init() {
    return ServicePointModel(
      id: 0,
      name: '',
      roleId: 0,
      longitude: 0,
      latitude: 0,
      locationDescription: '',
      images: [],
    );
  }

  ServicePointModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['display_name'] ?? json['name'];
    roleId = json['role_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    images = json['location_images'] != null
        ? ServicePointImageModel.fromJsonList(json['location_images'])
        : [];
    locationDescription = json['location_description'];
    servicePointVisible = json['is_location_visible'] != null
        ? json['is_location_visible'] == 1
        : true;
  }

  bool get locationInitialized => longitude != null && latitude != null;

  List<ServicePointImageModel> get unDeletedImages =>
      images.where((image) => image.deleted == false).toList();

  static List<ServicePointModel> fromJsonList(List<dynamic> items) =>
      items.map((item) => ServicePointModel.fromJson(item)).toList();

  static List<ServicePointModel> merchantsFromJsonList(List<dynamic> items) =>
      items.map((item) {
        return ServicePointModel.fromJson(item)..isMerchantPoint = true;
      }).toList();

  static List<ServicePointModel> agentsFromJsonList(List<dynamic> items) =>
      items.map((item) {
        return ServicePointModel.fromJson(item)..isAgentPoint = true;
      }).toList();

  @override
  bool operator ==(other) => other is ServicePointModel && other.id == id;

  @override
  String toString() {
    return 'ServicePointModel(id: $id, name: $name, role_id: $roleId,  long: $longitude,  lat: $latitude, images: $images, description: $locationDescription)';
  }

  @override
  int get hashCode => id.hashCode ^ super.hashCode;

  Future<Map<String, dynamic>> toJson() async {
    List<dynamic> mappedImages = [];
    for (var image in images) {
      if ((image.id != null && image.deleted == true) || image.file != null) {
        // deleted or new images
        mappedImages.add(await image.toJson());
      }
    }

    return {
      'public': servicePointVisible ? 1 : 0,
      'longitude': longitude,
      'latitude': latitude,
      'location_description': locationDescription,
      'images': mappedImages,
    };
  }

  ServicePointModel clone() {
    return ServicePointModel(
      id: id,
      name: name,
      roleId: roleId,
      longitude: longitude,
      latitude: latitude,
      servicePointVisible: servicePointVisible,
      locationDescription: locationDescription,
      images: images.map((image) => image.clone()).toList(),
    );
  }
}
