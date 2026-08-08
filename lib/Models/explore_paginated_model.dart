import 'home_model.dart';

class UserProductPaginatedModel {
  final bool? response;
  final int? totalSize;
  final int? limit;
  final int? offset;
  final List<ProductModel>? data;

  UserProductPaginatedModel({
    this.response,
    this.totalSize,
    this.limit,
    this.offset,
    this.data,
  });

  factory UserProductPaginatedModel.fromJson(Map<String, dynamic> json) =>
      UserProductPaginatedModel(
        response: json["response"],
        data: json["data"] == null
            ? []
            : List<ProductModel>.from(
                json["data"]!.map((x) => ProductModel.fromJson(x))),
        offset: int.parse(json["offset"]),
        limit: int.parse(json["limit"]),
        totalSize: json["total"],
      );
}
