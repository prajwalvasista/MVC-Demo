import 'package:al_rova_mvc/controller/auth_controller.dart';
import 'package:al_rova_mvc/utils/constants/colors.dart';
import 'package:al_rova_mvc/utils/constants/images.dart';
import 'package:al_rova_mvc/utils/constants/strings.dart';
import 'package:al_rova_mvc/utils/widgets/toast/common_button.dart';
import 'package:al_rova_mvc/utils/widgets/toast/common_input_box.dart';
import 'package:al_rova_mvc/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova_mvc/views/otp_page.dart';
import 'package:al_rova_mvc/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthUserController authUserController = AuthUserController();
  bool isLoading = false;
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
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                       "assets/images/splash_logo.png",
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                      )),
                  const SizedBox(height: 20),
                  const Text(
                    AppStrings.signIn,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: CommonInputBox(
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  CommonButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        Map<String, dynamic> params = <String, dynamic>{};
                        params = {
                          "phone": phoneNumberController.text.toString().trim(),
                        };
                        try {
                          var response = await authUserController
                              .loginWithPhoneNumber(params);
                          print('response==>, $response');
                          if (response['success'] == true) {
                            setState(() {
                              isLoading = false;
                            });
                            showCustomToast(
                                context, response['resultMessage'], false);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Otp(
                                        phoneNumber: phoneNumberController.text
                                            .toString())));
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
                    buttonText: AppStrings.signIn,
                    buttonColor: AppColors.primary,
                    buttonTextColor: AppColors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.dontHaveAnAccount,
                        style: TextStyle(
                          color: Color(0xFF07243C),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: const Text(
                          AppStrings.registerHere,
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
    );
  }
}
