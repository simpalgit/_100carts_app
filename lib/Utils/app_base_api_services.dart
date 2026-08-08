import 'package:flutter/material.dart';

abstract class BaseApiService {
  Future<dynamic> getGetApiResponse(
    String url,
  );

  Future<dynamic> getPostApiResponse(
    String url,
    dynamic data,
  );
  Future<dynamic> getPostPaymentGatewayResponse(
      String url, dynamic data, BuildContext context, String newSHA256);
  Future<dynamic> getDeleteApiResponse(
    String url,
  );

  Future<dynamic> getDeleteWithBodyApiResponse(
    String url,
    dynamic data,
  );

  Future<dynamic> getPutApiResponse(
    String url,
    dynamic data,
  );
  // --------------------------------------------------------

  Future<dynamic> loginRegisterApiResponse(
    String url,
    dynamic data,
  );
  // --------------------------------------------------------
  Future<dynamic> dioApiResponse(
    String url,
    dynamic formData,
  );
  // --------------------------------------------------------
  Future<dynamic> dioPutApiResponse(
    String url,
    dynamic formData,
  );
}
