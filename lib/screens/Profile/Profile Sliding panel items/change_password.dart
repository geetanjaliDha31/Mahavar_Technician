import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/widgets/textfield.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChangePassworsSlidingPanel extends StatefulWidget {
  final PanelController controller;
  const ChangePassworsSlidingPanel({super.key, required this.controller});

  @override
  State<ChangePassworsSlidingPanel> createState() =>
      _ChangePassworsSlidingPanelState();
}

class _ChangePassworsSlidingPanelState
    extends State<ChangePassworsSlidingPanel> {
  TextEditingController currPassword = TextEditingController();

  TextEditingController newPassword = TextEditingController();

  TextEditingController cfnNewPassword = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  // void dispose() {
  //   currPassword.clear();
  //   newPassword.clear();
  //   cfnNewPassword.clear();

  //   widget.controller.close();

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Password",
                    style: GoogleFonts.montserrat(
                        fontSize: 18, color: color2, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {
                        // dispose();
                        widget.controller.close();
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        size: 28,
                        color: color2,
                      ))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
      
              TextBox(
                controller: currPassword,
                label: "Current Password",
                hinttext: "Current Password",
                obscureText: true,
                isPassword: true,
                height: 55,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current password';
                  }
                  return null;
                },
                // icon: Icons.phone_android_rounded,
              ),
              const SizedBox(
                height: 8,
              ),
              TextBox(
                controller: newPassword,
                label: "New Password",
                hinttext: "New Password",
                obscureText: true,
                isPassword: true,
                height: 55,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              TextBox(
                controller: newPassword,
                label: "Confirm New Password",
                hinttext: "Confirm New Password",
                obscureText: true,
                isPassword: true,
                height: 55,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != newPassword.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              // const SizedBox(height: 5),
      
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    dispose();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(double.infinity, 50.0),
                ),
                child: Text('UPDATE DETAILS',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
