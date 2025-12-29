// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/models/view_all_transactions.dart';
import 'package:mahavar_technician/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_technician/screens/Home/no_payment.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ViewTransactionsList extends StatefulWidget {
  const ViewTransactionsList({
    super.key,
  });

  @override
  State<ViewTransactionsList> createState() => _ViewTransactionsListState();
}

class _ViewTransactionsListState extends State<ViewTransactionsList> {
  @override
  void initState() {
    super.initState();
    _loadData();
    refreshData();
  }

  List<String> selectedData = [];
  bool isloading = true;
  ViewAllTransactions? transactions;
  String imageUrl = '';

  _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString("profile_image") ?? '';
    });
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future refreshData() async {
    transactions = await HttpApiCall().viewAllTransactions();
    setState(() {
      isloading = false;
    });
  }

  bool checker(String id) {
    for (int i = 0; i < selectedData.length; i++) {
      if (selectedData[i] == id) {
        return false;
      }
    }
    return true;
  }

  bool multi = false;

  void toggleSelection(String id) {
    setState(() {
      if (selectedData.contains(id)) {
        selectedData.remove(id);
      } else {
        selectedData.add(id);
      }
    });
  }

  Future<void>? deletePopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Delete Transaction",
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w500, color: color1),
            ),
            content: Text(
              'Are you sure you want to delete this transactions?',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color5,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: color5.withOpacity(0.8)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Delete',
                  style: GoogleFonts.montserrat(
                      fontSize: 12, fontWeight: FontWeight.w500, color: color1),
                ),
                onPressed: () {
                  print(selectedData);
                  HttpApiCall().clearTransaction(
                    context,
                    {
                      "service_id": selectedData.toString(),
                    },
                  );
                },
              ),
            ],
            contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 6),
            actionsPadding: EdgeInsets.only(bottom: 10, right: 10),
          );
        });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
          child: ElevatedButton(
            onPressed: () {
              if (multi) {
                setState(() {
                  multi = false;
                });
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const BottomNavBar(),
                  ),
                  (route) => false,
                );
              }
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
            "Transactions",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: color2,
            ),
          ),
        ),
        actions: [
          if (multi)
            IconButton(
              onPressed: () {
                deletePopup();
              },
              padding: const EdgeInsets.only(right: 25),
              icon: const Icon(
                CupertinoIcons.delete,
                size: 28,
                color: Colors.red,
              ),
            ),
        ],
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(
                color: color3,
              ),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  print('refreshed');
                  await refreshData();
                },
                key: _refreshIndicatorKey,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                child: FutureBuilder(
                  future: HttpApiCall().viewAllTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ViewAllTransactions res = snapshot.data!;
                      final list = res.resultArray!;

                      final List<Map<String, dynamic>> data = [];

                      for (int i = 0; i < list.length; i++) {
                        data.add({
                          "id": list[i].callsId.toString(),
                          'customer_name': list[i].customerName,
                          "date": "Received on ${list[i].callCloseDate}",
                          "amount": "+ ₹${list[i].paidAmount}",
                        });
                      }
                      return data.isEmpty
                          ? const NoPaymentPage()
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onLongPress: () {
                                          setState(() {
                                            multi = true;
                                          });
                                          print(selectedData);
                                        },
                                        onTap: () {
                                          if (multi) {
                                            toggleSelection(data[index]['id']);
                                          }
                                          print(selectedData);
                                        },
                                        child: Column(
                                          children: [
                                            Divider(
                                              color: color3,
                                              height: 1,
                                            ),
                                            Container(
                                              height: 70,
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 10, 15, 10),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(imageUrl),
                                                    radius: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data[index]
                                                              ['customer_name'],
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Text(
                                                          data[index]['date'],
                                                          style: TextStyle(
                                                            color: color5,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 10,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  multi
                                                      ? checker(
                                                              data[index]['id'])
                                                          ? Container(
                                                              height: 25,
                                                              width: 25,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: color4,
                                                                border:
                                                                    Border.all(
                                                                  color: color5
                                                                      .withOpacity(
                                                                          0.6),
                                                                  width: 1,
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 25,
                                                              width: 25,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: checker(
                                                                        data[index]
                                                                            [
                                                                            'id'])
                                                                    ? Colors
                                                                        .white
                                                                    : color1,
                                                                border:
                                                                    Border.all(
                                                                  color: color1,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: const Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                                size: 23,
                                                              ),
                                                            )
                                                      : Text(
                                                          data[index]['amount'],
                                                          style: TextStyle(
                                                            color: green,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(
                                    color: color3,
                                    height: 1,
                                  ),
                                  SizedBox(
                                    height: 500,
                                  )
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
