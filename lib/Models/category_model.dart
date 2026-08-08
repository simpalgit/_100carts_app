import 'package:carts_app/Utils/remote_urls.dart';

class CategoryModel {
  final int? id;
  final String? name;
  final String? image;
  final int? categoryId;
  final List<CategoryModel>? children;

  CategoryModel({
    this.id,
    this.name,
    this.image,
    this.categoryId,
    this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String from) {
    String categoryUrl = "";
    if (json["image"] != null) {
      categoryUrl = from == "main"
          ? "${RemoteUrl.mainCategory}/${json["image"]}"
          : "${RemoteUrl.categoryUrl}/${json["image"]}";
    } else {
      categoryUrl = "";
    }

    return CategoryModel(
      id: json["id"],
      name: json["name"],
      image: categoryUrl,
      categoryId: json["category_id"] ?? 0,
      children: json["children"] == null
          ? []
          : List<CategoryModel>.from(
              json["children"]!.map((x) => CategoryModel.fromJson(x, "sub"))),
    );
  }
}
