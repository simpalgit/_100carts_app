import 'package:dartz/dartz.dart';
import 'package:carts_app/Models/state_city_model.dart';
import 'package:carts_app/Utils/app_failure.dart';
import 'dart:convert';
import 'package:carts_app/Utils/app_network_api_services.dart';
import 'package:carts_app/Utils/remote_urls.dart';
import 'package:carts_app/Utils/app_exceptions.dart';

// Simple Mock Repository - No Complex Dependencies
class AuthRepository {
  Future<Either<Failure, dynamic>> loginUser(
      String mobile, String password) async {
    try {
      var data = jsonEncode({"mobile": mobile, "password": password});
      final response = await NetworkAPIService().loginRegisterApiResponse(
        RemoteUrl.loginUser,
        data,
      );
      return Right(response);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message, e.statusCode));
      }
      return Left(ServerFailure(e.toString(), 500));
    }
  }

  Future<Either<Failure, dynamic>> registerUser(dynamic data) async {
    await Future.delayed(Duration(seconds: 1));
    return Right({
      "statusCode": 200,
      "body": '{"response": true, "message": "Registration successful"}'
    });
  }

  Future<dynamic> sendOTP(String mobile) async {
    await Future.delayed(Duration(seconds: 1));
    return {"status": true, "message": "Mock OTP sent"};
  }

  Future<Either<Failure, dynamic>> sendOtp({required String passedData}) async {
    await Future.delayed(Duration(seconds: 1));
    // Mock response - replace with actual API call
    return Right({
      "statusCode": 200,
      "body": '{"response": true, "message": "OTP sent successfully"}'
    });
  }

  Future<dynamic> forgetPassword(String mobile) async {
    await Future.delayed(Duration(seconds: 1));
    return {"status": true, "message": "Mock forget password"};
  }

  Future<dynamic> changePassword(dynamic data) async {
    await Future.delayed(Duration(seconds: 1));
    return {"status": true, "message": "Mock password changed"};
  }

  Future<dynamic> getSavedAddress() async {
    await Future.delayed(Duration(seconds: 1));
    return {"status": true, "message": "Mock address retrieved"};
  }

  Future<dynamic> saveAddress(dynamic data) async {
    await Future.delayed(Duration(seconds: 1));
    return {"status": true, "message": "Mock address saved"};
  }

  Future<dynamic> deleteAddress(String id) async {
    await Future.delayed(Duration(seconds: 1));
    return {"status": true, "message": "Mock address deleted"};
  }

  Future<dynamic> sendDeleteOtp() async {
    await Future.delayed(Duration(seconds: 1));
    return {"status": true, "message": "Mock delete OTP sent"};
  }

  Future<dynamic> deleteAccount(dynamic data) async {
    await Future.delayed(Duration(seconds: 1));
    return {"status": true, "message": "Mock account deleted"};
  }

  Future<Either<Failure, List<StatesModel>>> getStates() async {
    await Future.delayed(Duration(seconds: 1));
    // Mock data - replace with actual API call
    final mockStates = [
      StatesModel(id: 1, name: "State 1"),
      StatesModel(id: 2, name: "State 2"),
      StatesModel(id: 3, name: "State 3"),
    ];
    return Right(mockStates);
  }

  Future<Either<Failure, List<DistrictModel>>> getDistrict(
      {required int stateId}) async {
    await Future.delayed(Duration(seconds: 1));
    // Mock data - replace with actual API call
    final mockDistricts = [
      DistrictModel(id: 1, stateId: stateId, name: "District 1"),
      DistrictModel(id: 2, stateId: stateId, name: "District 2"),
      DistrictModel(id: 3, stateId: stateId, name: "District 3"),
    ];
    return Right(mockDistricts);
  }

  Future<Either<Failure, List<CityModel>>> getCity(
      {required int districtId}) async {
    await Future.delayed(Duration(seconds: 1));
    // Mock data - replace with actual API call
    final mockCities = [
      CityModel(id: 1, stateId: 1, districtId: districtId, name: "City 1"),
      CityModel(id: 2, stateId: 1, districtId: districtId, name: "City 2"),
      CityModel(id: 3, stateId: 1, districtId: districtId, name: "City 3"),
    ];
    return Right(mockCities);
  }
}
