import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({super.key});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  @override
  Widget build(BuildContext context) {
    Widget popupMenuButton() {
      return PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text(
              "Address Option 1",
              style: GoogleFonts.montserrat(
                  fontSize: 10, fontWeight: FontWeight.w400),
            ),
          ),
          PopupMenuItem(
            child: Text(
              "Address Option 2",
              style: GoogleFonts.montserrat(
                  fontSize: 10, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      );
    }

    return Material(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Address",
                  style: GoogleFonts.montserrat(
                      fontSize: 13, fontWeight: FontWeight.w600, color: color2),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "+ ADD NEW ADDRESS",
                    style: GoogleFonts.montserrat(
                        fontSize: 13, fontWeight: FontWeight.w600, color: color2),
                  ),
                )
              ],
            ),
            Container(
              height: 81,
              // color: Colors.pink,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Home",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: Text(
                        "Block C-41 Room N0.150, Shiv colony Shantinagar Ulhasnagar-3",
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          // color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: popupMenuButton(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Divider(
              color: color3,
              height: 1,
            ),
            Container(
              height: 81,
              // color: Colors.pink,
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Home",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: Text(
                        "Block C-41 Room N0.150, Shiv colony Shantinagar Ulhasnagar-3 Shantinagar Ulhasnagar-3",
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          // color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: popupMenuButton(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Divider(
              color: color3,
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
