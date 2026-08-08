class CreatePayOrderModel {
  final String? key;
  final int? amount;
  final String? currency;
  final String? image;
  final String? orderId;
  final String? name;
  final Prefill? prefill;
  final Notes? notes;
  final Theme? theme;
  final String? id;
  final String? discount;
  final String? subTotal;
  final String? tax;
  final String? shippingCharge;

  CreatePayOrderModel({
    this.key,
    this.amount,
    this.currency,
    this.image,
    this.orderId,
    this.name,
    this.prefill,
    this.notes,
    this.theme,
    this.id,
    this.discount,
    this.subTotal,
    this.tax,
    this.shippingCharge,
  });

  factory CreatePayOrderModel.fromJson(Map<String, dynamic> json) =>
      CreatePayOrderModel(
        key: json['data']["key"],
        amount: json['data']["amount"],
        currency: json['data']["currency"],
        image: json['data']["image"],
        orderId: json['data']["order_id"],
        name: json['data']["name"],
        prefill: json['data']["prefill"] == null
            ? null
            : Prefill.fromJson(json['data']["prefill"]),
        notes: json['data']["notes"] == null
            ? null
            : Notes.fromJson(json['data']["notes"]),
        theme: json['data']["theme"] == null
            ? null
            : Theme.fromJson(json['data']["theme"]),
        id: json["id"].toString(),
        discount: json["discount"].toString(),
        subTotal: json["subTotal"].toString(),
        tax: json["tax"].toString(),
        shippingCharge: json["shippingCharge"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "amount": amount,
        "currency": currency,
        "image": image,
        "order_id": orderId,
        "name": name,
        "prefill": prefill?.toJson(),
        "notes": notes?.toJson(),
        "theme": theme?.toJson(),
      };
}

class Notes {
  final String? address;

  Notes({
    this.address,
  });

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
      };
}

class Prefill {
  final String? name;
  final String? email;
  final int? contact;

  Prefill({
    this.name,
    this.email,
    this.contact,
  });

  factory Prefill.fromJson(Map<String, dynamic> json) => Prefill(
        name: json["name"],
        email: json["email"],
        contact: json["contact"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "contact": contact,
      };
}

class Theme {
  final String? color;

  Theme({
    this.color,
  });

  factory Theme.fromJson(Map<String, dynamic> json) => Theme(
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
      };
}
