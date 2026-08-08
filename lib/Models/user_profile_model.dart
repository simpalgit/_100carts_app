class UserProfileModel {
  final int? id;
  final String? name;
  final String? email;
  final int? mobile;
  final dynamic googleId;
  final dynamic profilePic;
  final dynamic emailVerifiedAt;
  final dynamic referBy;

  UserProfileModel({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.googleId,
    this.profilePic,
    this.emailVerifiedAt,
    this.referBy,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        googleId: json["google_id"],
        profilePic: json["profile_pic"],
        emailVerifiedAt: json["email_verified_at"],
        referBy: json["refer_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "google_id": googleId,
        "profile_pic": profilePic,
        "email_verified_at": emailVerifiedAt,
        "refer_by": referBy,
      };
}
