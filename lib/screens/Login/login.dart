// ignore_for_file: unused_import, unnecessary_null_comparison

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/provider/login_sliding_up.dart';
import 'package:mahavar_technician/provider/mobileno_provider.dart';
import 'package:mahavar_technician/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_technician/screens/Login/forgot_password.dart';
import 'package:mahavar_technician/screens/Login/pin_page.dart';
import 'package:mahavar_technician/screens/Login/reset_password.dart';
import 'package:mahavar_technician/widgets/textfield.dart';
import 'package:mahavar_technician/screens/Signup/signup.dart';
import 'package:mahavar_technician/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mobileNo = TextEditingController();

  bool isOpen = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(25.0),
              // child: Container(
              //   alignment: Alignment.topLeft,
              //   height: 35,
              //   width: 35,
              //   decoration: const BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.all(Radius.circular(8))),
              //   child: InkWell(
              //     child: Center(
              //       child: Icon(
              //         Icons.arrow_back_rounded,
              //         size: 25,
              //         color: color1,
              //       ),
              //     ),
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //   ),
              // ),
            ),
            Center(
              child: Container(
                // alignment: Alignment.center,
                height: 205,
                width: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/login_pic.png"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            // SizedBox(height: 15,),
            Container(
              height: MediaQuery.of(context).size.height * 0.60,
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 5,
                    width: 120,
                    decoration: BoxDecoration(
                      color: color3,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      color: color2,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Enter your WhatsApp Number to continue.",
                    style: TextStyle(
                      color: color2,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextBox(
                    controller: mobileNo,
                    hinttext: "Mobile Number",
                    label: "",
                    obscureText: false,
                    isNumber: true,
                    icon: Icons.phone,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "A 4 digit OTP will be sent via WhatsApp to verify your phone number.",
                    style: TextStyle(
                      color: color3,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (mobileNo.text.length == 10) {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          await HttpApiCall().sendOTP(
                            context,
                            {
                              "mobile": mobileNo.text,
                              "page_type": "login",
                            },
                          );
                          Provider.of<MobileNo>(context, listen: false)
                              .setMobileNumber(mobileNo.text);
                        } catch (e) {
                          showToast(context,
                              "Something went wrong. Please try again.", 3);
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        showToast(context, "Enter a Valid 10 Digit Number", 3);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color2,
                      minimumSize: const Size(170, 45),
                      maximumSize: const Size(170, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 18, 
                            height: 18, 
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth:
                                  3.0, 
                            ),
                          )
                        : const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
