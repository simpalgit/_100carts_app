import 'package:shared_preferences/shared_preferences.dart';

const loginUserKey = "USER_LOGIN_STATUS";
const loginPartnerKey = "PARTNER_LOGIN_STATUS";
const custAuthKey = "CUSTAUTHKEY";
const profileDataKey = "PROFILEDATAKEY";
const wishListKey = "WISHLISTKEY";

class LocalPreferences {
  Future setLoginBool(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(loginUserKey, value);
  }

  Future<bool?> getLoginBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginUserKey);
  }

  // ------------------------------------------------------------------

  Future setPartnerLoginBool(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(loginPartnerKey, value);
  }

  Future<bool?> getPartnerLoginBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginPartnerKey);
  }

  // ------------------------------------------------------------------

  Future setAuthToken(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(custAuthKey, val);
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(custAuthKey);
  }

  // ------------------------------------------------------------------

  Future setProfileData(String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(profileDataKey, val);
  }

  Future<String?> getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profileDataKey);
  }

  // ----------------------------------------------------------------------

  Future setStoredWishList(List<String> val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList(wishListKey, val);
  }

  Future<List<String>?> getStoredWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(wishListKey);
  }

  // ----------------------------------------------------------------------
}
