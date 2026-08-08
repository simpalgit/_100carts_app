import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shimmer/shimmer.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/local_shared_preferences.dart';

class SideMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> homekey;
  const SideMenu({super.key, required this.homekey});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70))),
      backgroundColor: whiteColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 250,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: whiteColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                            onTap: () {
                              widget.homekey.currentState!.closeEndDrawer();
                            },
                            child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.close,
                                  color: whiteColor,
                                ))),
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      height: 100,
                      width: 130,
                      fit: BoxFit.fill,
                      imageUrl:
                          "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
                        width: 25,
                        height: 25,
                        child: Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.white,
                          enabled: true,
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: const BoxDecoration(
                                color: Colors.white70, shape: BoxShape.circle),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                          color: primaryColor,
                          alignment: Alignment.center,
                          child: Text(
                            '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.mukta(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  Text("User name",
                      maxLines: 2,
                      softWrap: true,
                      style: GoogleFonts.mukta(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("+919191919191",
                      softWrap: true,
                      maxLines: 2,
                      style:
                          GoogleFonts.mukta(color: blackColor, fontSize: 15)),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          DrawerItemTile(
            icon: const Icon(
              CupertinoIcons.person,
              color: primaryPartnerColor,
            ),
            title: 'My Profile',
            onclicked: () {},
          ),
          Container(
            color: whiteColor,
            height: 1.5,
          ),
          DrawerItemTile(
            icon: SvgPicture.asset(Images.orderList,
                height: 20,
                colorFilter: const ColorFilter.mode(
                    primaryPartnerColor, BlendMode.srcIn)),
            title: 'Order List',
            onclicked: () {},
          ),
          Container(
            color: whiteColor,
            height: 1.5,
          ),
          DrawerItemTile(
            icon: const Icon(
              Icons.privacy_tip_rounded,
              color: primaryPartnerColor,
            ),
            title: 'Policy Policy',
            onclicked: () {},
          ),
          DrawerItemTile(
            icon: const Icon(
              Icons.privacy_tip_rounded,
              color: primaryPartnerColor,
            ),
            title: 'Terms and Conditions',
            onclicked: () {},
          ),
          Container(
            color: whiteColor,
            height: 1.5,
          ),
          DrawerItemTile(
            icon: const Icon(
              Icons.logout,
              color: primaryPartnerColor,
            ),
            isTrailing: false,
            title: 'Logout',
            onclicked: () async {
              LocalPreferences().setPartnerLoginBool(false);
              final preferences = await SharedPreferences.getInstance();
              await preferences.clear();
              if (context.mounted) {
                CommonFunctions().logOut();
              }
            },
          ),
          Container(
            color: whiteColor,
            height: 1.5,
          ),
        ],
      ),
    );
  }
}

class DrawerItemTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback? onclicked;
  final bool? isTrailing;
  const DrawerItemTile({
    super.key,
    this.isTrailing = true,
    required this.title,
    required this.icon,
    this.onclicked,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: whiteColor,
        leading: icon,
        title: Text(
          title,
          style: GoogleFonts.mukta(
              fontWeight: FontWeight.w500, color: blackColor, fontSize: 15),
        ),
        trailing: isTrailing!
            ? const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: blackColor,
              )
            : null,
        onTap: onclicked);
  }
}
