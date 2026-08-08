import 'package:carts_app/Models/user_profile_model.dart';
import 'package:carts_app/Utils/common_functions.dart';

class ReviewPaginatedModel {
  final bool? response;
  final List<ReviewModel>? data;
  final int? total;
  final String? offset;
  final String? limit;
  final int? fiveStarPercentage;
  final int? fourStarPercentage;
  final int? threeStarPercentage;
  final int? twoStarPercentage;
  final int? oneStarPercentage;

  ReviewPaginatedModel({
    this.response,
    this.data,
    this.total,
    this.offset,
    this.limit,
    this.fiveStarPercentage,
    this.fourStarPercentage,
    this.threeStarPercentage,
    this.twoStarPercentage,
    this.oneStarPercentage,
  });

  factory ReviewPaginatedModel.fromJson(Map<String, dynamic> json) =>
      ReviewPaginatedModel(
        response: json["response"],
        data: json["data"] == null
            ? []
            : List<ReviewModel>.from(
                json["data"]!.map((x) => ReviewModel.fromJson(x))),
        total: json["total"] ?? 0,
        offset: json["offset"],
        limit: json["limit"],
        fiveStarPercentage: json["five_star_percentage"] ?? 0,
        fourStarPercentage: json["four_star_percentage"] ?? 0,
        threeStarPercentage: json["three_star_percentage"] ?? 0,
        twoStarPercentage: json["two_star_percentage"] ?? 0,
        oneStarPercentage: json["one_star_percentage"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
        "offset": offset,
        "limit": limit,
        "five_star_percentage": fiveStarPercentage,
        "four_star_percentage": fourStarPercentage,
        "three_star_percentage": threeStarPercentage,
        "two_star_percentage": twoStarPercentage,
        "one_star_percentage": oneStarPercentage,
      };
}

class ReviewModel {
  final int? id;
  final int? productId;
  final int? variationId;
  final int? userId;
  final String? title;
  final String? review;
  final double? rating;
  final int? verified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserProfileModel? user;

  ReviewModel({
    this.id,
    this.productId,
    this.variationId,
    this.userId,
    this.title,
    this.review,
    this.rating,
    this.verified,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        productId: json["product_id"],
        variationId: json["variation_id"],
        userId: json["user_id"],
        title: json["title"],
        review: json["review"],
        rating: CommonFunctions().convertToDouble(json["rating"]),
        verified: json["verified"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null
            ? null
            : UserProfileModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "variation_id": variationId,
        "user_id": userId,
        "title": title,
        "review": review,
        "rating": rating,
        "verified": verified,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}
