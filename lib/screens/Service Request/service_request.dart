// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/models/home_data.dart';
import 'package:mahavar_technician/models/view_service_details.dart';
import 'package:mahavar_technician/provider/panel_provider.dart';
import 'package:mahavar_technician/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_technician/screens/Home/count_call_card.dart';
import 'package:mahavar_technician/screens/Service%20Request/no_cancel_request.dart';
import 'package:mahavar_technician/screens/Service%20Request/no_service_page.dart';
import 'package:mahavar_technician/screens/Service%20Request/service_card.dart';
import 'package:mahavar_technician/screens/Home/view_payments_panel.dart';
import 'package:mahavar_technician/widgets/expanable_page_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ServiceRequest extends StatefulWidget {
  const ServiceRequest({
    super.key,
  });

  @override
  State<ServiceRequest> createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  @override
  void initState() {
    super.initState();
    getDropdownData();
    refreshData();
  }

  int selectedIndex = 0;
  PageController contr = PageController();
  ViewServiceDetails? serviceDetails;
  bool loading = true;

  Future refreshData() async {
    serviceDetails = await HttpApiCall().viewServiceDetails();
    setState(() {
      loading = false;
    });
  }

  bool isDataLoaded = false;
  List<dynamic> reasonList = [];
  String selectedReason = '';
  TextEditingController reason = TextEditingController();

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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(),
                ),
                (route) => false,
              );
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
            "Service Requests",
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
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                key: _refreshIndicatorKey,
                child: FutureBuilder(
                  future: HttpApiCall().viewServiceDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ViewServiceDetails temp = snapshot.data!;

                      final pendingCalls =
                          temp.resultArray![0].pendingCallsArray!;
                      final completedCalls =
                          temp.resultArray![0].completedCallsArray!;
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
                                    ? const Column(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                          ),
                                          NoServicePage(),
                                        ],
                                      )
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
                                    ? Column(
                                        children: const [
                                          SizedBox(
                                            height: 100,
                                          ),
                                          NoCancelRequest(),
                                        ],
                                      )
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
