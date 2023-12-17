import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CustomWidget/my_text_fiels.dart';




class LoginPhonePage extends StatefulWidget {
  @override
  State<LoginPhonePage> createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> {
  var phoneController = TextEditingController();
  late FirebaseAuth firebaseAuth;
  var mVerificationId = "";
  var otpNum1 = TextEditingController();
  var otpNum2 = TextEditingController();
  var otpNum3 = TextEditingController();
  var otpNum4 = TextEditingController();
  var otpNum5 = TextEditingController();
  var otpNum6 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFireBaseAuth();
  }

  void initFireBaseAuth() {
    firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.setSettings(forceRecaptchaFlow: false, appVerificationDisabledForTesting: true);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //final _formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white24,
        body: Container(
          alignment: Alignment.center,
          height: size.height / 2,
          width: size.width,
          /*decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(152, 186, 87, 206),
                Color.fromARGB(170, 239, 229, 87),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight)),*/
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontFamily: GoogleFonts.manrope().fontFamily,
                color: Colors.black,
                  fontSize: 22,
                ),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: size.height * 0.04),
              SizedBox(
                width: size.width * 0.9,
                child: MyTextFieldWidget(
                  controller: phoneController,
                  validator: (value) {
                    if (phoneController.text.isEmpty &&
                        phoneController.text.length < 10) {
                      return 'Please entre a valid phone number';
                    }
                    return null;
                  },
                  hintText: 'Entre your Phone',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                width: size.width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  onPressed: () async {
                    //if (_formKey.currentState!.validate()) {
                    ///1
                    firebaseAuth.verifyPhoneNumber(
                      phoneNumber: '+91${phoneController.text.toString()}',
                      verificationCompleted:
                          (PhoneAuthCredential credential) {
                        firebaseAuth
                            .signInWithCredential(credential)
                            .then((value) {
                          print("Logged in: ${value.user!.uid}");
                        });
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        print("VerificationFailed: ${e.message}");
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        ///2
                        mVerificationId = verificationId;
                        print("CodeSent: ${mVerificationId}");
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                    //}
                  },
                  child: Text(
                    'Send OTP'.toUpperCase(),
                    style: TextStyle(
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  otpTextField(otpNum1, true),
                  otpTextField(otpNum2, false),
                  otpTextField(otpNum3, false),
                  otpTextField(otpNum4, false),
                  otpTextField(otpNum5, false),
                  otpTextField(otpNum6, false)
                ],
              ),
              SizedBox(height: size.height * 0.04),
              SizedBox(
                width: size.width / 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  onPressed: () {
                    //if (_formKey.currentState!.validate()) {
                    // after getting otp
                    if (otpNum1.text.isNotEmpty &&
                        otpNum2.text.isNotEmpty &&
                        otpNum3.text.isNotEmpty &&
                        otpNum4.text.isNotEmpty &&
                        otpNum5.text.isNotEmpty &&
                        otpNum6.text.isNotEmpty) {

                      var otp = "${otpNum1.text.toString()}${otpNum2.text.toString()}${otpNum3.text.toString()}${otpNum4.text.toString()}${otpNum5.text.toString()}${otpNum6.text.toString()}";
                      print("otp: $otp");

                      var cred = PhoneAuthProvider.credential(verificationId: mVerificationId, smsCode: otp);
                      firebaseAuth
                          .signInWithCredential(cred)
                          .then((value) {
                        print("Logged in: ${value.user!.uid}");
                      });

                    }
                    //}
                  },
                  child: Text(
                    'Login'.toUpperCase(),
                    style: TextStyle(
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget otpTextField(TextEditingController mController, bool autoFocus) {
    return SizedBox(
      width: 50,
      child: TextField(
        textAlign: TextAlign.center,
        autofocus: autoFocus,
        controller: mController,
        maxLines: 1,
        maxLength: 1,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
            counterText: "",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(21))),
      ),
    );
  }
}