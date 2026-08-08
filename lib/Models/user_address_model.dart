class UserAddressModel {
  final int? id;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? mobile;
  final String? address;
  final String? locality;
  final int? postcode;
  final dynamic cityId;
  bool? selected;

  set changeSelection(bool val) {
    selected = val;
  }

  UserAddressModel({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.address,
    this.locality,
    this.postcode,
    this.cityId,
    this.selected,
  });

  factory UserAddressModel.fromJson(Map<String, dynamic> json) =>
      UserAddressModel(
        id: json["id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        mobile: json["mobile"],
        address: json["address"],
        locality: json["locality"],
        postcode: json["postcode"],
        cityId: json["city_id"],
        selected: false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile": mobile,
        "address": address,
        "locality": locality,
        "postcode": postcode,
        "city_id": cityId,
      };
}
