import 'dart:convert';

PaymentMethodsAccepted paymentMethodsAcceptedFromJson(String str) =>
    PaymentMethodsAccepted.fromJson(json.decode(str));

String paymentMethodsAcceptedToJson(PaymentMethodsAccepted data) =>
    json.encode(data.toJson());

class PaymentMethodsAccepted {
  String? message;
  List<AcceptedPayments>? data;

  PaymentMethodsAccepted({
    this.message,
    this.data,
  });

  factory PaymentMethodsAccepted.fromJson(Map<String, dynamic> json) =>
      PaymentMethodsAccepted(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<AcceptedPayments>.from(
                json["data"]!.map((x) => AcceptedPayments.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AcceptedPayments {
  String? category;
  String? isRefundable;
  List<String>? paymentMethods;

  AcceptedPayments({
    this.category,
    this.isRefundable,
    this.paymentMethods,
  });

  factory AcceptedPayments.fromJson(Map<String, dynamic> json) =>
      AcceptedPayments(
        category: json["category"],
        isRefundable: json["is_refundable"],
        paymentMethods: json["payment_methods"] == null
            ? []
            : List<String>.from(json["payment_methods"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "is_refundable": isRefundable,
        "payment_methods": paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x)),
      };
}
