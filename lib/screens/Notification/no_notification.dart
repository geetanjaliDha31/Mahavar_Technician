import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';

class NoNotificationPage extends StatefulWidget {
  const NoNotificationPage({super.key});

  @override
  State<NoNotificationPage> createState() => _NoNotificationPageState();
}

class _NoNotificationPageState extends State<NoNotificationPage> {
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
                image: AssetImage('assets/notify2.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 15,
        // ),
        Text(
          "No notifications received yet",
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
