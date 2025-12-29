// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/models/home_data.dart';
import 'package:mahavar_technician/provider/panel_provider.dart';
import 'package:mahavar_technician/screens/Home/count_call_card.dart';
import 'package:mahavar_technician/screens/Notification/notification.dart';
import 'package:mahavar_technician/screens/Service%20Request/no_cancel_request.dart';
import 'package:mahavar_technician/screens/Service%20Request/no_service_page.dart';
import 'package:mahavar_technician/screens/Service%20Request/service_card.dart';
import 'package:mahavar_technician/screens/Home/view_payments_panel.dart';
import 'package:mahavar_technician/widgets/expanable_page_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:mahavar_technician/widgets/textfield.dart';

class HomePage extends StatefulWidget {
  final PanelController controller;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomePage(
      {super.key, required this.controller, required this.scaffoldKey});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController contr = PageController();

  int selectedIndex = 0;
  String imageUrl = '';
  @override
  void initState() {
    super.initState();
    getDropdownData();
    _loadData();
    refreshData();
  }

  bool loading = true;
  bool datesSelected = false;

  _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString("profile_image") ?? '';
    });
  }

  void handleDateSelection() {
    if (startDate.text.isNotEmpty && endDate.text.isNotEmpty) {
      // Both start and end dates are selected
      setState(() {
        datesSelected = true;
      });
    } else {
      // Dates are not selected
      setState(() {
        datesSelected = false;
      });
    }
  }

  bool isDataLoaded = false;
  List<dynamic> reasonList = [];
  String selectedReason = '';
  TextEditingController reason = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  void getDropdownData() async {
    final response = await HttpApiCall().getDropdownData();
    if (response.isNotEmpty && response["result_array"].isNotEmpty) {
      print(response['result_array'][0]['reasons_array']);
      reasonList = response['result_array'][0]['reasons_array'];
      setState(() {
        isDataLoaded = true;
      });
    }
  }

  HomeData? homeData;

  Future refreshData() async {
    startDate.text = '';
    endDate.text = '';
    homeData = await HttpApiCall().getHomeData({});
    setState(() {
      loading = false;
    });
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: const DrawerWidget(),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: Container(
          height: 60,
          alignment: Alignment.bottomCenter,
          padding:
              const EdgeInsets.only(bottom: 7, right: 10, left: 10, top: 4),
          decoration: BoxDecoration(
            color: color1,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<PanelProvider>().openPanel(ViewPaymentPanel(),
                      MediaQuery.of(context).size.height * 0.6);
                  widget.controller.open();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color1,
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                      color: Colors.white,
                      width: 1.2,
                    ),
                  ),
                  minimumSize: const Size(120, 40),
                  maximumSize: const Size(120, 40),
                ),
                child: const Text(
                  "View Payment's",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(
                width: 124,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    size: 22,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    );
                  },
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: !isDataLoaded && loading
          ? Center(
              child: CircularProgressIndicator(
                color: color3,
              ),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await refreshData();
                },
                key: _refreshIndicatorKey,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                child: FutureBuilder(
                  future: datesSelected
                      ? HttpApiCall().getHomeData({
                          'start_date': startDate.text,
                          'end_date': endDate.text,
                        })
                      : Future.value(homeData),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      HomeData temp = snapshot.data!;
                      final data = temp.resultArray![0];

                      final statData = data.techanicanStatArray?[0];
                      final pendingCalls = data.pendingCallsArray!;
                      final completedCalls = data.completedCallsArray!;

                      List<Map<String, dynamic>> countCall = [
                        {
                          'title': "Total Calls",
                          'count': statData?.totalCalls.toString(),
                          "subtitle": "Calls up to now",
                        },
                        {
                          'title': "Total Repeat Calls",
                          'count': statData?.repeatCalls.toString(),
                          "subtitle": "Calls up to now",
                        },
                        {
                          'title': "Total AMC & Installations",
                          'count': statData?.amcCalls.toString(),
                          "subtitle": "Up to now",
                        },
                        {
                          'title': "Open Calls",
                          'count': statData?.todaysPendingCalls.toString(),
                          "subtitle": "Calls pending",
                        },
                        {
                          'title': "Closed Calls",
                          'count': statData?.todaysClosedCalls.toString(),
                          "subtitle": "Calls closed",
                        },
                        {
                          'title': "Payment",
                          'count': statData?.todaysPayment.toString(),
                          "subtitle": "Recieved",
                        },
                      ];

                      List<Map<String, dynamic>> pendingServiceList = [];

                      for (int i = 0; i < pendingCalls.length; i++) {
                        pendingServiceList.add({
                          'service_id': pendingCalls[i].serviceId.toString(),
                          'customer_name': pendingCalls[i].customerName,
                          "device_name":
                              "${pendingCalls[i].brandName!} ${pendingCalls[i].modelName!}",
                          "issue": pendingCalls[i].issueName,
                          "priority": pendingCalls[i].priorityName,
                          "date": pendingCalls[i].serviceDate,
                          'service_time': pendingCalls[i].serviceTime,
                        });
                      }
                      List<Map<String, dynamic>> serviceCompletedList = [];

                      for (int i = 0; i < completedCalls.length; i++) {
                        serviceCompletedList.add({
                          'service_id': completedCalls[i].serviceId.toString(),
                          'customer_name': completedCalls[i].customerName,
                          "device_name": completedCalls[i].brandName! +
                              completedCalls[i].modelName!,
                          "issue": completedCalls[i].issueName,
                          "priority": completedCalls[i].priorityName,
                          "date": completedCalls[i].serviceDate,
                          'service_time': completedCalls[i].serviceTime,
                        });
                      }

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                print(startDate.text);
                                print(endDate.text);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: const Text(
                                  "Filter total calls: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextBox(
                                  controller: startDate,
                                  hinttext: " Start Date",
                                  readOnly: true,
                                  width: 160,
                                  icon: Icons.calendar_month_outlined,
                                  label: "",
                                  obscureText: false,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1999),
                                      lastDate:
                                          DateTime(DateTime.now().year + 5),
                                    ).then(
                                      (value) {
                                        if (value != null) {
                                          setState(() {
                                            // Format the selected date to "day month year" format
                                            final formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(value);
                                            startDate.text = formattedDate;
                                            handleDateSelection();
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                                TextBox(
                                  controller: endDate,
                                  hinttext: " End Date",
                                  width: 160,
                                  readOnly: true,
                                  icon: Icons.calendar_month_outlined,
                                  label: "",
                                  obscureText: false,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1999),
                                      lastDate:
                                          DateTime(DateTime.now().year + 5),
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          // Format the selected date to "day month year" format
                                          final formattedDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(value);
                                          endDate.text = formattedDate;
                                          handleDateSelection();
                                        });
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 15, left: 15),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 7,
                                  crossAxisSpacing: 7,
                                  childAspectRatio: 1,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: countCall.length,
                                itemBuilder: (context, index) {
                                  return CountCallCardHome(
                                      data: countCall[index]);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 15,
                              color: color4,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "My Services",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 29,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 0;
                                        contr.jumpToPage(0);
                                      });
                                    },
                                    splashColor: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Pending",
                                          style: TextStyle(
                                            color: selectedIndex == 0
                                                ? color1
                                                : color3,
                                            fontSize: 14,
                                            fontWeight: selectedIndex == 0
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          height: 5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 0
                                                ? color1
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(19),
                                              topRight: Radius.circular(19),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = 1;
                                        contr.jumpToPage(1);
                                      });
                                    },
                                    splashColor: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Completed",
                                          style: TextStyle(
                                            color: selectedIndex == 1
                                                ? color1
                                                : color3,
                                            fontSize: 14,
                                            fontWeight: selectedIndex == 1
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 1
                                                ? color1
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(19),
                                              topRight: Radius.circular(19),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ExpandablePageView(
                              controller: contr,
                              onPageChanged: (value) {
                                setState(() {
                                  selectedIndex = value;
                                });
                              },
                              children: [
                                pendingServiceList.isEmpty
                                    ? NoServicePage()
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: pendingServiceList.length,
                                        itemBuilder: (context, index) {
                                          return ServiceCard(
                                            data: pendingServiceList[index],
                                            isClosed: selectedIndex == 1,
                                            reasonList: reasonList,
                                            reason: reason,
                                            selectedReason: selectedReason,
                                          );
                                        },
                                      ),
                                serviceCompletedList.isEmpty
                                    ? NoCancelRequest()
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: serviceCompletedList.length,
                                        itemBuilder: (context, index) {
                                          return ServiceCard(
                                            data: serviceCompletedList[index],
                                            isClosed: selectedIndex == 1,
                                            reasonList: reasonList,
                                            reason: reason,
                                            selectedReason: selectedReason,
                                          );
                                        },
                                      ),
                              ],
                            ),
                          ],
                        ),
                      );
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
            ),
    );
  }
}
