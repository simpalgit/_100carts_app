import 'package:get/get.dart';

class NavController extends GetxController {
  // Observable to hold the selected page index
  var pageIndex = 0.obs;

  // Function to update the page index
  void updatePageIndex(int index) {
    pageIndex.value = index;
  }
}
