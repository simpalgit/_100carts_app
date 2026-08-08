class RemoteUrl {
  // Production Server URL
  static String baseUrl = "https://project.onxt.in/api";
  static String uploadUrl = "https://project.onxt.in/uploads";

  // Local / Testing Server URL
  // static String baseUrl = "https://100carts-dev.loca.lt/api";
  // static String uploadUrl = "https://100carts-dev.loca.lt/uploads";


  static String imageUrl = "assets/Dummy/Products/";
  static String brandUrl = "assets/Dummy/Brands/";
  static String nearByShopUrl = "assets/Dummy/Nearby/";

  static String productUrl = "$uploadUrl/product";
  static String variationUrl = "$uploadUrl/variations";
  static String sliderUrl = "$uploadUrl/banner";
  static String mainCategory = "$uploadUrl/mainCategory";
  static String categoryUrl = "$uploadUrl/mainCategory";

  static String registerUser = "$baseUrl/register";
  static String registerSendOTP = "$baseUrl/sendOTP";
  static String loginUser = "$baseUrl/login";
  static String sendForgetOTP = "$baseUrl/sendForgetOTP";
  static String changePassword = "$baseUrl/changePassword";

  static String getHomeData = "$baseUrl/getHomeData?longitude=";
  static String getParentCategory = "$baseUrl/getParentCategory";
  static String getVariationDetail = "$baseUrl/getVariationDetail";
  static String getLivePrices = "$baseUrl/getLivePrices";
  static String getCategoryWiseAttribute = "$baseUrl/getCategoryWiseAttribute";
  static String getAttributeValueByName = "$baseUrl/getAttributeValueByName";
  static String getSubCategory = "$baseUrl/getSubCategory?categoryId=";
  static String getProduct = "$baseUrl/getProduct?limit=20&offset=";
  static String getProductOnSearch = "$baseUrl/getProduct?searchQuery=";
  static String getProductFilter = "$baseUrl/getProduct?";
  static String getSingleCatProduct = "$baseUrl/getProduct?categoryId=";
  static String getUserSavedAddress = "$baseUrl/auth/getUserSavedAddress";
  static String getUserOrder = "$baseUrl/auth/getUserOrder";
  static String updateUserOrder = "$baseUrl/auth/updateUserOrder";

  static String addUserSavedAddress = "$baseUrl/auth/addUserSavedAddress";
  static String deleteUserSavedAddress = "$baseUrl/auth/deleteUserSavedAddress";

  static String getReviews = "$baseUrl/review?limit=20&offset=";
  static String addReview = "$baseUrl/auth/review";
  static String createUserOrder = "$baseUrl/auth/createUserOrder";
  static String createPaymentOrder = "$baseUrl/auth/createPaymentOrder";
  static String createPaymentOrderAndroid =
      "$baseUrl/auth/createPaymentOrderAndroid";

  //WishList Api
  static String getWishlist = "$baseUrl/auth/getWishlistProduct";
  static String addToWishlist = "$baseUrl/auth/addToWishlist?product_id=";
  static String deleteFromWishlist =
      "$baseUrl/auth/deleteFromWishlist?product_id=";

  //Cart Api
  static String getCart = "$baseUrl/auth/getCartProducts";

  static String addToCart = "$baseUrl/auth/addToCart";
  static String emptyCart = "$baseUrl/auth/emptyCart";
  static String deleteFromCart = "$baseUrl/auth/deleteFromCart?product_id=";

  static String deleteSendOTP = "$baseUrl/auth/sendDeleteOtp";
  static String deleteAccount = "$baseUrl/auth/deleteAccount";

  // Partner ///

  static String getState = "$baseUrl/getState";
  static String getDistrict = "$baseUrl/getDistrict?state_id=";
  static String getCity = "$baseUrl/getCity?district_id=";
  static String getServices = "$baseUrl/getServices";
  static String registerPartner = "$baseUrl/registerPartner";
  static String loginPartner = "$baseUrl/loginPartner";
  static String sendForgetOtpPartner = "$baseUrl/sendForgetOtpPartner";
  static String changePartnerPassword = "$baseUrl/changePartnerPassword";
  static String partnerProfile = "$baseUrl/auth/profile";
  static String updatePartnerKyc = "$baseUrl/auth/updatePartnerKyc";

  static String getAttributeList = "$baseUrl/getAttributeList";
  static String searchProduct = "$baseUrl/auth/searchProduct";
  static String filterProduct = "$baseUrl/auth/filterProduct";
  static String placeOrder = "$baseUrl/auth/placePartnerOrder";
  static String partnerOrderList = "$baseUrl/auth/getPartnerOrder?offset=";
  static String downloadOrderReciept = "$baseUrl/auth/orderReciept";
  static String cancelOrder = "$baseUrl/auth/cancelOrder";
  static String getAllAccessoryProduct = "$baseUrl/getAllProduct?offset=";
  static String getPartnerCartProduct = "$baseUrl/auth/getPartnerCartProduct";
  static String addToPartnerCart =
      "$baseUrl/auth/addToPartnerCart?variation_id=";

  static String deleteFromPartnerCart =
      "$baseUrl/auth/deleteFromPartnerCart?variation_id=";

  static String getAllProductAttribute = "$baseUrl/auth/getAllProductAttribute";

  static String filterAllProduct = "$baseUrl/auth/filterAllProduct?";

  static String orderCartProduct = "$baseUrl/auth/orderCartProduct?";
  static String testUrl =
      "https://warrantyuat.tyrechecks.com/api/State/GetStateMaster";

  // Cashback & Affiliate Endpoints
  static String generateAffiliate = "$baseUrl/auth/affiliate/generate";
  static String getWallet = "$baseUrl/auth/wallet";
  static String requestWithdraw = "$baseUrl/auth/withdraw";

//phonepe
  static const liveMerchatID = "M22JSQVIDU85E";
  static const liveSaltKey = "c5c73abf-274e-4353-969f-e882221927c7";
  static const startTrasactionLive =
      "https://api-preprod.phonepe.com/apis/hermes";
}
