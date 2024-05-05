abstract class BaseModel {
  bool? isActive, isSynced;
  DateTime? createdAt, updatedAt;

  bool get isModified => createdAt != updatedAt;

  BaseModel({this.isActive, this.isSynced, this.createdAt, this.updatedAt});

  BaseModel.fromMap(Map<String, dynamic> map)
      : isActive = map.containsKey('active') ? _parseBool(map['active']) : true,

        /// `synced` key exists only on `db` else then the request comes from `api` so set as `1`
        isSynced = map.containsKey('synced') ? _parseBool(map['synced']) : true,

        /// if `created_at` key exists then parse it else if comes from api then set as now

        createdAt = map.containsKey('created_at') ? DateTime.parse(map['created_at']) : DateTime.now(),
        updatedAt = map.containsKey('updated_at') ? DateTime.parse(map['updated_at']) : DateTime.now();

  Map<String, dynamic> toMap() => {
        'active': isActive == null ? 1 : (isActive ?? false ? 1 : 0),
        'synced': isSynced == null ? 1 : (isSynced ?? false ? 1 : 0),
        'created_at': '${createdAt ?? DateTime.now()}',
        'updated_at': '${DateTime.now()}',
      };

  static bool _parseBool(dynamic value) => value is int ? value == 1 : value as bool;

  @override
  int get hashCode => isActive.hashCode ^ isSynced.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;

  @override
  bool operator ==(other) =>
      other is BaseModel &&
      other.isActive == isActive &&
      other.isSynced == isSynced &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  String toString() {
    return 'isActive: $isActive, isSynced: $isSynced, createdAt: $createdAt, updatedAt: $updatedAt';
  }
}
