// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:intl/intl.dart';

class NotificationMainCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const NotificationMainCard({super.key, required this.data});

  @override
  State<NotificationMainCard> createState() => _NotificationMainCardState();
}

class _NotificationMainCardState extends State<NotificationMainCard> {
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedCurrentDate = DateFormat('dd MMM yyyy').format(currentDate);
    bool isToday = (formattedCurrentDate == widget.data['date']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isToday ? 'Today' : widget.data['date'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ListView.builder(
          itemCount: widget.data['messageList'].length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  height: 62,
                  decoration: BoxDecoration(
                    color: color4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 7, right: 7, bottom: 3, top: 7),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: CircleAvatar(
                            child: Icon(
                              Icons.notifications_none_rounded,
                              size: 25,
                              color: color1,
                            ),
                            backgroundColor: color2.withOpacity(0.2),
                            radius: 24,
                          ),
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data['messageList'][index]['message'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: color5,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.data['messageList'][index]['time'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: color5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 6),
              ],
            );
          },
        ),
        SizedBox(height: 6),
      ],
    );
  }
}
