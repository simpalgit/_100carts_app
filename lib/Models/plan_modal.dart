class InitPaymentModel {
  final bool? success;
  final String? code;
  final String? message;
  final InitPaymentData? data;

  InitPaymentModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory InitPaymentModel.fromJson(Map<String, dynamic> json) =>
      InitPaymentModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : InitPaymentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}

class InitPaymentData {
  final String? merchantId;
  final String? merchantTransactionId;
  final InstrumentResponse? instrumentResponse;

  InitPaymentData({
    this.merchantId,
    this.merchantTransactionId,
    this.instrumentResponse,
  });

  factory InitPaymentData.fromJson(Map<String, dynamic> json) =>
      InitPaymentData(
        merchantId: json["merchantId"],
        merchantTransactionId: json["merchantTransactionId"],
        instrumentResponse: json["instrumentResponse"] == null
            ? null
            : InstrumentResponse.fromJson(json["instrumentResponse"]),
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "merchantTransactionId": merchantTransactionId,
        "instrumentResponse": instrumentResponse?.toJson(),
      };
}

class InstrumentResponse {
  final String? type;
  final RedirectInfo? redirectInfo;

  InstrumentResponse({
    this.type,
    this.redirectInfo,
  });

  factory InstrumentResponse.fromJson(Map<String, dynamic> json) =>
      InstrumentResponse(
        type: json["type"],
        redirectInfo: json["redirectInfo"] == null
            ? null
            : RedirectInfo.fromJson(json["redirectInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "redirectInfo": redirectInfo?.toJson(),
      };
}

class RedirectInfo {
  final String? url;
  final String? method;

  RedirectInfo({
    this.url,
    this.method,
  });

  factory RedirectInfo.fromJson(Map<String, dynamic> json) => RedirectInfo(
        url: json["url"],
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "method": method,
      };
}
