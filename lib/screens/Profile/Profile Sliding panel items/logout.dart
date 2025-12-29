import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/screens/Login/login.dart';
import 'package:mahavar_technician/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Logout extends StatefulWidget {
  final PanelController controller;
  const Logout({super.key, required this.controller});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  bool isLoading = false; // Add a variable to track the loading state
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Logout",
                  style: GoogleFonts.montserrat(
                      fontSize: 18, color: color2, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {
                    widget.controller.close();
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: 28,
                    color: color2,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Are you sure you want to logout of Mahavar Eurotech",
              style: GoogleFonts.montserrat(
                  fontSize: 13, color: color3, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.controller.close();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shadowColor: color3,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: color1, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(140, 50.0),
                  ),
                  child: Text('Cancel',
                      style: GoogleFonts.montserrat(
                          color: color1,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // Show the circular progress indicator
                    });

                    try {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('loginInned');
                      await prefs.remove('techanican_id');

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                      showToast(context, "Logged out successfully", 3);
                    } catch (e) {
                      print('Error during logout: $e');
                      // Optionally, show an error message to the user
                      showToast(
                          context, "Error during logout. Please try again.", 3);
                    } finally {
                      setState(() {
                        isLoading =
                            false; // Hide the circular progress indicator
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color1,
                    shadowColor: color3,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: color1, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(140, 50.0),
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
                          'Logout',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
