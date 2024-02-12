import 'package:al_rova_mvc/utils/views/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 400,
              alignment: Alignment.center,
              height: 250,
            ),
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                "Login",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.all(14.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                  hintText: "Please Enter number !!",
                  prefixIcon: Icon(
                    Icons.login,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.green,
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Text(
                    "Didn't have an account? Please",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Register Here",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
