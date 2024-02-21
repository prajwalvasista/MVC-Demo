import 'dart:async';

import 'package:al_rova_mvc/controller/auth_controller.dart';
import 'package:al_rova_mvc/utils/constants/colors.dart';
import 'package:al_rova_mvc/utils/constants/fonts.dart';

import 'package:al_rova_mvc/utils/constants/strings.dart';
import 'package:al_rova_mvc/utils/widgets/toast/common_button.dart';
import 'package:al_rova_mvc/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova_mvc/views/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  String phoneNumber;
  Otp({super.key, required this.phoneNumber});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AuthUserController authUserController = AuthUserController();
  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  int _resendCountdown = 300; // Initial countdown value in seconds
  bool _isCountdownActive = true, isLoading = false;
  late Timer _countdownTimer;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    startResendCountdown();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    _countdownTimer.cancel();
    super.dispose();
  }

  void startResendCountdown() {
    _isCountdownActive = true;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          setState(() {
            _isCountdownActive = false;
          });
          _countdownTimer.cancel();
        }
      });
    });
  }

  Future<void> handleResend() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> params = <String, dynamic>{};
    params = {
      "phone": widget.phoneNumber,
    };
    try {
      var response = await authUserController.loginWithPhoneNumber(params);
      print('response==>, ${response['success']}');
      if (response['success'] == true) {
        setState(() {
          isLoading = false;
        });
        showCustomToast(context, response['resultMessage'], false);
      } else {
        setState(() {
          isLoading = false;
        });
        showCustomToast(context, response['resultMessage'], true);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showCustomToast(context, 'Something went wrong', true);
    }
    // For now, we'll just restart the countdown
    if (!_isCountdownActive) {
      _resendCountdown = 300;
      startResendCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: AppColors.white,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Image.asset("assets/images/splash_logo.png",
                              width: 250, height: 250)),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.verifyOtp.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontFamily: Fonts.poppins,
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 20,
                            ),
                            child: PinCodeTextField(
                              appContext: context,
                              pastedTextStyle: const TextStyle(
                                color: AppColors.lightGary,
                                fontWeight: FontWeight.bold,
                              ),
                              length: 4,
                              obscureText: false,
                              obscuringCharacter: '*',
                              // obscuringWidget: const FlutterLogo(
                              //   size: 24,
                              // ),
                              blinkWhenObscuring: true,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v!.length < 3) {
                                  return "Please Enter 4 digits pin.";
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(8),
                                  borderWidth: 1.5,
                                  activeColor: AppColors.primary,
                                  inactiveColor: AppColors.lightGary,
                                  fieldHeight: 50,
                                  fieldWidth: 46,
                                  activeFillColor: Colors.white,
                                  inactiveFillColor: AppColors.lightGary),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              enableActiveFill: false,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              boxShadows: const [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                debugPrint("Completed");
                              },
                              // onTap: () {
                              //   print("Pressed");
                              // },
                              onChanged: (value) {
                                debugPrint(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                debugPrint("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          hasError
                              ? "*Please fill up all the cells properly"
                              : "",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            AppStrings.donntReceiveCode,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontFamily: Fonts.poppins),
                          ),
                          if (!_isCountdownActive)
                            TextButton(
                              onPressed: () {
                                handleResend();
                              },
                              child: const Text(
                                AppStrings.resend,
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: Fonts.poppins,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primary),
                              ),
                            ),
                          if (_resendCountdown != 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '$_resendCountdown s',
                                style: const TextStyle(color: Colors.black),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: CommonButton(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              onPressed: () {
                formKey.currentState!.validate();
                // conditions for validating
                if (currentText.length != 4) {
                  errorController!.add(ErrorAnimationType
                      .shake); // Triggering error shake animation
                  setState(() => hasError = true);
                } else {
                  setState(
                    () async {
                      hasError = false;
                      setState(() {
                        isLoading = true;
                      });
                      Map<String, dynamic> params = <String, dynamic>{};
                      var prefs = await SharedPreferences.getInstance();
                      params = {
                        "enteredOtp": textEditingController.text,
                        "phoneNumber": widget.phoneNumber
                      };
                      try {
                        var response = await authUserController
                            .verifyLoginPhoneNumber(params);
                        print('response==>, $response');
                        if (response['success'] == true) {
                          setState(() {
                            isLoading = false;
                          });
                          showCustomToast(
                              context, response['resultMessage'], false);
                          await prefs.setString(
                              'phone', response['data']['phone']);
                          await prefs.setString(
                              'name', response['data']['name']);
                          await prefs.setString(
                              'token', response['data']['token']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashBoardPage(),
                            ),
                          );
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          showCustomToast(
                              context, response['resultMessage'], true);
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        showCustomToast(context, 'Something went wrong', true);
                      }
                    },
                  );
                }
              },
              buttonText: AppStrings.verify.toUpperCase(),
              buttonColor: AppColors.primary,
              buttonTextColor: AppColors.white)),
    );
  }
}
