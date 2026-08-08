import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:carts_app/Utils/app_network_api_services.dart';
import 'package:carts_app/Utils/remote_urls.dart';

class WalletController extends GetxController {
  var isLoading = false.obs;
  var isWithdrawLoading = false.obs;
  var balance = 0.0.obs;
  var pendingBalance = 0.0.obs;
  var cashbacks = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    isLoading.value = true;
    try {
      final response = await NetworkAPIService().getGetApiResponse(RemoteUrl.getWallet);
      if (response is Map<String, dynamic>) {
        if (response['response'] == true) {
          final data = response['data'];
          balance.value = double.tryParse(data['balance'].toString()) ?? 0.0;
          pendingBalance.value = double.tryParse(data['pending_balance'].toString()) ?? 0.0;
          cashbacks.value = data['cashbacks'] ?? [];
        } else {
          Get.snackbar('Error', response['msg'] ?? 'Failed to load wallet data');
        }
      } else if (response is http.Response) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['response'] == true) {
          balance.value = double.tryParse(data['data']['balance'].toString()) ?? 0.0;
          pendingBalance.value = double.tryParse(data['data']['pending_balance'].toString()) ?? 0.0;
          cashbacks.value = data['data']['cashbacks'] ?? [];
        } else {
          Get.snackbar('Error', data['msg'] ?? 'Failed to load wallet data');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to retrieve wallet balance: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> withdrawAmount(double amount, String paymentMethod, String accountDetails) async {
    isWithdrawLoading.value = true;
    try {
      final response = await NetworkAPIService().getPostApiResponse(
        RemoteUrl.requestWithdraw,
        jsonEncode({
          'amount': amount,
          'payment_method': paymentMethod,
          'account_details': accountDetails,
        }),
      );

      if (response is Map<String, dynamic>) {
        if (response['response'] == true) {
          Get.snackbar(
            'Success',
            response['msg'] ?? 'Withdrawal request processed successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          fetchWalletData();
          return true;
        } else {
          Get.snackbar(
            'Error',
            response['msg'] ?? 'Failed to request withdrawal',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else if (response is http.Response) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['response'] == true) {
          Get.snackbar(
            'Success',
            data['msg'] ?? 'Withdrawal request processed successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          fetchWalletData();
          return true;
        } else {
          Get.snackbar(
            'Error',
            data['msg'] ?? 'Failed to request withdrawal',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Withdrawal request failed: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isWithdrawLoading.value = false;
    }
  }
}
