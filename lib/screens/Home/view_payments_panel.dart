// ignore_for_file: unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/provider/panel_provider.dart';
import 'package:mahavar_technician/screens/Home/view_transactions_list.dart';
import 'package:mahavar_technician/widgets/toast.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ViewPaymentPanel extends StatefulWidget {
  // final PanelController panelController;
  const ViewPaymentPanel({
    super.key,
    // required this.panelController,
  });

  @override
  State<ViewPaymentPanel> createState() => _ViewPaymentPanelState();
}

class _ViewPaymentPanelState extends State<ViewPaymentPanel> {
  final TextEditingController _pinController = TextEditingController();
  // final PanelController controller = PanelController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 5,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color3,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            "Enter 4 Digits Pin",
            style: TextStyle(
              color: color2,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Enter the 4 digits pin to view payments",
            style: TextStyle(
              color: color2,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 60,
          ),
          Pinput(
            length: 4,
            showCursor: true,
            controller: _pinController,
            defaultPinTheme: PinTheme(
                width: 50,
                height: 55,
                textStyle: GoogleFonts.montserrat(
                    fontSize: 22, fontWeight: FontWeight.w600),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color3, width: 1.5))),
            focusedPinTheme: PinTheme(
                width: 50,
                height: 55,
                textStyle:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color2, width: 1.5))),
            onCompleted: (pin) {
              setState(() {
                print(pin);
                _pinController.text = pin;
              });
            },
            validator: (pin) {
              if (pin!.length != 4) {
                return "Enter a valid pin";
              } else {
                return null;
              }
            },
          ),
          const SizedBox(
            height: 60,
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true; // Show the circular progress indicator
              });

              try {
                await HttpApiCall().verifyPassword(
                  context,
                  {
                    "pin": _pinController.text,
                  },
                );

                // Clear the text field after successful verification
                _pinController.text = "";
              } catch (e) {
                print("Error during password verification: $e");
                // Optionally, show an error message to the user
                showToast(
                    context, "Error verifying password. Please try again.", 3);
              } finally {
                setState(() {
                  isLoading = false; // Hide the circular progress indicator
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color1,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(40, 40),
              maximumSize: const Size(40, 40),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3.0,
                    ),
                  )
                : const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
          ),
        ],
      ),
    );
  }
}
