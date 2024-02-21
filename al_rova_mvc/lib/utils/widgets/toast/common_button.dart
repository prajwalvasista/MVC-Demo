import 'package:al_rova_mvc/utils/constants/fonts.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback onPressed;
  String buttonText;
  Color buttonColor;
  Color buttonTextColor;
  double? height;
  double? width;
  CommonButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ))),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 18,
            color: buttonTextColor,
            fontFamily: Fonts.poppins,
          ),
        ),
      ),
    );
  }
}
