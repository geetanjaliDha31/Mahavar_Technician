// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/provider/mobileno_provider.dart';
import 'package:mahavar_technician/provider/panel_provider.dart';
import 'package:mahavar_technician/widgets/textfield.dart';
import 'package:mahavar_technician/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfiledetailsPage extends StatefulWidget {
  final PanelController controller;
  const ProfiledetailsPage({super.key, required this.controller});

  @override
  State<ProfiledetailsPage> createState() => _ProfiledetailsPageState();
}

class _ProfiledetailsPageState extends State<ProfiledetailsPage> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileno = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool valueCheck = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateData();
  }

  bool isLoading = false; // Add a variable to track the loading state

  @override
  void dispose() {
    // TODO: implement dispose
    firstname.dispose();
    lastname.dispose();
    email.dispose();
    mobileno.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstname.text = prefs.getString('first_name') ?? '';
      lastname.text = prefs.getString('last_name') ?? '';
      email.text = prefs.getString('email') ?? '';
      mobileno.text = prefs.getString("mobile_no") ?? '';
    });
  }

  Future<void> _saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('first_name', firstname.text);
    prefs.setString('email', email.text);
    prefs.setString('last_name', lastname.text);
    // prefs.setString('mobile', mobileno.text);
  }

  @override
  Widget build(BuildContext context) {
    // String mobileNumber = Provider.of<MobileNo>(context).mobileNumber;
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile Details",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: color2,
                        fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {
                        widget.controller.close();
                        // dispose();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextBox(
                    controller: firstname,
                    label: "First Name",
                    obscureText: false,
                    hinttext: "First Name",
                    width: 145,
                    height: 55,
                  ),
                  TextBox(
                    controller: lastname,
                    label: "Last Name",
                    hinttext: "Last Name",
                    obscureText: false,
                    width: 145,
                    height: 55,
                  ),
                ],
              ),
              //   TextBox(
              //   controller: firstname,
              //   label: "Full Name",
              //   obscureText: false,
              //   hinttext: "Full Name",
              //   height: 55,
              //   icon: Icons.person,
              // ),
              const SizedBox(
                height: 8,
              ),
              TextBox(
                controller: mobileno,
                label: "Mobile number",
                hinttext: "$mobileno",
                readOnly: true,
                obscureText: false,
                style: GoogleFonts.montserrat(
                    color: color3, fontSize: 13, fontWeight: FontWeight.w500),
                height: 55,
                isNumber: true,
                icon: Icons.phone_android_rounded,
              ),
              const SizedBox(
                height: 8,
              ),
              TextBox(
                controller: email,
                label: "Email Address",
                hinttext: "Email Address",
                obscureText: false,
                height: 55,
                validator: (value) {
                  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                      .hasMatch(value!)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                icon: Icons.mail_rounded,
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true; // Show the circular progress indicator
                    });

                    try {
                      await HttpApiCall().updateProfileDetails(
                          context, firstname.text, lastname.text, email.text);
                      _saveData();
                    } catch (e) {
                      print('Error in updating profile: $e');
                      // Optionally, show an error message to the user
                      showToast(context,
                          "Error updating profile. Please try again.", 3);
                    } finally {
                      setState(() {
                        isLoading =
                            false; // Hide the circular progress indicator
                      });
                    }
                  } else {
                    print('Error in updating profile');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(double.infinity, 55.0),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3.0,
                        ),
                      )
                    : Text(
                        'UPDATE DETAILS',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
