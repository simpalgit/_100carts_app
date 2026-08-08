import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/SearchProduct/search_product_field_procider.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/no_data_found.dart';
import 'package:carts_app/Widgets/page_loader.dart';
import 'package:nb_utils/nb_utils.dart' as nb;

class SearchProductField extends StatefulWidget {
  const SearchProductField({super.key});

  @override
  State<SearchProductField> createState() => _SearchProductFieldState();
}

class _SearchProductFieldState extends State<SearchProductField> {
  final controller = Get.put(SearchProductController());
  @override
  void initState() {
    nb.setStatusBarColor(primaryColor);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.fetchData("");
    });

    super.initState();
  }

  @override
  void dispose() {
    nb.setStatusBarColor(whiteColor);
    Get.delete<SearchProductController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonFunctions.hideKeyboard(context),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: primaryColor,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: whiteColor,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        style: GoogleFonts.mukta(),
                        onChanged: (value) =>
                            controller.updateSearchQuery(value),
                        decoration: InputDecoration(
                          hintText: 'Search Product...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: blackColor,
                          ),
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: borderColor),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => controller.isLoading.value
                  ? const Expanded(child: PageLoaderScreen())
                  : controller.productList.isEmpty
                      ? const Center(
                          child: NoDataFoundScreen(
                              passedData: "Search for product",
                              image: Images.searchImage),
                        )
                      : Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return Container(
                                height: 1,
                                color: Colors.grey,
                              );
                            },
                            itemCount: controller.productList.length,
                            itemBuilder: (context, index) {
                              var data = controller.productList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  leading: CustomImage(
                                      image: data.latestImage == null
                                          ? ""
                                          : data.latestImage!.image!,
                                      imgHeight: 50,
                                      imgWidth: 50),
                                  title: Text(
                                    data.title!,
                                    style: GoogleFonts.mukta(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.5),
                                  ),
                                  subtitle: Text(
                                    data.product!.category!.name!,
                                    style: GoogleFonts.mukta(
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () => Get.toNamed(
                                      RouteName.productDetail,
                                      arguments: {"product": data}),
                                  trailing:
                                      const Icon(Icons.chevron_right_rounded),
                                ),
                              );
                            },
                          ),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
