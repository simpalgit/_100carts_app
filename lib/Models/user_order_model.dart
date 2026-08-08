class UserOrderPaginatedModel {
  final bool? response;
  final List<UserOrderList>? data;
  final int? total;
  final int? offset;
  final int? limit;

  UserOrderPaginatedModel({
    this.response,
    this.data,
    this.total,
    this.offset,
    this.limit,
  });

  factory UserOrderPaginatedModel.fromJson(Map<String, dynamic> json) =>
      UserOrderPaginatedModel(
        response: json["response"],
        data: json["data"] == null
            ? []
            : List<UserOrderList>.from(
                json["data"]!.map((x) => UserOrderList.fromJson(x))),
        total: json["total"],
        offset: json["offset"] == null ? 0 : int.parse(json["offset"]),
        limit: json["limit"] == null ? 0 : int.parse(json["limit"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
        "offset": offset,
        "limit": limit,
      };
}

class UserOrderList {
  final int? id;
  final int? userId;
  final dynamic couponId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? mobile;
  final String? address;
  final String? locality;
  final int? postcode;
  final dynamic cityId;
  final String? discount;
  final String? subTotal;
  final String? tax;
  final String? shipping;
  final String? totalAmount;
  final String? paidAmount;
  final String? paymentMethod;
  final dynamic prescription;
  final String? payId;
  final String? orderId;
  final dynamic remark;
  final String? paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OrderLatestStatus? latestStatus;
  final OrderLatestProductClass? latestProduct;
  final List<OrderLatestProductClass>? products;

  UserOrderList({
    this.id,
    this.userId,
    this.couponId,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.address,
    this.locality,
    this.postcode,
    this.cityId,
    this.discount,
    this.subTotal,
    this.tax,
    this.shipping,
    this.totalAmount,
    this.paidAmount,
    this.paymentMethod,
    this.prescription,
    this.payId,
    this.orderId,
    this.remark,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    this.latestStatus,
    this.latestProduct,
    this.products,
  });

  factory UserOrderList.fromJson(Map<String, dynamic> json) => UserOrderList(
        id: json["id"],
        userId: json["user_id"],
        couponId: json["coupon_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        mobile: json["mobile"],
        address: json["address"],
        locality: json["locality"],
        postcode: json["postcode"],
        cityId: json["city_id"],
        discount: json["discount"],
        subTotal: json["sub_total"],
        tax: json["tax"],
        shipping: json["shipping"],
        totalAmount: json["total_amount"],
        paidAmount: json["paid_amount"],
        paymentMethod: json["payment_method"],
        prescription: json["prescription"],
        payId: json["pay_id"],
        orderId: json["order_id"],
        remark: json["remark"],
        paymentStatus: json["payment_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        latestStatus: json["latest_status"] == null
            ? null
            : OrderLatestStatus.fromJson(json["latest_status"]),
        latestProduct: json["latest_product"] == null
            ? null
            : OrderLatestProductClass.fromJson(json["latest_product"]),
        products: json["products"] == null
            ? []
            : List<OrderLatestProductClass>.from(json["products"]!
                .map((x) => OrderLatestProductClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "coupon_id": couponId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile": mobile,
        "address": address,
        "locality": locality,
        "postcode": postcode,
        "city_id": cityId,
        "discount": discount,
        "sub_total": subTotal,
        "tax": tax,
        "shipping": shipping,
        "total_amount": totalAmount,
        "paid_amount": paidAmount,
        "payment_method": paymentMethod,
        "prescription": prescription,
        "pay_id": payId,
        "order_id": orderId,
        "remark": remark,
        "payment_status": paymentStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "latest_status": latestStatus?.toJson(),
        "latest_product": latestProduct?.toJson(),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class OrderLatestProductClass {
  final int? id;
  final int? productId;
  final int? variationId;
  final int? orderId;
  final int? quantity;
  final int? priceId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OrderVariation? variation;

  OrderLatestProductClass({
    this.id,
    this.productId,
    this.variationId,
    this.orderId,
    this.quantity,
    this.priceId,
    this.createdAt,
    this.updatedAt,
    this.variation,
  });

  factory OrderLatestProductClass.fromJson(Map<String, dynamic> json) =>
      OrderLatestProductClass(
        id: json["id"],
        productId: json["product_id"],
        variationId: json["variation_id"],
        orderId: json["order_id"],
        quantity: json["quantity"],
        priceId: json["price_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        variation: json["variation"] == null
            ? null
            : OrderVariation.fromJson(json["variation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "variation_id": variationId,
        "order_id": orderId,
        "quantity": quantity,
        "price_id": priceId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "variation": variation?.toJson(),
      };
}

class OrderVariation {
  final int? id;
  final int? productId;
  final String? title;
  final int? quantity;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OrderVariationProduct? product;

  OrderVariation({
    this.id,
    this.productId,
    this.title,
    this.quantity,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  factory OrderVariation.fromJson(Map<String, dynamic> json) => OrderVariation(
        id: json["id"],
        productId: json["product_id"],
        title: json["title"],
        quantity: json["quantity"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        product: json["product"] == null
            ? null
            : OrderVariationProduct.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "title": title,
        "quantity": quantity,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "product": product?.toJson(),
      };
}

class OrderVariationProduct {
  final int? id;
  final int? categoryId;
  final int? tax;
  final String? description;
  final String? returnPolicy;
  final dynamic youtubeUrl;
  final String? warranty;
  final int? daysOfReturn;
  final int? deliverBetween;
  final String? status;
  final int? addedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderVariationProduct({
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
    this.createdAt,
    this.updatedAt,
  });

  factory OrderVariationProduct.fromJson(Map<String, dynamic> json) =>
      OrderVariationProduct(
        id: json["id"],
        categoryId: json["category_id"],
        tax: json["tax"],
        description: json["description"],
        returnPolicy: json["return_policy"],
        youtubeUrl: json["youtube_url"],
        warranty: json["warranty"],
        daysOfReturn: json["days_of_return"],
        deliverBetween: json["deliver_between"],
        status: json["status"],
        addedBy: json["added_by"],
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
        "tax": tax,
        "description": description,
        "return_policy": returnPolicy,
        "youtube_url": youtubeUrl,
        "warranty": warranty,
        "days_of_return": daysOfReturn,
        "deliver_between": deliverBetween,
        "status": status,
        "added_by": addedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class OrderLatestStatus {
  final int? id;
  final dynamic orderId;
  final int? userOrderId;
  final dynamic vendorId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic vendor;

  OrderLatestStatus({
    this.id,
    this.orderId,
    this.userOrderId,
    this.vendorId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.vendor,
  });

  factory OrderLatestStatus.fromJson(Map<String, dynamic> json) =>
      OrderLatestStatus(
        id: json["id"],
        orderId: json["order_id"],
        userOrderId: json["user_order_id"],
        vendorId: json["vendor_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        vendor: json["vendor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "user_order_id": userOrderId,
        "vendor_id": vendorId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "vendor": vendor,
      };
}
