import 'package:al_rova_mvc/controller/auth_controller.dart';
import 'package:al_rova_mvc/utils/constants/colors.dart';
import 'package:al_rova_mvc/utils/constants/fonts.dart';
import 'package:al_rova_mvc/utils/constants/images.dart';
import 'package:al_rova_mvc/utils/constants/strings.dart';
import 'package:al_rova_mvc/utils/widgets/toast/common_button.dart';
import 'package:al_rova_mvc/utils/widgets/toast/common_input_box.dart';
import 'package:al_rova_mvc/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova_mvc/views/dashboard_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  AuthUserController authUserController = AuthUserController();

  bool isLoading = false;

  // open terms & condition url
  // _launchURLBrowser() async {
  //   var url = Uri.parse("https://rova.acelucid.com/terms_condition.html");
  //   await launchUrl(url);
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Image.asset(
                      Images.splashLogo,
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    AppStrings.register.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonInputBox(
                          controller: nameController,
                          hintText: AppStrings.name,
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CommonInputBox(
                          controller: phoneNumberController,
                          hintText: AppStrings.phoneNo,
                          keyboardType: TextInputType.number,
                          overrideValidator: true,
                          maxLength: 10,
                          validator: (val) {
                            if (val == null ||
                                phoneNumberController.text.isEmpty) {
                              return AppStrings.phoneNoErrorMsg;
                            } else if (phoneNumberController.text.length < 10) {
                              return AppStrings.phoneNoErrorMsg;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              Map<String, dynamic> params = <String, dynamic>{};
                              params = {
                                "name": nameController.text.toString().trim(),
                                "phone":
                                    phoneNumberController.text.toString().trim()
                              };
                              try {
                                var response = await authUserController
                                    .registerWithPhoneNumber(params);
                                print('response==>, ${response['success']}');
                                if (response['success'] == true) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showCustomToast(context,
                                      response['resultMessage'], false);
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
                                showCustomToast(
                                    context, 'Something went wrong', true);
                              }
                            }
                          },
                          child: Text(
                            AppStrings.sendOtp.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: Fonts.poppins,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black),
                          ))),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey1,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: CommonInputBox(
                      controller: otpController,
                      hintText: AppStrings.otp.toUpperCase(),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      overrideValidator: true,
                      validator: (val) {
                        if (val == null || otpController.text.isEmpty) {
                          return AppStrings.otpError;
                        } else if (otpController.text.length < 4) {
                          return AppStrings.otpError;
                        }
                        return null;
                      },
                    ),
                  )
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
      bottomNavigationBar: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(bottom: 3),
              // child: RichText(
              //   textAlign: TextAlign.center,
              //   text: TextSpan(
              //     text: AppStrings.agreeContinueMsg,
              //     style: const TextStyle(color: AppColors.black),
              //     children: <TextSpan>[
              //       TextSpan(
              //           text: AppStrings.termsCondition,
              //           recognizer: TapGestureRecognizer()
              //             ..onTap = () {
              //               _launchURLBrowser();
              //             },
              //           style: const TextStyle(
              //               fontWeight: FontWeight.bold, color: Colors.blue)),
              //       const TextSpan(text: ' and'),
              //       TextSpan(
              //           text: AppStrings.privacyPolicy,
              //           recognizer: TapGestureRecognizer()
              //             ..onTap = () {
              //               _launchURLBrowser();
              //             },
              //           style: const TextStyle(
              //               fontWeight: FontWeight.bold, color: Colors.blue)),
              //     ],
              //   ),
              // ),
            ),
            CommonButton(
              onPressed: () async {
                if (_formKey1.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  Map<String, dynamic> params = <String, dynamic>{};
                  var prefs = await SharedPreferences.getInstance();
                  params = {
                    "enteredOtp": otpController.text.trim(),
                    "phoneNumber": phoneNumberController.text.toString().trim()
                  };
                  try {
                    var response = await authUserController
                        .verifyRegisterPhoneNumber(params);
                    print('response==>, ${response['success']}');
                    if (response['success'] == true) {
                      setState(() {
                        isLoading = false;
                      });
                      showCustomToast(
                          context, response['resultMessage'], false);
                      await prefs.setString('phone', response['data']['phone']);
                      await prefs.setString('name', response['data']['name']);
                      await prefs.setString('token', response['data']['token']);
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
                      showCustomToast(context, response['resultMessage'], true);
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    showCustomToast(context, 'Something went wrong', true);
                  }
                }
              },
              buttonText: AppStrings.agreeContinue.toUpperCase(),
              buttonColor: AppColors.primary,
              buttonTextColor: AppColors.white,
              width: MediaQuery.of(context).size.width,
              height: 45,
            )
          ],
        ),
      ),
    );
  }
}
