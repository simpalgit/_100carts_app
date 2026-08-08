import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/route_names.dart';

class OrderPlaceSuccessful extends StatefulWidget {
  const OrderPlaceSuccessful({super.key});

  @override
  _OrderPlaceSuccessfulState createState() => _OrderPlaceSuccessfulState();
}

class _OrderPlaceSuccessfulState extends State<OrderPlaceSuccessful> {
  int countdown = 3; // Countdown as mutable variable
  late Timer _timer;

  // Function to start the countdown and navigate after delay
  void redirectingin() {
    // Start the countdown and update UI every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--; // Decrement countdown
        });
      } else {
        // When the countdown reaches 0, stop the timer and navigate
        timer.cancel();
        // Ensure navigation happens after frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Use Get.offNamed to replace this page so it doesn't appear when going back
          Get.offNamed(RouteName.mainHomeScreen);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the redirectingin method when the widget is first created
    redirectingin();
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Images.deliveryTruck,
            height: 150,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Your order has been placed successfully.",
            style: GoogleFonts.mukta(color: blackColor, fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: size.width * 0.7,
            height: size.height * 0.05,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                // Use Get.offNamed here as well to replace the page and not allow coming back
                Get.offNamed(RouteName.mainHomeScreen);
              },
              child: Text(
                "Go back",
                style: GoogleFonts.mukta(
                  color: whiteColor,
                ),
              ),
            ),
          ),
          // Show countdown on the UI
          TextButton(
            onPressed: () {},
            child: Text(
              "$countdown seconds remaining", // Display the countdown
              style: GoogleFonts.mukta(
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//! tracking order
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class OrderStatusPage extends StatefulWidget {
//   final String trackingId;

//   OrderStatusPage({required this.trackingId});

//   @override
//   _OrderStatusPageState createState() => _OrderStatusPageState();
// }

// class _OrderStatusPageState extends State<OrderStatusPage> {
//   late Future<Map<String, dynamic>> _orderStatus;

//   // Replace with your actual credentials
//   final String username = 'your_username';
//   final String password = 'your_password';

//   @override
//   void initState() {
//     super.initState();
//     _orderStatus = fetchOrderStatus(widget.trackingId);
//   }

//   Future<Map<String, dynamic>> fetchOrderStatus(String trackingId) async {
//     // Construct the URL with query parameters
//     final String url =
//         'https://clbeta.ecomexpress.in/track_me/api/mawbd/?username=$username&password=$password&awb=$trackingId';

//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         // Parse the response
//         final Map<String, dynamic> data = json.decode(response.body);
//         return data;
//       } else {
//         throw Exception('Failed to load order status');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Order Status"),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _orderStatus,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final orderStatus = snapshot.data!;

//             // Check if the response has data for events
//             if (orderStatus['data'] != null && orderStatus['data']['events'] != null) {
//               var events = orderStatus['data']['events'];

//               return ListView.builder(
//                 itemCount: events.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(events[index]['description'] ?? 'No description'),
//                     subtitle: Text(events[index]['date'] ?? 'No date available'),
//                   );
//                 },
//               );
//             } else {
//               return Center(child: Text('No tracking events available.'));
//             }
//           }
//           return Center(child: Text('No data available'));
//         },
//       ),
//     );
//   }
// }
