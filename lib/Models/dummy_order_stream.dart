import 'dart:async';

class DummyOrderStream {
  final String? orderId;
  final DummyCustomer? customer;
  final OrderLocation? orderLocation;
  final String? orderDate;
  final List<DummyItem>? items;
  final double? totalAmount;
  Duration duration;
  late Timer? timer;

  DummyOrderStream({
    this.orderId,
    this.customer,
    this.orderDate,
    this.items,
    this.totalAmount,
    this.orderLocation,
    required this.duration,
  });

  factory DummyOrderStream.fromJson(Map<String, dynamic> json) =>
      DummyOrderStream(
          orderId: json["order_id"],
          customer: json["customer"] == null
              ? null
              : DummyCustomer.fromJson(json["customer"]),
          orderDate: json["order_date"],
          items: json["items"] == null
              ? []
              : List<DummyItem>.from(
                  json["items"]!.map((x) => DummyItem.fromJson(x))),
          totalAmount: json["total_amount"]?.toDouble(),
          orderLocation: OrderLocation.fromJson(json["order_location"]),
          duration: const Duration(minutes: 1));
}

class DummyCustomer {
  final String? customerId;
  final String? name;
  final String? email;
  final String? phone;
  final Address? address;

  DummyCustomer({
    this.customerId,
    this.name,
    this.email,
    this.phone,
    this.address,
  });

  factory DummyCustomer.fromJson(Map<String, dynamic> json) => DummyCustomer(
        customerId: json["customer_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address?.toJson(),
      };
}

class Address {
  final String? street;
  final String? city;
  final String? state;
  final String? zip;
  final String? fullAddress;

  Address({
    this.street,
    this.city,
    this.state,
    this.zip,
    this.fullAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"],
        city: json["city"],
        state: json["state"],
        zip: json["zip"],
        fullAddress:
            "${json["street"]},${json["city"]},${json["state"]},${json["zip"]}",
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "zip": zip,
      };
}

class OrderLocation {
  final double? longitude;
  final double? latitude;
  OrderLocation({this.longitude, this.latitude});

  factory OrderLocation.fromJson(Map<String, dynamic> json) => OrderLocation(
        longitude: json["latitude"],
        latitude: json["longitude"],
      );
}

class DummyItem {
  final String? itemId;
  final String? name;
  final int? quantity;
  final double? price;

  DummyItem({
    this.itemId,
    this.name,
    this.quantity,
    this.price,
  });

  factory DummyItem.fromJson(Map<String, dynamic> json) => DummyItem(
        itemId: json["item_id"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "name": name,
        "quantity": quantity,
        "price": price,
      };
}
