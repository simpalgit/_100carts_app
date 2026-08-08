class PaymentResponse {
  final String? id;
  final String? entity;
  final int? amount;
  final String? currency;
  final String? status;
  final String? orderId;
  final dynamic invoiceId;
  final bool? international;
  final String? method;
  final int? amountRefunded;
  final dynamic refundStatus;
  final bool? captured;
  final String? description;
  final String? cardId;
  final BankCard? card;
  final dynamic bank;
  final dynamic wallet;
  final dynamic vpa;
  final String? email;
  final String? contact;
  final List<dynamic>? notes;
  final int? fee;
  final int? tax;
  final dynamic errorCode;
  final dynamic errorDescription;
  final dynamic errorSource;
  final dynamic errorStep;
  final dynamic errorReason;
  final AcquirerData? acquirerData;
  final int? createdAt;

  PaymentResponse({
    this.id,
    this.entity,
    this.amount,
    this.currency,
    this.status,
    this.orderId,
    this.invoiceId,
    this.international,
    this.method,
    this.amountRefunded,
    this.refundStatus,
    this.captured,
    this.description,
    this.cardId,
    this.card,
    this.bank,
    this.wallet,
    this.vpa,
    this.email,
    this.contact,
    this.notes,
    this.fee,
    this.tax,
    this.errorCode,
    this.errorDescription,
    this.errorSource,
    this.errorStep,
    this.errorReason,
    this.acquirerData,
    this.createdAt,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        id: json["id"],
        entity: json["entity"],
        amount: json["amount"],
        currency: json["currency"],
        status: json["status"],
        orderId: json["order_id"],
        invoiceId: json["invoice_id"],
        international: json["international"],
        method: json["method"],
        amountRefunded: json["amount_refunded"],
        refundStatus: json["refund_status"],
        captured: json["captured"],
        description: json["description"],
        cardId: json["card_id"],
        card: json["card"] == null ? null : BankCard.fromJson(json["card"]),
        bank: json["bank"],
        wallet: json["wallet"],
        vpa: json["vpa"],
        email: json["email"],
        contact: json["contact"],
        notes: json["notes"] == null
            ? []
            : List<dynamic>.from(json["notes"]!.map((x) => x)),
        fee: json["fee"],
        tax: json["tax"],
        errorCode: json["error_code"],
        errorDescription: json["error_description"],
        errorSource: json["error_source"],
        errorStep: json["error_step"],
        errorReason: json["error_reason"],
        acquirerData: json["acquirer_data"] == null
            ? null
            : AcquirerData.fromJson(json["acquirer_data"]),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "currency": currency,
        "status": status,
        "order_id": orderId,
        "invoice_id": invoiceId,
        "international": international,
        "method": method,
        "amount_refunded": amountRefunded,
        "refund_status": refundStatus,
        "captured": captured,
        "description": description,
        "card_id": cardId,
        "card": card?.toJson(),
        "bank": bank,
        "wallet": wallet,
        "vpa": vpa,
        "email": email,
        "contact": contact,
        "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
        "fee": fee,
        "tax": tax,
        "error_code": errorCode,
        "error_description": errorDescription,
        "error_source": errorSource,
        "error_step": errorStep,
        "error_reason": errorReason,
        "acquirer_data": acquirerData?.toJson(),
        "created_at": createdAt,
      };
}

class AcquirerData {
  final String? authCode;

  AcquirerData({
    this.authCode,
  });

  factory AcquirerData.fromJson(Map<String, dynamic> json) => AcquirerData(
        authCode: json["auth_code"],
      );

  Map<String, dynamic> toJson() => {
        "auth_code": authCode,
      };
}

class BankCard {
  final String? id;
  final String? entity;
  final String? name;
  final String? last4;
  final String? network;
  final String? type;
  final String? issuer;
  final bool? international;
  final bool? emi;
  final String? subType;
  final dynamic tokenIin;

  BankCard({
    this.id,
    this.entity,
    this.name,
    this.last4,
    this.network,
    this.type,
    this.issuer,
    this.international,
    this.emi,
    this.subType,
    this.tokenIin,
  });

  factory BankCard.fromJson(Map<String, dynamic> json) => BankCard(
        id: json["id"],
        entity: json["entity"],
        name: json["name"],
        last4: json["last4"],
        network: json["network"],
        type: json["type"],
        issuer: json["issuer"],
        international: json["international"],
        emi: json["emi"],
        subType: json["sub_type"],
        tokenIin: json["token_iin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "name": name,
        "last4": last4,
        "network": network,
        "type": type,
        "issuer": issuer,
        "international": international,
        "emi": emi,
        "sub_type": subType,
        "token_iin": tokenIin,
      };
}
