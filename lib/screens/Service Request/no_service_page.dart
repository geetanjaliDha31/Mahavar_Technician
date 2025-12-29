import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';

class NoServicePage extends StatefulWidget {
  const NoServicePage({super.key});

  @override
  State<NoServicePage> createState() => _NoServicePageState();
}

class _NoServicePageState extends State<NoServicePage> {
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
                image: AssetImage('assets/add_machine.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 15,
        // ),
        Text(
          "No service request received yet",
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
