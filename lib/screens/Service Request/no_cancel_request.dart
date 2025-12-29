import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';

class NoCancelRequest extends StatefulWidget {
  const NoCancelRequest({super.key});

  @override
  State<NoCancelRequest> createState() => _NoCancelRequestState();
}

class _NoCancelRequestState extends State<NoCancelRequest> {
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
          "No service request cancelled yet",
          style: TextStyle(
              color: color2, fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Cancel request if not needed",
          style: TextStyle(
              color: color2, fontWeight: FontWeight.w400, fontSize: 13),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
