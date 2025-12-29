import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';

class CountCallCardHome extends StatelessWidget {
  final Map<String, dynamic> data;
  const CountCallCardHome({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color1, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'],
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            data['count'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: data['title'] == "Today's Payment" ? green : Colors.black,
            ),
          ),
          const Spacer(),
          Text(
            data['subtitle'],
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
