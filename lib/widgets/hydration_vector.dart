import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';

class HydrationMotivation extends StatelessWidget {
  const HydrationMotivation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height,
      height: 290,
      color: color4,
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(
            'No more products to show',
            style: GoogleFonts.montserrat(
                fontSize: 13, color: color3, fontWeight: FontWeight.w600),
          ),
          Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Hydration_vector.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            'You have already reached the bottom,',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: color3,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'might be feeling thirsty; drink some water...',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: color3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
