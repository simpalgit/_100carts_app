import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:carts_app/Utils/remote_urls.dart';

dynamic createJson({
  required String merachantId,
  required String merchantTransactionId,
  required String merchantUserId,
  required int amount,
  required String redirectUrl,
  required String redirectMode,
  required String callbackUrl,
  required String targetApp,
  String? mobileNumber,
}) {
  String deviceOs = "";
  if (Platform.isAndroid) {
    deviceOs = "ANDROID";
  } else if (Platform.isIOS) {
    deviceOs = "IOS";
  }

  return {
    "merchantId": merachantId,
    "merchantTransactionId": merchantTransactionId,
    "merchantUserId": merchantUserId,
    "amount": amount,
    "mobileNumber": mobileNumber,
    "callbackUrl": callbackUrl,
    // "paymentInstrument": {"type": "UPI_INTENT", "targetApp": targetApp},
    "paymentInstrument": {"type": "PAY_PAGE"},
    "deviceContext": {"deviceOS": deviceOs}
  };
}

String idGenerator() {
  final now = DateTime.now();
  return "MT${now.microsecondsSinceEpoch.toString()}";
}

String convertJsonToBase64(dynamic json) {
  String jsonString = jsonEncode(json);
  String base64String = base64.encode(utf8.encode(jsonString));
  return base64String;
}

Future<String> sha256New({required String base}) async {
  // String data = "$base$saltKey";
  List<int> bytes = utf8.encode(base);
  Digest digest = sha256.convert(bytes);
  var hash = digest;
  return "${hash.toString()}###1";
}

Future<String> statusSha256New({required String transactionId}) async {
  String data =
      "/pg/v1/status/${RemoteUrl.liveMerchatID}/$transactionId${RemoteUrl.liveSaltKey}";
  List<int> bytes = utf8.encode(data);
  Digest digest = sha256.convert(bytes);
  var hash = digest;
  return "${hash.toString()}###1";
}
