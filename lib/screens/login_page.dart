import 'package:apple_ui/screens/dashboard.dart';
import 'package:apple_ui/screens/forget_password.dart';

import 'package:apple_ui/screens/registration_page.dart';

import 'package:apple_ui/ui/button.dart';
import 'package:apple_ui/ui/login_with_social.dart';
import 'package:apple_ui/ui/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'homescreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignIn GoogleAuth = GoogleSignIn();

  GlobalKey<FormState> MyKey = GlobalKey();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool loading = false;

  void ValidateFunction() {
    if (emailcontroller.text.isEmpty) {
      showSnakBar("Email is Empty");
      return;
    } else if (!isValidEmail(emailcontroller.text)) {
      showSnakBar("Please Enter a valid email");
    } else if (passwordcontroller.text.isEmpty) {
      showSnakBar("Password is Empty");
      return;
    } else if (passwordcontroller.text.length < 8) {
      showSnakBar("Password must at least 8");
      return;
    } else {
      Login();
    }
  }

  Future Login() async {
    try {
      setState(() {
        loading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      emailcontroller.clear();
      passwordcontroller.clear();
      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        showSnakBar(
            "Invalid Credentials ! Please enter valid email and password");
      } else if (e.code == 'user-not-found') {
        showSnakBar("Email does not foud");
      } else if (e.code == 'wrong-password') {
        showSnakBar("Password is incorrect");
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleAuth.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        showSnakBar("Login Successfull");
        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    } catch (e) {
      showSnakBar(e.toString());
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
      onWillPop: () async{
        return false; 
      },
      child: SafeArea(
        child: ScaffoldMessenger(
          key: SnakBarKey,
          child: Scaffold(
            backgroundColor: Color(0xffffffff),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
               // color: Colors.red,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child:   Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      margin: EdgeInsets.symmetric(vertical: 165, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xfff5f9fa)),
                        color: Color(0xfff5f9fa),

                      ),
                      child:
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      //lock icon

                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //color: Color(0xff000000),
                          image: DecorationImage(
                              image: AssetImage('assets/images/icon1.jpg'),
                              fit: BoxFit.fill
                          ),
                        ),
                      ),
    
                      SizedBox(
                        height: 20,
                      ),
    
                      // Wellcome Message
                      Text(
                        "Login",
                        style: GoogleFonts.akshar(fontSize: 22),
                      ),
    
                      //Textfiled
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: MyKey,
                          child: Column(
                            children: [
                              MyTextField(
                                  controller: emailcontroller, hinttext: 'Email',prefixIcon: Icon(Icons.email_outlined),),
                              SizedBox(
                                height: 10,
                              ),
                              MyTextField(
                                  controller: passwordcontroller,
                                  hinttext: 'Password',prefixIcon: Icon(Icons.lock_outline),suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                            ],
                          )),
    
                      SizedBox(
                        height: 10,
                      ),
    
                      //Forget passoword
                      Padding(
                        padding: const EdgeInsets.only(right: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPassword()));
                                },
                                child: Text(
                                  "Forget Password?",
                                  style: GoogleFonts.alatsi(),
                                )),
                          ],
                        ),
                      ),
    
                      SizedBox(
                        height: 10,
                      ),
    
                      //Login button
                      MyButoon(
                        loading: loading,
                        onPressed: () {
                          ValidateFunction();
                        },
                        title: 'Login',
                      ),
    
                      SizedBox(
                        height: 10,
                      ),





                      // Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Do you don't have an account ?",
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: Colors.grey
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationPage()));
                              },
                              child: Text(
                                "Sign up",
                                style: GoogleFonts.alatsi(
                                    fontSize: 15,
                                    color: Colors.black),
                              ))
                        ],
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
