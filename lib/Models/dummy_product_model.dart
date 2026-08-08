class DummyProductModel {
  final String? prodId;
  final String? name;
  final String? category;
  final String? prodCat;
  final String? mainImage;
  final List<String>? images;
  final int? price;
  final int? offerPrice;
  final List<String>? desription;
  bool? isFavourite;

  DummyProductModel({
    this.prodId,
    this.name,
    this.category,
    this.prodCat,
    this.mainImage,
    this.images,
    this.price,
    this.offerPrice,
    this.desription,
    this.isFavourite,
  });

  set changeState(bool val) {
    isFavourite = val;
  }

  factory DummyProductModel.fromJson(Map<String, dynamic> json) =>
      DummyProductModel(
          prodId: json["prodId"],
          name: json["name"],
          category: json["category"],
          prodCat: json["prodCat"],
          mainImage: json["mainImage"],
          images: json["images"] == null
              ? []
              : List<String>.from(json["images"]!.map((x) => x)),
          price: json["price"],
          offerPrice: json["offerPrice"],
          desription: json["desription"] == null
              ? []
              : List<String>.from(json["desription"]!.map((x) => x)),
          isFavourite: false);

  Map<String, dynamic> toJson() => {
        "prodId": prodId,
        "name": name,
        "category": category,
        "prodCat": prodCat,
        "mainImage": mainImage,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "price": price,
        "offerPrice": offerPrice,
        "desription": desription == null
            ? []
            : List<dynamic>.from(desription!.map((x) => x)),
      };
}
