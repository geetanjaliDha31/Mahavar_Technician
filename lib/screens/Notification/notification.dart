// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, avoid_function_literals_in_foreach_calls, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/models/get_notification.dart';
import 'package:mahavar_technician/screens/Notification/no_notification.dart';
import 'package:mahavar_technician/screens/Notification/notification_main_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  
  Future<void> deleteAllNotifications() async {
    List<dynamic> notificationIds = [];
    GetNotification? getnotification = await HttpApiCall().getNotification();
    if (getnotification!.resultArray != null &&
        getnotification.resultArray!.isNotEmpty) {
      getnotification.resultArray!.forEach((notification) {
        notification.timeline?.forEach((timelineItem) {
          notificationIds.add(timelineItem.notificationId);
        });
      });
    }
    await HttpApiCall().deleteNotification(context, notificationIds);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await deleteAllNotifications();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
            child: ElevatedButton(
              onPressed: () async {
                await deleteAllNotifications();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color1,
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(40, 40),
                maximumSize: const Size(40, 40),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              "Notifications",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.5,
                color: color2,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: HttpApiCall().getNotification(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              GetNotification getnotification = snapshot.data!;
              if (getnotification.resultArray!.isNotEmpty &&
                  getnotification.resultArray != null) {
                final notification = getnotification.resultArray!;
                List<Map<String, dynamic>> data = [];
                for (int i = 0; i < notification.length; i++) {
                  List<Map<String, dynamic>> messageList = [];
                  for (int j = 0; j < notification[i].timeline!.length; j++) {
                    messageList.add(
                      {
                        'message': notification[i].timeline![j].message,
                        'time': notification[i].timeline![j].time,
                        'notification_id': notification[i]
                            .timeline![j]
                            .notificationId
                            .toString(),
                      },
                    );
                  }
                  data.add(
                    {
                      'date': notification[i].date,
                      'messageList': messageList,
                    },
                  );
                }
                return SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          itemCount: data.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return NotificationMainCard(
                              data: data[index],
                            );
                          },
                        ),
                        SizedBox(height: 6),
                      ],
                    ),
                  ),
                );
              } else {
                return NoNotificationPage();
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('No Internet Connection'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
