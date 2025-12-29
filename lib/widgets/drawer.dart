import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Container(
          color: color4,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                "Welcome Guest",
                style: GoogleFonts.montserrat(
                    fontSize: 14, fontWeight: FontWeight.w600, color: color2),
              ),
              const SizedBox(
                height: 15,
              ),
              Divider(
                height: 1,
                color: color3,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "MY PROFILE",
                style: GoogleFonts.montserrat(
                    fontSize: 14, fontWeight: FontWeight.w600, color: color2),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "Manage Account",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "My Orders",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "My Requests",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "Change Password",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                height: 1,
                color: color3,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "CONTACT US",
                style: GoogleFonts.montserrat(
                    fontSize: 14, fontWeight: FontWeight.w600, color: color2),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "Help & Support",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "Feedback & Suggestions",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                height: 1,
                color: color3,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "ABOUT US",
                style: GoogleFonts.montserrat(
                    fontSize: 14, fontWeight: FontWeight.w600, color: color2),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "Our Story",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "Blog",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Text(
                    "Rate the App",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                height: 1,
                color: color3,
              ),
              const SizedBox(
                height: 15,
              ),
              // InkWell(
              //   onTap: () {},
              //   child: Container(
              //     width: double.infinity,
              //     height: 40,
              //     color: Colors.white,
              //     alignment: Alignment.center,
              //     child: Text(
              //       "LOG OUT",
              //       style: GoogleFonts.montserrat(
              //           fontSize: 14,
              //           fontWeight: FontWeight.w600,
              //           color: color2),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      );
  }
}