import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Settings extends StatefulWidget {
  final PanelController controller;
  const Settings({super.key, required this.controller});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool switchValue = false;

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
                  "Settings",
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
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    "I would like to recieve service updates on whatsapp",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: color2,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Switch(
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = !switchValue;
                    });
                  },
                  thumbColor: MaterialStateProperty.all<Color>(color1),
                  inactiveThumbColor: color1,
                  inactiveTrackColor: color3,
                  trackOutlineColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  activeColor: color2,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
