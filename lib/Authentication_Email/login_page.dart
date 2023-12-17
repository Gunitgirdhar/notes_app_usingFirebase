import 'dart:async';


import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cli/Authentication_Email/signUp_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../CustomWidget/gradient_button.dart';
import '../CustomWidget/textfield_decor.dart';
import '../main.dart';
class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({Key? key}) : super(key: key);

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  var _opacity = 0.0;

  final emailcController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 900), () {
      _opacity = 1.0;
      setState(() {});
    });
  }

  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: AnimatedOpacity(
            duration: Duration(seconds: 2),
            opacity: _opacity,
            child: Column(
              children: [
                Image(
                    image:
                    AssetImage("assets/verifications_image/verification.jpg")),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 330,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),

                            // Here i used to Animated Login Text
                            Row(
                              children: [
                                AnimatedTextKit(
                                  animatedTexts: [
                                    TyperAnimatedText("Login",
                                        speed: Duration(milliseconds: 100),
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24))
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),

                            // user name Text Feild
                            TextFormField(
                              controller: emailcController,
                              style: TextStyle(fontSize: 16),
                              decoration: TextFeildDecoration.getCustomDecoration(
                                labelText: "Email...",
                                hint: "email@gmail.com",
                                mSuffixIcon: Icons.email_outlined,
                                suffixcolor: Colors.green,
                              ),
                            ),
                            SizedBox(
                              height: 22,
                            ),

                            // user Password Text Feild
                            TextFormField(
                              controller: passwordController,
                              obscuringCharacter: "*",
                              obscureText: isPassword ? false : true,
                              decoration: TextFeildDecoration.getCustomDecoration(
                                  labelText: "Password",
                                  mSuffixIcon: isPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  suffixcolor: Colors.green,
                                  onSuffixIconTap: () {
                                    setState(() {
                                      isPassword = !isPassword;
                                    });
                                  }),
                            ),
                            SizedBox(
                              height: 13,
                            ),

                            // Used Forgot password Text
                            Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () {
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                                    },
                                    child: Text("Forgot password?",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600)))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                // In the used of Login Button I take Row
                Row(
                  children: [
                    SizedBox(
                      width: 188,
                    ),
                    GradientButton(
                        loading: isLoading,
                        title: "Login",
                        onTab: () async {
                          var auth = FirebaseAuth.instance;

                          try {
                            var cred = await auth.signInWithEmailAndPassword(
                                email: emailcController.text.toString(),
                                password: passwordController.text.toString());

                            print("Success: User Logged in..");

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(id: cred.user!.uid),
                                ));
                          } on FirebaseAuthException catch (e) {
                            print("Error: ${e.code}");
                          }
                        }),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                // Social media account Icon
                Text(
                    "--------------------------Other Account--------------------------"),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                        backgroundColor: Colors.green.shade800,
                        child: FaIcon(
                          FontAwesomeIcons.phone,
                          color: Colors.white,
                          size: 18,
                        )),
                    FaIcon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue,
                      size: 40,
                    ),
                    CircleAvatar(
                        backgroundColor: Colors.red,
                        child: FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.white,
                          size: 18,
                        )),
                    CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: FaIcon(FontAwesomeIcons.twitter,
                            color: Colors.white, size: 18)),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),

                // Switch to SignupScreen Text
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New user? ",
                      style: TextStyle(fontSize: 17),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: SignupScreenPage(),
                                  duration: Duration(milliseconds: 700)));
                        },
                        child: Text(
                          "Signup",
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }
}