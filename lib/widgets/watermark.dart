import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';

class WaterMark extends StatelessWidget {
  const WaterMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Made with ',
                style: GoogleFonts.montserrat(
                    fontSize: 13, color: color3, fontWeight: FontWeight.w400),
              ),
              const Icon(
                Icons.favorite_rounded,
                color: Colors.red,
                size: 13,
              ),
              Text(
                ' for your devices',
                style: GoogleFonts.montserrat(
                    fontSize: 13, color: color3, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Text(
            'By Mahavar Eurotech',
            style: GoogleFonts.montserrat(
                fontSize: 12, color: color3, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
