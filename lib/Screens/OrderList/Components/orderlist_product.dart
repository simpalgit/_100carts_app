import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Screens/Cart/cart_controller.dart';
import 'package:carts_app/Screens/OrderList/Components/orderlist_list.dart';
import 'package:carts_app/Screens/OrderList/orderlist_controller.dart';
import 'package:carts_app/Utils/app_base_api_services.dart';
import 'package:carts_app/Utils/app_network_api_services.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/remote_urls.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/mrp_widget.dart';

class OrderListProduct extends StatelessWidget {
  final OrderListModel product;
  final Future<void> Function()
      refreshOrderList; // <-- Add the callback function
  const OrderListProduct(
      {super.key, required this.product, required this.refreshOrderList});

  @override
  Widget build(BuildContext context) {
    BaseApiService apiService = NetworkAPIService();
    var size = MediaQuery.of(context).size;
    OrderlistController calltheorderlistapi = OrderlistController();

    // This will give the last status from the order list
    String lastOrderStatus =
        product.orderStatusList != null && product.orderStatusList!.isNotEmpty
            ? product.orderStatusList!.last.status ?? "No status available"
            : "No status available";
    Future<void> cancelOrder() async {
      try {
        // Show the loading dialog
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible:
              false, // Prevent dismissing the dialog by tapping outside
        );

        var response = await apiService.getPostApiResponse(
            '${RemoteUrl.cancelOrder}/${product.orderId}', "");

        // After the order is canceled, refresh the order list
        await refreshOrderList();

        // Close the loading dialog
        Get.back();

        print(response);
      } catch (error) {
        // In case of an error, close the loading dialog and show an error snackbar
        Get.back();
        CommonFunctions.showErrorSnackbar(error.toString());
      }
    }

    void showOrderDetailsDialog() {
      showDialog(
        context: Get.context!,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Are you sure?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You want to cancel the order.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // "Cancel" Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Close the dialog without canceling the order
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        backgroundColor: const Color(0xFFB0B0B0), // Grey color
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                            color: Colors.white), // White text for cancel
                      ),
                    ),
                    // "OK" Button
                    ElevatedButton(
                      onPressed: () async {
                        await cancelOrder(); // Call cancelOrder and show the loading
                        Navigator.pop(
                            context); // Close the dialog after the order is canceled
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        backgroundColor: const Color(0xFFB22222), // Red color
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const Text(
                        'Yes',
                        style:
                            TextStyle(color: Colors.white), // White text for OK
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Card(
        elevation: 5, // Adds shadow to the card
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Rounded corners for the card
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImage(
                image: product.image ?? "",
                imgHeight: size.height * 0.08,
                imgWidth: size.height * 0.08,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${product.title} (${product.quantity})",
                      style: GoogleFonts.mukta(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text("Total: "),
                        Text(
                          product.totalAmount ?? "0",
                          style: GoogleFonts.mukta(
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Paid: "),
                        Text(
                          product.paidAmount ?? "0",
                          style: GoogleFonts.mukta(
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Date: "),
                        Text(
                          product.orderDate != null
                              ? (() {
                                  try {
                                    // Parse the date string to DateTime
                                    DateTime createdDate =
                                        DateTime.parse(product.orderDate!);
                                    // Format the date to the required format
                                    return DateFormat('dd MMM yyyy')
                                        .format(createdDate);
                                  } catch (e) {
                                    return 'Invalid date format';
                                  }
                                })()
                              : "No date available",
                          style: GoogleFonts.mukta(
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          lastOrderStatus,
                          style: GoogleFonts.mukta(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Order Status Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (lastOrderStatus != 'Canceled')
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  elevation: 5,
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Order Details",
                                              style: GoogleFonts.mukta(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.red[500],
                                                size: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Products:",
                                          style: GoogleFonts.mukta(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (product.orderProductList !=
                                                    null &&
                                                product.orderProductList!
                                                    .isNotEmpty)
                                              ...product.orderProductList!
                                                  .map((title) {
                                                return Container(
                                                  child: Text(
                                                    title,
                                                    style: GoogleFonts.mukta(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              })
                                            else
                                              const Text(
                                                "No product name available",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                              ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                          thickness: 1.0,
                                        ),
                                        if (product.orderStatusList != null &&
                                            product.orderStatusList!.isNotEmpty)
                                          Column(
                                            children: product.orderStatusList!
                                                .map((status) {
                                              String formattedDate =
                                                  'No date available';
                                              if (status.createdAt != null) {
                                                try {
                                                  DateTime createdDate =
                                                      DateTime.parse(
                                                          status.createdAt!);
                                                  formattedDate =
                                                      DateFormat('dd MMM yyyy')
                                                          .format(createdDate);
                                                } catch (e) {
                                                  formattedDate =
                                                      'Invalid date format';
                                                }
                                              }
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        color: status.status ==
                                                                product
                                                                    .orderStatusList!
                                                                    .last
                                                                    .status
                                                            ? Colors.orange
                                                            : Colors.green,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 2),
                                                      ),
                                                      child: Icon(
                                                        status.status ==
                                                                product
                                                                    .orderStatusList!
                                                                    .last
                                                                    .status
                                                            ? Icons.timelapse
                                                            : Icons.check,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            status.status ??
                                                                "No status available",
                                                            style: GoogleFonts
                                                                .mukta(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                  "Date: "),
                                                              Text(
                                                                formattedDate,
                                                                style:
                                                                    GoogleFonts
                                                                        .mukta(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        else
                                          const Text(
                                            "No statuses available.",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Track order",
                                style: GoogleFonts.mukta(
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (lastOrderStatus != 'Canceled')
                          InkWell(
                            onTap: () async {
                              showOrderDetailsDialog();
                            },
                            child: Text(
                              "Cancel order",
                              style: GoogleFonts.mukta(
                                color: const Color(0xFF4f46e5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
