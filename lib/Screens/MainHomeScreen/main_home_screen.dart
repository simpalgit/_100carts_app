import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/BottomHome/bottom_home_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/local_shared_preferences.dart';
import 'package:carts_app/Utils/route_names.dart';

import 'Component/nav_bar.dart';
import 'Component/navigation_bar_controller.dart';
import 'main_home_screen_controller.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final _homeController = BottomNavigiationController();

  final HomeScreenController _controller = Get.find();
  final bottomController = Get.put(BottomHomeController());

  onBackPressed(bool val) async {
    if (_controller.bottomNavIndex.value == 0) {
      showAlertDialouge();
    } else {
      _controller.onChangeIndex(0);
      _homeController.navListener.sink.add(0);
    }
  }

  void showAlertDialouge() {
    showDialog(
        barrierColor: Colors.white.withOpacity(0.1),
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(12)),
              title: Text(
                'Are you sure you want to exit ??',
                style: GoogleFonts.mukta(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: const Text('Yes'))
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var data = Get.arguments;
      _controller.initData(data['initPage'] as int);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => onBackPressed(didPop),
      child: Scaffold(
          backgroundColor: homeBackColor,
          body: Obx(() => _controller.isLoading.value
              ? const SizedBox()
              : StreamBuilder<int>(
                  initialData: _controller.initPage.value,
                  stream: _homeController.navListener.stream,
                  builder: (context, snapshot) {
                    int index = snapshot.data ?? 0;
                    return _controller.items[index];
                  },
                )),
          bottomNavigationBar: Obx(
            () => _controller.isLoading.value
                ? const SizedBox()
                : StreamBuilder(
                    initialData: _controller.initPage.value,
                    stream: _homeController.navListener.stream,
                    builder: (context, bottomsnapshot) {
                      return NavBar(
                        pageIndex: _controller.bottomNavIndex.value,
                        onTap: (index) async {
                          bool isUserLogin =
                              await LocalPreferences().getLoginBool() ?? false;
                          if ((index == 2 || index == 3) &&
                              isUserLogin == false) {
                            Get.toNamed(RouteName.signInScreen, arguments: {
                              "fromMainBottom": false,
                              "from":
                                  index == 3 ? "BottomProfile" : "BottomOrder"
                            });
                          } else {
                            _controller.onChangeIndex(index);
                            _homeController.navListener.sink.add(index);
                            HomeScreenController controller = Get.find();
                            await controller.getNearbyHomeData();
                          }
                        },
                      );
                    }),
          )),
    );
  }
}
