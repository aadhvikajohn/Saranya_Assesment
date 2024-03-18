import 'package:apple_ui/ui/button.dart';
import 'package:apple_ui/ui/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<FormState> MyKey = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  bool loading = false;

  void ForgetFunction() {
    if (emailcontroller.text.isEmpty) {
      showSnakBar("Email is Empty");
      return;
    } else if (!isValidEmail(emailcontroller.text)) {
      showSnakBar("Please Enter a valid email");
    } else {
      Reset_Password();
    }
  }

  Future Reset_Password() async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailcontroller.text.toString())
          .then((value) {
        showSnakBar("We have Send to email ! Please Check Your email");

            
        Future.delayed(const Duration(seconds:10), () {

// Here you can write your code

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage()));

        });
        emailcontroller.clear();
        setState(() {
          loading = false;
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        showSnakBar("Invalid Credentials ! Please enter valid email");
      } else if (e.code == 'user-not-found') {
        showSnakBar("Email does not foud");
      }
      setState(() {
        loading = false;
      });
    }
  }

  // Function to validate email using a regular expression
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  // snackbar function
  void showSnakBar(String message) {
    final snakbar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 4),
    );
    SnakBarKey.currentState?.showSnackBar(snakbar);
  }

  final SnakBarKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: ScaffoldMessenger(
          key: SnakBarKey,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.grey[300],
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: Icon(
                Icons.arrow_back,
                  color: Color(0xff000000),
                ),
              ),
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      //lock icon
                      Icon(
                        Icons.lock,
                        size: 60,
                      ),

                      //Textfiled
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: MyKey,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: MyTextField(
                                    controller: emailcontroller,
                                    hinttext: 'Email'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )),

                      SizedBox(
                        height: 10,
                      ),

                      //Login button
                      MyButoon(
                        loading: loading,
                        onPressed: () {
                          ForgetFunction();
                        },
                        title: 'Reset Password',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
