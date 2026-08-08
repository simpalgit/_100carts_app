import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'wallet_controller.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletController());

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: Text(
          'Wallet & Cashback',
          style: GoogleFonts.mukta(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: whiteColor),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.cashbacks.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }

        return RefreshIndicator(
          color: primaryColor,
          onRefresh: () => controller.fetchWalletData(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Balance Cards Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildBalanceCard(
                              title: "Available Balance",
                              amount: "₹${controller.balance.value.toStringAsFixed(2)}",
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1F5FD6), Color(0xFF3F7FFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              icon: Icons.account_balance_wallet,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildBalanceCard(
                              title: "Pending Balance",
                              amount: "₹${controller.pendingBalance.value.toStringAsFixed(2)}",
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE65C00), Color(0xFFF9D423)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              icon: Icons.hourglass_empty,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Withdrawal action button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: controller.balance.value >= 1.0
                              ? () => _showWithdrawDialog(context, controller)
                              : () {
                                  Get.snackbar(
                                    'Notice',
                                    'You need at least ₹1.00 to request a withdrawal.',
                                    backgroundColor: Colors.orange,
                                    colorText: Colors.white,
                                  );
                                },
                          icon: const Icon(Icons.arrow_upward, color: whiteColor),
                          label: Text(
                            "Withdraw Money",
                            style: GoogleFonts.mukta(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.balance.value >= 1.0
                                ? secondaryColor
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // History Header
                      Text(
                        "Cashback & Transaction History",
                        style: GoogleFonts.mukta(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // Ledger Transactions List
              controller.cashbacks.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.history,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No transactions recorded yet.",
                              style: GoogleFonts.mukta(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final txn = controller.cashbacks[index];
                          return _buildTransactionItem(txn);
                        },
                        childCount: controller.cashbacks.length,
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBalanceCard({
    required String title,
    required String amount,
    required Gradient gradient,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 140,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const Opacity(
                opacity: 0.15,
                child: Icon(Icons.currency_rupee, color: Colors.white, size: 40),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.mukta(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                amount,
                style: GoogleFonts.mukta(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(dynamic txn) {
    final double amount = double.tryParse(txn['cashback_amount'].toString()) ?? 0.0;
    final String status = (txn['status'] ?? 'pending').toString().toLowerCase();
    final String marketplace = txn['marketplace'] ?? 'Affiliate Store';
    final String description = txn['description'] ?? 'Cashback Credited';
    final String rawDate = txn['created_at'] ?? '';
    
    String formattedDate = '';
    try {
      if (rawDate.isNotEmpty) {
        final DateTime dt = DateTime.parse(rawDate).toLocal();
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      }
    } catch (_) {
      formattedDate = rawDate;
    }

    final bool isDebit = amount < 0;
    final String displayAmount = (isDebit ? "-" : "+") + "₹${amount.abs().toStringAsFixed(2)}";

    Color statusColor = Colors.orange;
    if (status == 'approved') {
      statusColor = Colors.green;
    } else if (status == 'rejected') {
      statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: GoogleFonts.mukta(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: GoogleFonts.mukta(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: GoogleFonts.mukta(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            displayAmount,
            style: GoogleFonts.mukta(
              color: isDebit ? Colors.red : Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, WalletController controller) {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(text: controller.balance.value.toStringAsFixed(0));
    final detailsController = TextEditingController();
    String selectedMethod = 'UPI';

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Request Withdrawal",
          style: GoogleFonts.mukta(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Withdrawable Balance: ₹${controller.balance.value.toStringAsFixed(2)}",
                  style: GoogleFonts.mukta(color: Colors.grey[700], fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Withdrawal Amount (₹)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amt = double.tryParse(value);
                    if (amt == null) {
                      return 'Please enter a valid number';
                    }
                    if (amt <= 0) {
                      return 'Amount must be greater than 0';
                    }
                    if (amt > controller.balance.value) {
                      return 'Amount exceeds withdrawable balance';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedMethod,
                  decoration: const InputDecoration(
                    labelText: "Payment Method",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'UPI', child: Text('UPI ID (GPay / PhonePe / Paytm)')),
                    DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer (A/C & IFSC)')),
                    DropdownMenuItem(value: 'Paytm Wallet', child: Text('Paytm Wallet Number')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      selectedMethod = val;
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    labelText: "Account / Payment Details",
                    hintText: "Enter UPI ID or Account details...",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter account details';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: GoogleFonts.mukta(color: Colors.grey)),
          ),
          Obx(() {
            return ElevatedButton(
              onPressed: controller.isWithdrawLoading.value
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        final amt = double.parse(amountController.text.trim());
                        final success = await controller.withdrawAmount(
                          amt,
                          selectedMethod,
                          detailsController.text.trim(),
                        );
                        if (success) {
                          Get.back();
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: controller.isWithdrawLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text("Submit", style: GoogleFonts.mukta(color: whiteColor)),
            );
          }),
        ],
      ),
    );
  }
}
