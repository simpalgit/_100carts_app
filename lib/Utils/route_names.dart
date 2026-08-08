import 'package:get/get.dart';
import 'package:carts_app/Partner/AuthPartner/KYC/kyc_screen.dart';
import 'package:carts_app/Partner/AuthPartner/SignUpPartner/sign_up_partner.dart';
import 'package:carts_app/Partner/Home/p_home_screen.dart';
import 'package:carts_app/Partner/PartnerConfirmOrder/partner_confirm_order.dart';
import 'package:carts_app/Partner/PartnerOrderDetail/item_delivered.dart';
import 'package:carts_app/Partner/PartnerOrderDetail/partner_order_detail.dart';
import 'package:carts_app/Screens/Auth/Login/sign_in.dart';
import 'package:carts_app/Screens/Auth/Registration/sign_up.dart';
import 'package:carts_app/Screens/BottomExplore/Component/explore_filter.dart';
import 'package:carts_app/Screens/BottomExplore/explore_products.dart';
import 'package:carts_app/Screens/BottomProfile/AddAddress/add_address.dart';
import 'package:carts_app/Screens/BottomProfile/UserProfile/user_profile_screen.dart';
import 'package:carts_app/Screens/Cart/CheckOutScreen/checkout.dart';
import 'package:carts_app/Screens/Cart/Components/payment_review.dart';
import 'package:carts_app/Screens/Cart/cart_screen.dart';
import 'package:carts_app/Screens/Categories/CategoryProducts/category_products.dart';
import 'package:carts_app/Screens/Categories/CategoryProducts/product_category_filter.dart';
import 'package:carts_app/Screens/Categories/SubCategory/sub_category.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen.dart';
import 'package:carts_app/Screens/OrderList/orderist_screen.dart';
import 'package:carts_app/Screens/ProductDetail/Review/add_review.dart';
import 'package:carts_app/Screens/ProductDetail/Review/reviews_screen.dart';
import 'package:carts_app/Screens/ProductDetail/product_detail.dart';
import 'package:carts_app/Screens/SearchProduct/search_product_field.dart';
import 'package:carts_app/Screens/SplashScreen/permission_screen.dart';
import 'package:carts_app/Widgets/order_place_successful.dart';
import 'package:carts_app/Screens/SplashScreen/splash_screen.dart';
import 'package:carts_app/Screens/WishList/wishlist_screen.dart';
import '../Partner/AuthPartner/SignInPartner/sign_in_partner.dart';
import '../Screens/Auth/ForgotPassword/forgot_password.dart';
import 'package:carts_app/Screens/Wallet/wallet_screen.dart';


class RouteName {
  //! User Routes
  static const String splashScreen = "/splash_screen";
  static const String permissionScreen = "/permission_screen";
  static const String orderPlaceSuccessful = '/order_place_successful';
  static const String mainHomeScreen = "/main_home_screen";
  static const String productDetail = "/product_detail_screen";
  static const String wishListScreen = "/wishlist_screen";
  static const String orderListScreen = "/orderlist_screen";
  static const String cartScreen = "/cart_screen";
  static const String reviewsScreen = '/reviews_screen';
  static const String signInScreen = '/sign_in_creen';
  static const String signUpScreen = '/sign_up_creen';
  static const String userProfileScreen = '/user_profile_screen';
  static const String addAddressScreen = '/add_address_screen';
  static const String walletScreen = '/wallet_screen';

  static const String newExploreFilter = '/new_explore_filter';
  static const String exploreScreen = '/explore_screen';

  static const String productCategoryFilter = '/product_Category_filter';
  static const String searchProductField = '/search_product_field';
  static const String checkOutScreen = '/checkout_screen';
  static const String paymentGatwayResponse = '/payment_gatway_response';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String addReviewScreen = '/add_review_screen';
  static const String subCategoryScreen = '/sub_category_screen';
  static const String subSubCategoryScreen = '/sub_sub_category_screen';
  static const String categoryProducts = '/category_products';
  //! Partner Routes
  static const String signInPartner = '/sign_in_partner';
  static const String signUpPartner = '/Sign_up_partner';
  static const String kycScreen = '/kyc_screen';
  static const String partnerHomeScreen = '/partner_home_screen';
  static const String partnerOrderDetail = '/partner_order_detail';
  static const String partnerConfirmOrder = '/partner_confirm_order';
  static const String itemDelivered = '/item_delivered';
}

class AppRoute {
  static appRoutes() => [
        //! User Routes
        GetPage(
            name: RouteName.splashScreen,
            page: () => const SplashScreen(),
            transition: Transition.leftToRightWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.permissionScreen,
            page: () => const PermissionScreen(),
            transition: Transition.leftToRightWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.orderPlaceSuccessful,
            // page: () => const OrderPlaceSuccessful(trackingId: '',),
            page: () => const OrderPlaceSuccessful(),
            transition: Transition.leftToRightWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.mainHomeScreen,
            page: () => const MainHomeScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.productDetail,
            page: () => const ProductDetail(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.wishListScreen,
            page: () => const WishListScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.orderListScreen,
            page: () => const OrderListScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.cartScreen,
            page: () => const CartScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.reviewsScreen,
            page: () => const ReviewsScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.signInScreen,
            page: () => const SignInScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.signUpScreen,
            page: () => const SignUpScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.userProfileScreen,
            page: () => const UserProfileScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.addAddressScreen,
            page: () => const AddAddressScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.walletScreen,
            page: () => const WalletScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),

        GetPage(
            name: RouteName.newExploreFilter,
            page: () => const NewExploreFilter(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),

        GetPage(
            name: RouteName.searchProductField,
            page: () => const SearchProductField(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.checkOutScreen,
            page: () => const CheckOutScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.paymentGatwayResponse,
            page: () => const PaymentGatwayResponse(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.forgotPasswordScreen,
            page: () => const ForgotPasswordScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.addReviewScreen,
            page: () => const AddReviewScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.subCategoryScreen,
            page: () => const SubCategoryScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.subSubCategoryScreen,
            page: () => const SubSubCategoryScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.categoryProducts,
            page: () => const CategoryProducts(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.productCategoryFilter,
            page: () => const ProductCategoryFilter(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        //! Partner Routes
        GetPage(
            name: RouteName.signInPartner,
            page: () => const SignInPartner(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),

        GetPage(
            name: RouteName.signUpPartner,
            page: () => const SignUpPartner(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),

        GetPage(
            name: RouteName.kycScreen,
            page: () => const KycScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),

        GetPage(
            name: RouteName.partnerHomeScreen,
            page: () => const PartnerHomeScreen(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),

        GetPage(
            name: RouteName.partnerOrderDetail,
            page: () => const PartnerOrderDetail(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
        GetPage(
            name: RouteName.partnerConfirmOrder,
            page: () => const PartnerConfirmOrder(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),

        GetPage(
            name: RouteName.itemDelivered,
            page: () => const ItemDelivered(),
            transition: Transition.rightToLeftWithFade,
            transitionDuration: const Duration(milliseconds: 250)),
      ];
}
