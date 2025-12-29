// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';

class NotificationCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const NotificationCard({super.key,required this.data});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: color3,
          height: 1,
        ),
        SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              CircleAvatar(
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 28,
                  color: color1,
                ),
                backgroundColor: color2.withOpacity(0.2),
                radius: 24,
              ),
              SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                        widget.data['title'],
                        style: TextStyle(
                          fontSize: 13,
                          color: color5,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.left,
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 6,
        ),
        
      ],
    );
  }
}
