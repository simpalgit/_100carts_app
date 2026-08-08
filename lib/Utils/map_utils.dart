import 'dart:io';

import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(
    double latitude,
    double longitude,
  ) async {
    String googleMapUrl =
        "google.navigation:q=$latitude,$longitude&dir_action=navigate";

    String appleMapsUrl =
        "https://maps.apple.com/?daddr=$latitude,$longitude&dirflg=d";

    // String googleMapUrl =
    //     "https://www.google.com/maps/dir/?api=1&destination=$destLatitude,$destLongitude&dir_action=navigate";
    Uri url = Uri.parse(Platform.isAndroid ? googleMapUrl : appleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Fluttertoast.showToast(msg: "Could not able Open Map.");
    }

    // if (await canLaunch(googleMapUrl)) {
    //   await launch(googleMapUrl);
    // }
  }
}
