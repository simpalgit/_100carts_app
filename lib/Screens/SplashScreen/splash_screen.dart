import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Screens/SplashScreen/permission_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/images.dart';

import 'splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final contrller = Get.put(SplashScreenController());
  final permission = Get.put(PermissionController());
  @override
  void initState() {
    contrller.initData();
    Future.delayed(const Duration(seconds: 3), () {
      contrller.checkData();
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SplashScreenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                Images.appLogo,
                height: size.height * 0.25,
                width: size.width * 0.7,
              ),
            ),
          ),
          // const AnimatedTextWidget(
          //   text: "Fetching data ..",
          // ),
          const SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                color: primaryColor,
              )),
          // const SizedBox(
          //   height: 10,
          // ),
          // Obx(() => SizedBox(
          //       width: size.width * 0.6,
          //       child: LinearProgressIndicator(
          //         backgroundColor: Colors.grey,
          //         valueColor: const AlwaysStoppedAnimation<Color>(
          //           primaryColor,
          //         ),
          //         value: contrller.progress.value,
          //       ),
          //     )),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
