import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/provider/login_sliding_up.dart';
import 'package:mahavar_technician/widgets/textfield.dart';

import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final panelProvider =
        Provider.of<SlidingUpPanelProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 13,
          ),
          Container(
            height: 4,
            width: 120,
            color: color3,
          ),
          const SizedBox(
            height: 55,
          ),
          Text(
            "Forgot Password",
            style: GoogleFonts.montserrat(
                fontSize: 24, fontWeight: FontWeight.w700, color: color2),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            'Enter your email id for verification process,',
            style: GoogleFonts.montserrat(
                fontSize: 13, fontWeight: FontWeight.w400, color: color2),
          ),
          Text(
            'We will send 4 digit code to your email',
            style: GoogleFonts.montserrat(
                fontSize: 13, fontWeight: FontWeight.w400, color: color2),
          ),
          const SizedBox(
            height: 35,
          ),
          TextBox(
              controller: _emailController,
              hinttext: " Enter your registered Email Id",
              validator: (value) {
                if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                    .hasMatch(value!)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              obscureText: false,
              label: "E-mail",
              icon: Icons.macro_off_rounded,
              ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              if (_emailController.text != "") {
                print('Email: ${_emailController.text}');
                panelProvider.changeindex(1);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              minimumSize: const Size(200, 50.0), // Set the button height
            ),
            child: Text('Continue',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
