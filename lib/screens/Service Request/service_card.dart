// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/screens/View%20Closed%20Request/view_closed_request.dart';
import 'package:mahavar_technician/screens/View%20Request%20Details/view_request_details.dart';
import 'package:mahavar_technician/widgets/textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ServiceCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isClosed;
  final List<dynamic> reasonList;
  final TextEditingController reason;
  String selectedReason;

  ServiceCard({
    super.key,
    required this.data,
    required this.isClosed,
    required this.reasonList,
    required this.reason,
    required this.selectedReason,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  Color mainColor = green;
  @override
  void dispose() {
    // TODO: implement dispose
    date.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    date.text = widget.data['date'] ?? '';
  }

  TextEditingController date = TextEditingController();

  assignColor() {
    if (widget.data['priority'] == "Complaint") {
      mainColor = orange;
    } else if (widget.data['priority'] == "Urgent") {
      mainColor = red;
    } else if (widget.data['priority'] == "Service") {
      mainColor = yellow;
    } else {
      mainColor = green;
    }
  }

  Future<void>? datePopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Reschedule Request",
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w500, color: color1),
            ),
            content: SizedBox(
              height: 190,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Select reason to reschedule request',
                    style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: color3),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownMenu<dynamic>(
                    width: MediaQuery.of(context).size.width * 0.7,
                    initialSelection: widget.reasonList[0]['reason'],
                    textStyle: GoogleFonts.inter(fontSize: 13),
                    menuHeight: 290,
                    label: Text(
                      "Select Reason",
                      style: GoogleFonts.inter(color: color3, fontSize: 13),
                    ),
                    trailingIcon: Icon(
                      CupertinoIcons.chevron_down,
                      color: color3,
                      size: 20,
                    ),
                    selectedTrailingIcon: Icon(
                      CupertinoIcons.chevron_up,
                      color: color1,
                      size: 20,
                    ),
                    menuStyle: MenuStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.white,
                      ),
                      elevation: MaterialStatePropertyAll<double>(0.5),
                      side: MaterialStatePropertyAll(
                        BorderSide(
                          color: color3,
                          width: 1,
                        ),
                      ),
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      constraints: const BoxConstraints(maxHeight: 50),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: color3),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: color3),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onSelected: (dynamic value) {
                      setState(() {
                        widget.selectedReason = value!['reasons_id'].toString();
                        widget.reason.text = value!['reason'];
                      });
                    },
                    controller: widget.reason,
                    // underline: SizedBox.shrink(),
                    dropdownMenuEntries: widget.reasonList
                        .map<DropdownMenuEntry<dynamic>>((dynamic value) {
                      return DropdownMenuEntry<dynamic>(
                        value: value,
                        label: value['reason'],
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Select date',
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: color3),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextBox(
                    controller: date,
                    hinttext: " Service Date",
                    readOnly: true,
                    icon: Icons.calendar_month_outlined,
                    label: "",
                    obscureText: false,
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1999),
                          lastDate: DateTime(DateTime.now().year + 5),
                          selectableDayPredicate: (DateTime date) {
                            // Disable previous dates (highlighting)
                            return date.isAfter(
                                DateTime.now().subtract(Duration(days: 1)));
                          }).then(
                        (value) {
                          if (value != null) {
                            setState(
                              () {
                                // Format the selected date to "day month year" format
                                final formattedDate =
                                    DateFormat('dd-MM-yyyy').format(value);
                                date.text = formattedDate;
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.montserrat(
                      fontSize: 12, fontWeight: FontWeight.w500, color: color5),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  print(date.text);
                },
              ),
              TextButton(
                child: Text(
                  'Submit',
                  style: GoogleFonts.montserrat(
                      fontSize: 12, fontWeight: FontWeight.w500, color: color1),
                ),
                onPressed: () {
                  print(date.text);
                  HttpApiCall().rescheduleRequest(context, {
                    'service_id': widget.data["service_id"],
                    'reschedule_date': date.text,
                    'reason_id': widget.selectedReason,
                  });
                },
              ),
            ],
            contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 2),
            actionsPadding: EdgeInsets.only(bottom: 0, right: 10),
          );
        });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assignColor();

    return InkWell(
      onTap: () {
        if (widget.isClosed) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewClosedRequest(data: widget.data),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewRequestDetails(data: widget.data),
            ),
          );
        }
      },
      child: Column(
        children: [
          Divider(
            color: color3,
            height: 1,
          ),
          SizedBox(
            height: 150,
            child: Row(
              children: [
                Container(
                  height: 150,
                  width: 25,
                  color: mainColor,
                ),
                Expanded(
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.data['customer_name'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (!widget.isClosed)
                                PopupMenuButton<int>(
                                  iconSize: 20,
                                  padding: const EdgeInsets.all(0),
                                  onSelected: (item) {
                                    if (item == 0) {
                                      // _saveData();
                                      print(date.text);
                                      datePopup();
                                    } else if (item == 1) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewRequestDetails(
                                            data: widget.data,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem<int>(
                                      value: 0,
                                      child: Text('Reschedule'),
                                    ),
                                    const PopupMenuItem<int>(
                                      value: 1,
                                      child: Text('Close Request'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Device: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: widget.data['device_name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Issue: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: widget.data['issue'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Priority: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: mainColor),
                              ),
                              TextSpan(
                                text: widget.data['priority'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: mainColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Service Date & Time : ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: "${widget.data['date']}"
                                    "  "
                                    "${widget.data['service_time']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
