import 'package:al_rova_mvc/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthUserController {
  final AuthUserRepository _authUserRepository = AuthUserRepository();
  final ValueNotifier<bool> isLoadingState = ValueNotifier<bool>(false);

// login with phone number controller
  Future<dynamic> loginWithPhoneNumber(Map<String, dynamic> params) async {
    var res = await _authUserRepository.userLogin(params);
    return res;
  }

// verify login with phone number controller
  Future<dynamic> verifyLoginPhoneNumber(Map<String, dynamic> params) async {
    var res = await _authUserRepository.verifyUserLogin(params);
    return res;
  }

// register with phone number controller
  Future<dynamic> registerWithPhoneNumber(Map<String, dynamic> params) async {
    var res = await _authUserRepository.userRegister(params);
    return res;
  }

// verify register with phone number controller
  Future<dynamic> verifyRegisterPhoneNumber(Map<String, dynamic> params) async {
    var res = await _authUserRepository.verifyUserRegistration(params);
    return res;
  }

// update username controller
  Future<dynamic> updateUsername(Map<String, dynamic> params) async {
    var res = await _authUserRepository.updateUsername(params);
    return res;
  }
}
