import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';

class NoPaymentPage extends StatefulWidget {
  const NoPaymentPage({super.key});

  @override
  State<NoPaymentPage> createState() => _NoPaymentPageState();
}

class _NoPaymentPageState extends State<NoPaymentPage> {
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
                image: AssetImage('assets/payment.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 15,
        // ),
        Text(
          "No Transactions are done yet",
          style: TextStyle(
            color: color2,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
