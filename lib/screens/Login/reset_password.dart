// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/provider/login_sliding_up.dart';
import 'package:provider/provider.dart';
import 'package:mahavar_technician/widgets/textfield.dart';
import 'package:mahavar_technician/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newpassword = TextEditingController();
  final TextEditingController _newpasswordconfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final panelProvider =
        Provider.of<SlidingUpPanelProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Form(
        key: _formKey,
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
              height: 35,
            ),
            Text(
              "Reset Password",
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.w700, color: color2),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Set a new password for you account so you',
              style: GoogleFonts.montserrat(
                  fontSize: 13, fontWeight: FontWeight.w400, color: color2),
            ),
            Text(
              'can login and access all the features',
              style: GoogleFonts.montserrat(
                  fontSize: 13, fontWeight: FontWeight.w400, color: color2),
            ),
            const SizedBox(
              height: 25,
            ),
            TextBox(
              controller: _newpassword,
              hinttext: "Password",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              obscureText: true,
              label: "New password",
              isPassword: true,
            ),
            const SizedBox(height: 8.0),
            TextBox(
              controller: _newpasswordconfirm,
              hinttext: "Confirm password",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _newpassword.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              obscureText: true,
              label: "Confirm new password",
              isPassword: true,
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print('DONE');
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const BottomNavBar()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: const Size(200, 50.0), // Set the button height
              ),
              child: Text('Reset Password',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
