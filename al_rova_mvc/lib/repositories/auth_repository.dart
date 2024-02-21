import 'package:al_rova_mvc/utils/constants/end_points.dart';
import 'package:al_rova_mvc/utils/services/rest_api_services.dart';

class AuthUserRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

// user login repository
  Future<dynamic> userLogin(Map<String, dynamic> params) async {
    var response = await _helper.post(EndPoints.login, params);
    return response;
  }

// verify user login repository
  Future<dynamic> verifyUserLogin(Map<String, dynamic> params) async {
    var response = await _helper.post(EndPoints.verifyLoginOtp, params);
    return response;
  }

// user register repository
  Future<dynamic> userRegister(Map<String, dynamic> params) async {
    var response = await _helper.post(EndPoints.signUpWithOtp, params);
    return response;
  }

// verify user registration repository
  Future<dynamic> verifyUserRegistration(Map<String, dynamic> params) async {
    var response = await _helper.post(EndPoints.verifySignUpOtp, params);
    return response;
  }

// update username registration repository
  Future<dynamic> updateUsername(Map<String, dynamic> params) async {
    var response = await _helper.put(EndPoints.updateUsername, params);
    return response;
  }
}
