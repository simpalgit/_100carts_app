import 'package:carts_app/Utils/remote_urls.dart';

class SliderModel {
  final int? id;
  final String? banner;
  final dynamic link;
  final dynamic heading;
  final dynamic text;
  final dynamic buttonName;

  SliderModel({
    this.id,
    this.banner,
    this.link,
    this.heading,
    this.text,
    this.buttonName,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    String bannerUrl = "";
    if (json["banner"] != null) {
      bannerUrl = "${RemoteUrl.sliderUrl}/${json["banner"]}";
    } else {
      bannerUrl = "";
    }
    return SliderModel(
      id: json["id"],
      banner: bannerUrl,
      link: json["link"],
      heading: json["heading"],
      text: json["text"],
      buttonName: json["button_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "banner": banner,
        "link": link,
        "heading": heading,
        "text": text,
        "button_name": buttonName,
      };
}
