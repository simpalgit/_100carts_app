class StatesModel {
  final int? id;
  final String? name;

  StatesModel({
    this.id,
    this.name,
  });

  factory StatesModel.fromJson(Map<String, dynamic> json) => StatesModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class DistrictModel {
  final int? id;
  final int? stateId;
  final String? name;
  final dynamic createdAt;
  final dynamic updatedAt;

  DistrictModel({
    this.id,
    this.stateId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        id: json["id"],
        stateId: json["state_id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_id": stateId,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class CityModel {
  final int? id;
  final int? stateId;
  final int? districtId;
  final String? name;
  final dynamic createdAt;
  final dynamic updatedAt;

  CityModel({
    this.id,
    this.stateId,
    this.districtId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json["id"],
        stateId: json["state_id"],
        districtId: json["district_id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_id": stateId,
        "district_id": districtId,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
