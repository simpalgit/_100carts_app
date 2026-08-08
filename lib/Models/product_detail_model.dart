import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/remote_urls.dart';

class ProductDetailModel {
  final bool? response;
  final DataDetailModel? data;
  final ParentModel? parent;
  final List<ProductModel>? related;
  bool? isLoading;

  ProductDetailModel(
      {this.response, this.data, this.parent, this.related, this.isLoading});

  factory ProductDetailModel.fromJson(
          Map<String, dynamic> json, bool isFavourite) =>
      ProductDetailModel(
          response: json["response"],
          data: json["data"] == null
              ? null
              : DataDetailModel.fromJson(json["data"], isFavourite),
          parent: json["parent"] == null
              ? null
              : ParentModel.fromJson(json["parent"]),
          related: json["related"] == null
              ? []
              : List<ProductModel>.from(
                  json["related"]!.map((x) => ProductModel.fromJson(x))),
          isLoading: false);

  // Getters for easy access
  int? get productId => data?.productId;
  int? get id => data?.id;
}

class DataDetailModel {
  final int? id;
  final int? productId;
  final String? title;
  final String? sku;
  final int? quantity;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double? rating;
  final List<ValueElement>? values;
  final List<SingleImageModel>? images;
  final ActivePrice? activePrice;
  final Product? product;
  final List<dynamic>? reviews;
  bool? isFavourite;
  bool? isCart;

  set changeFav(bool val) {
    isFavourite = val;
  }

  DataDetailModel(
      {this.id,
      this.productId,
      this.title,
      this.sku,
      this.quantity,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.rating,
      this.values,
      this.images,
      this.activePrice,
      this.product,
      this.reviews,
      this.isCart,
      this.isFavourite,
      g});

  factory DataDetailModel.fromJson(
          Map<String, dynamic> json, bool isFavourite) =>
      DataDetailModel(
        id: json["id"],
        productId: json["product_id"],
        title: json["title"],
        sku: json["sku"],
        quantity: json["quantity"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        rating: CommonFunctions().convertToDouble(json["rating"]),
        values: json["values"] == null
            ? []
            : List<ValueElement>.from(
                json["values"]!.map((x) => ValueElement.fromJson(x))),
        images: json["images"] == null
            ? []
            : List<SingleImageModel>.from(
                json["images"]!.map((x) => SingleImageModel.fromJson(x))),
        activePrice: json["active_price"] == null
            ? null
            : ActivePrice.fromJson(json["active_price"]),
        product: json["product"] == null
            ? null
            : Product.fromJson(
                json["product"],
                json["active_price"] == null
                    ? "0"
                    : json["active_price"]["price"].toString()),
        reviews: json["reviews"] == null
            ? []
            : List<dynamic>.from(json["reviews"]!.map((x) => x)),
        isFavourite: isFavourite,
        isCart: json.containsKey('isCart') ? json["isCart"] : false,
      );
}

class SingleImageModel {
  final int? id;
  final int? productId;
  final int? variationId;
  final String? image;
  final int? tryOn;

  SingleImageModel({
    this.id,
    this.productId,
    this.variationId,
    this.image,
    this.tryOn,
  });

  factory SingleImageModel.fromJson(Map<String, dynamic> json) =>
      SingleImageModel(
        id: json["id"],
        productId: json["product_id"],
        variationId: json["variation_id"],
        image: "${RemoteUrl.variationUrl}/${json["image"]}",
        tryOn: json["try_on"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "variation_id": variationId,
        "image": image,
        "try_on": tryOn,
      };
}

class ParentModel {
  final int? id;
  final String? name;
  final String? image;
  final int? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ParentModel? parent;

  ParentModel({
    this.id,
    this.name,
    this.image,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.parent,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) => ParentModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        categoryId: json["category_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        parent: json["parent"] == null
            ? null
            : ParentModel.fromJson(json["parent"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "category_id": categoryId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "parent": parent?.toJson(),
      };
}

class ValueElement {
  final int? id;
  final int? variationId;
  final int? valueId;
  final ValueValue? value;

  ValueElement({
    this.id,
    this.variationId,
    this.valueId,
    this.value,
  });

  factory ValueElement.fromJson(Map<String, dynamic> json) => ValueElement(
        id: json["id"],
        variationId: json["variation_id"],
        valueId: json["value_id"],
        value:
            json["value"] == null ? null : ValueValue.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "variation_id": variationId,
        "value_id": valueId,
        "value": value?.toJson(),
      };
}

class ValueValue {
  final int? id;
  final int? attributeId;
  final String? attributeValue;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Attribute? attribute;

  ValueValue({
    this.id,
    this.attributeId,
    this.attributeValue,
    this.createdAt,
    this.updatedAt,
    this.attribute,
  });

  factory ValueValue.fromJson(Map<String, dynamic> json) => ValueValue(
        id: json["id"],
        attributeId: json["attribute_id"],
        attributeValue: json["attribute_value"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        attribute: json["attribute"] == null
            ? null
            : Attribute.fromJson(json["attribute"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attribute_id": attributeId,
        "attribute_value": attributeValue,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "attribute": attribute?.toJson(),
      };
}

class Attribute {
  final int? id;
  final int? categoryId;
  final String? attributeName;
  final int? isVariation;
  final int? isHidden;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Attribute({
    this.id,
    this.categoryId,
    this.attributeName,
    this.isVariation,
    this.isHidden,
    this.createdAt,
    this.updatedAt,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        categoryId: json["category_id"],
        attributeName: json["attribute_name"],
        isVariation: json["isVariation"],
        isHidden: json["isHidden"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "attribute_name": attributeName,
        "isVariation": isVariation,
        "isHidden": isHidden,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
