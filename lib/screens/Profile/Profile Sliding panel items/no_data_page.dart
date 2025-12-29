import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';

class NoDataPage extends StatefulWidget {
  const NoDataPage({super.key});

  @override
  State<NoDataPage> createState() => _NoDataPageState();
}

class _NoDataPageState extends State<NoDataPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 250,
            width: 250,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/No data.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 15,
        // ),
        Text(
          "No Inventory Details",
          style: TextStyle(
              color: color2, fontWeight: FontWeight.w600, fontSize: 15),
        ),

        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
