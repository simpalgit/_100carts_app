import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/remote_urls.dart';

import 'category_model.dart';
import 'slider_model.dart';
import 'user_profile_model.dart';

class HomeModel {
  final List<CategoryModel>? categories;
  final List<SliderModel>? slider;
  final List<ProductModel>? topRatedProduct;
  final List<ProductModel>? bestSellerProduct;
  final List<ProductModel>? products;
  final UserProfileModel? profile;
  final List<dynamic>? nearByShop;
  final List<CategoryModel>? topSellingBrands;
  final List<CartWishlistModel>? carts;
  final List<CartWishlistModel>? wishlists;

  HomeModel({
    this.categories,
    this.slider,
    this.topRatedProduct,
    this.bestSellerProduct,
    this.products,
    this.profile,
    this.nearByShop,
    this.topSellingBrands,
    this.carts,
    this.wishlists,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        categories: json["categories"] == null
            ? []
            : List<CategoryModel>.from(json["categories"]!
                .map((x) => CategoryModel.fromJson(x, "main"))),
        slider: json["slider"] == null
            ? []
            : List<SliderModel>.from(
                json["slider"]!.map((x) => SliderModel.fromJson(x))),
        topRatedProduct: json["top_rated_product"] == null
            ? []
            : List<ProductModel>.from(json["top_rated_product"]!
                .map((x) => ProductModel.fromJson(x))),
        bestSellerProduct: json["best_seller_product"] == null
            ? []
            : List<ProductModel>.from(json["best_seller_product"]!
                .map((x) => ProductModel.fromJson(x))),
        products: json["products"] == null
            ? []
            : List<ProductModel>.from(
                json["products"]!.map((x) => ProductModel.fromJson(x))),
        profile: json["profile"] == null
            ? null
            : UserProfileModel.fromJson(json["profile"]),
        nearByShop: json["near_by_shop"] == null
            ? []
            : List<dynamic>.from(json["near_by_shop"]!.map((x) => x)),
        topSellingBrands: json["top_selling_brands"] == null
            ? []
            : List<CategoryModel>.from(json["top_selling_brands"]!
                .map((x) => CategoryModel.fromJson(x, "main"))),
        carts: json["carts"] == null
            ? []
            : List<CartWishlistModel>.from(
                json["carts"]!.map((x) => CartWishlistModel.fromJson(x))),
        wishlists: json["wishlists"] == null
            ? []
            : List<CartWishlistModel>.from(
                json["wishlists"]!.map((x) => CartWishlistModel.fromJson(x))),
      );
}

class ProductModel {
  final int? id;
  final int? productId;
  final String? title;
  final String? sku;
  final int? quantity;
  final String? status;

  bool? isCart;
  bool? isFavorite;
  bool? isLoading;
  final double? rating;
  final Product? product;
  final LatestImage? latestImage;
  final ActivePrice? activePrice;
  final List<dynamic>? reviews;

  set changeFav(bool val) {
    isFavorite = val;
  }

  ProductModel({
    this.id,
    this.productId,
    this.title,
    this.sku,
    this.quantity,
    this.status,
    this.isCart,
    this.isFavorite,
    this.rating,
    this.product,
    this.latestImage,
    this.activePrice,
    this.reviews,
    this.isLoading,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, [int quantity = 0]) {
    return ProductModel(
        id: json["id"],
        productId: json["product_id"],
        title: json["title"],
        sku: json["sku"],
        quantity: quantity,
        status: json["status"],
        isCart: json["isCart"],
        isFavorite: json["isFavorite"],
        rating: CommonFunctions().convertToDouble(json["rating"]),
        product: json["product"] == null
            ? null
            : Product.fromJson(
                json["product"],
                json["active_price"] == null
                    ? "0"
                    : json["active_price"]["price"].toString()),
        latestImage: json["latest_image"] == null
            ? null
            : LatestImage.fromJson(json["latest_image"]),
        activePrice: json["active_price"] == null
            ? null
            : ActivePrice.fromJson(json["active_price"]),
        reviews: json["reviews"] == null
            ? []
            : List<dynamic>.from(json["reviews"]!.map((x) => x)),
        isLoading: false);
  }
}

class quantitymodal {
  int? quantity;

  quantitymodal({this.quantity});

  factory quantitymodal.fromJson(Map<int, dynamic> json) {
    return quantitymodal(
      quantity: json['quantity'],
    );
  }
}

class OrderStatus {
  final String? status;
  final String? createdAt; // For better clarity, keep it as `createdAt`

  OrderStatus({this.status, this.createdAt});

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      status: json['status'] as String?,
      createdAt: json['created_at']
          as String?, // Assuming the date field is `created_at`
    );
  }
}

class OrderListModel {
  final int? userId;
  final int? productId;
  final String? title;
  final String? description;
  final String? sku;
  final List<OrderStatus>? orderStatusList; // List of `OrderStatus` objects
  final List<String>? orderProductList; // Titles of products
  final String? trackingStatus;
  final String? image;
  final String? totalAmount;
  final String? paidAmount;
  final String? orderDate;
  final int? quantity;
  final int? orderId;

  OrderListModel({
    this.userId,
    this.productId,
    this.title,
    this.description,
    this.sku,
    this.orderStatusList,
    this.orderProductList,
    this.trackingStatus,
    this.image,
    this.totalAmount,
    this.paidAmount,
    this.orderDate,
    this.quantity,
    this.orderId,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    // Safely extract the order status list
    List<OrderStatus>? extractOrderStatusList(dynamic statusData) {
      if (statusData is List) {
        return statusData
            .map((status) => status is Map<String, dynamic>
                ? OrderStatus.fromJson(status)
                : null) // Explicit type casting
            .where((status) => status != null) // Remove null values
            .cast<OrderStatus>()
            .toList();
      }
      return [];
    }

    // Safely extract the product list, ensuring we handle each list item correctly
    List<String>? extractOrderProductList(dynamic productsData) {
      if (productsData is List) {
        return productsData
            .map((product) {
              var variation = product['variation'];
              return variation != null
                  ? variation['title']?.toString()
                  : null; // Extract title if it exists
            })
            .where((title) => title != null) // Remove null values
            .cast<String>()
            .toList();
      }
      return [];
    }

    // Handle product data carefully and safely extract the first product (if exists)
    dynamic getFirstProduct(dynamic products) {
      return (products is List && products.isNotEmpty) ? products[0] : null;
    }

    // Safely access fields from json
    dynamic product = getFirstProduct(json['products']);
    dynamic variation = product != null ? product['variation'] : null;
    dynamic latestImage = variation != null ? variation['latest_image'] : null;

    // Return a populated OrderListModel instance
    return OrderListModel(
      userId: json["user_id"] as int?,
      productId: product?["product_id"] as int?,
      title: variation?["title"] as String?,
      description: variation?["product"]?["description"] as String?,
      sku: variation?["sku"] as String?,
      orderStatusList:
          extractOrderStatusList(json["status"]), // Order status extraction
      orderProductList:
          extractOrderProductList(json["products"]), // Product titles only
      trackingStatus: json["latest_status"] != null
          ? json["latest_status"]["status"]
          : null,
      image: latestImage?["image"] as String?,
      totalAmount: json["total_amount"]?.toString(),
      paidAmount: json["paid_amount"]?.toString(),
      orderDate: json["created_at"]
          ?.toString(), // Consider converting to DateTime if needed
      quantity: product?["quantity"] as int?,
      orderId: product?["order_id"] as int?,
    );
  }
}

class ActivePrice {
  final int? id;
  final int? variationId;
  final int? productId;
  final int? mrp;
  final int? price;
  final dynamic discount;
  final DateTime? startDate;
  final dynamic endDate;

  ActivePrice({
    this.id,
    this.variationId,
    this.productId,
    this.mrp,
    this.price,
    this.discount,
    this.startDate,
    this.endDate,
  });

  factory ActivePrice.fromJson(Map<String, dynamic> json) {
    return ActivePrice(
      id: json["id"],
      variationId: json["variation_id"],
      productId: json["product_id"],
      mrp: json["mrp"],
      price: json["price"],
      discount: CommonFunctions().calculateDiscount(json["mrp"], json["price"]),
      startDate: json["start_date"] == null
          ? null
          : DateTime.parse(json["start_date"]),
      endDate: json["end_date"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "variation_id": variationId,
        "product_id": productId,
        "mrp": mrp,
        "price": price,
        "discount": discount,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date": endDate,
      };
}

class LatestImage {
  final int? id;
  final int? productId;
  final int? variationId;
  final String? image;
  final int? tryOn;

  LatestImage({
    this.id,
    this.productId,
    this.variationId,
    this.image,
    this.tryOn,
  });

  factory LatestImage.fromJson(Map<String, dynamic> json) {
    String productUrl = "";
    if (json["image"] != null) {
      productUrl = "${RemoteUrl.variationUrl}/${json["image"]}";
    } else {
      productUrl = "";
    }

    return LatestImage(
      id: json["id"],
      productId: json["product_id"],
      variationId: json["variation_id"],
      image: productUrl,
      tryOn: json["try_on"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "variation_id": variationId,
        "image": image,
        "try_on": tryOn,
      };
}

class Product {
  final int? id;
  final int? categoryId;
  final int? tax;
  final String? description;
  final String? returnPolicy;
  final dynamic youtubeUrl;
  final dynamic warranty;
  final dynamic daysOfReturn;
  final int? deliverBetween;
  final String? status;
  final int? addedBy;
  final CategoryModel? category;
  final List<Feature>? features;
  final List<Information>? info;
  final String? amazonLink;
  final String? flipkartLink;
  final String? meeshoLink;

  Product({
    this.id,
    this.categoryId,
    this.tax,
    this.description,
    this.returnPolicy,
    this.youtubeUrl,
    this.warranty,
    this.daysOfReturn,
    this.deliverBetween,
    this.status,
    this.addedBy,
    this.category,
    this.features,
    this.info,
    this.amazonLink,
    this.flipkartLink,
    this.meeshoLink,
  });

  factory Product.fromJson(Map<String, dynamic> json, String price) {
    int tax;
    if (json["tax"] != null && price != "null") {
      double grandValue = CommonFunctions().gstAmtCalculater(
        "Add",
        price,
        json["tax"].toString(),
      );
      tax = grandValue.toInt();
    } else {
      tax = 0;
    }
    return Product(
      id: json["id"],
      categoryId: json["category_id"],
      tax: tax,
      description: json["description"],
      returnPolicy: json["return_policy"],
      youtubeUrl: json["youtube_url"],
      warranty: json["warranty"],
      daysOfReturn: json["days_of_return"],
      deliverBetween: json["deliver_between"],
      status: json["status"],
      addedBy: json["added_by"],
      category: json["category"] == null
          ? null
          : CategoryModel.fromJson(json["category"], "main"),
      features: json["features"] == null
          ? []
          : List<Feature>.from(
              json["features"]!.map((x) => Feature.fromJson(x))),
      info: json["informations"] == null
          ? []
          : List<Information>.from(
              json["informations"]!.map((x) => Information.fromJson(x))),
      amazonLink: json["amazon_link"],
      flipkartLink: json["flipkart_link"],
      meeshoLink: json["meesho_link"],
    );
  }
}

class Feature {
  final int? id;
  final int? productId;
  final String? feature;

  Feature({
    this.id,
    this.productId,
    this.feature,
  });

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        productId: json["product_id"],
        feature: json["feature"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "feature": feature,
      };
}

class Information {
  final int? id;
  final int? productId;
  final String? attribute;
  final String? value;

  Information({
    this.id,
    this.productId,
    this.attribute,
    this.value,
  });

  factory Information.fromJson(Map<String, dynamic> json) => Information(
        id: json["id"],
        productId: json["product_id"],
        attribute: json["attribute"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "attribute": attribute,
        "value": value,
      };
}

class CartWishlistModel {
  final int? id;
  final dynamic partnerId;
  final int? userId;
  final int? quantity;
  final int? productId;
  final int? variationId;

  final Variation? variation;

  CartWishlistModel({
    this.id,
    this.partnerId,
    this.userId,
    this.quantity,
    this.productId,
    this.variationId,
    this.variation,
  });

  factory CartWishlistModel.fromJson(Map<String, dynamic> json) =>
      CartWishlistModel(
        id: json["id"],
        partnerId: json["partner_id"],
        userId: json["user_id"],
        quantity: json["quantity"],
        productId: json["product_id"],
        variationId: json["variation_id"],
        variation: json["variation"] == null
            ? null
            : Variation.fromJson(json["variation"]),
      );
}

class Variation {
  final int? id;
  final int? productId;
  final String? title;
  final String? sku;
  final int? quantity;
  final String? status;

  final Product? product;
  final LatestImage? latestImage;
  final ActivePrice? activePrice;
  final bool? isCart;
  final bool? isFavorite;

  Variation({
    this.id,
    this.productId,
    this.title,
    this.sku,
    this.quantity,
    this.status,
    this.product,
    this.latestImage,
    this.activePrice,
    this.isCart,
    this.isFavorite,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        id: json["id"],
        productId: json["product_id"],
        title: json["title"],
        sku: json["sku"],
        quantity: json["quantity"],
        status: json["status"],
        product: json["product"] == null
            ? null
            : Product.fromJson(
                json["product"],
                json["active_price"] == null
                    ? "0"
                    : json["active_price"]["price"].toString()),
        latestImage: json["latest_image"] == null
            ? null
            : LatestImage.fromJson(json["latest_image"]),
        activePrice: json["active_price"] == null
            ? null
            : ActivePrice.fromJson(json["active_price"]),
        isCart: json["isCart"],
        isFavorite: json["isFavorite"],
      );
}
