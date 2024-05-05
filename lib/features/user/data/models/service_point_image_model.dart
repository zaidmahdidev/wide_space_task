import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/common_utils.dart';

class ServicePointImageModel {
  final int? id;
  final String? path;
  XFile? file;
  bool deleted;

  ServicePointImageModel({
    this.id,
    this.file,
    this.path,
    this.deleted = false,
  });

  ServicePointImageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        path = json['filepath'],
        deleted = false;

  static List<ServicePointImageModel> fromJsonList(List<dynamic> items) =>
      items.map((item) => ServicePointImageModel.fromJson(item)).toList();

  @override
  String toString() {
    return 'LocationImage(id: $id, path: $path, file: $file, deleted: $deleted.)';
  }

  Future<Map<String, dynamic>> toJson() async {
    return {
      'id': id,
      'delete': deleted ? 1 : 0,
      'file': await file
          ?.readAsBytes()
          .then((data) => parseBase64(data.buffer.asUint8List())),
    };
  }

  ServicePointImageModel clone() {
    return ServicePointImageModel(
        id: id, file: file, path: path, deleted: deleted);
  }
}
