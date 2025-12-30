// ignore_for_file: must_be_immutable, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
// import 'package:mahavar_technician/models/get_quotation.dart';
import 'package:mahavar_technician/models/get_used_parts_details.dart';
import 'package:mahavar_technician/models/view_closed_request.dart';

class ViewClosedRequest extends StatefulWidget {
  Map<String, dynamic> data;
  ViewClosedRequest({super.key, required this.data});

  @override
  State<ViewClosedRequest> createState() => _ViewClosedRequestState();
}

class _ViewClosedRequestState extends State<ViewClosedRequest> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  int totalAmount = 0;

  bool loadingQuotation = true;
  List<Map<String, dynamic>> billData = [];
  Future<void> getData() async {
    GetUsedParts? res = await HttpApiCall().getUsedPartsDetails(
      {
        'service_id': widget.data['service_id'],
      },
    );
    final data = res!.resultArray?[0].usedPartDetailsDetailsArray;

    for (int i = 0; i < data!.length; i++) {
      billData.add(
        {
          "item_name": data[i].partName.toString(),
          "item_count": data[i].quantity.toString(),
        },
      );
    }
    setState(() {
      loadingQuotation = false;
    });
  }

  // Future<void> getData() async {
  //   GetQuotation? res = await HttpApiCall().getQuotation(
  //     {
  //       'service_id': widget.data['service_id'],
  //     },
  //   );
  //   final data = res!.resultArray?[0].quotationDetailsArray;

  //   for (int i = 0; i < data!.length; i++) {
  //     billData.add(
  //       {
  //         "item_name": data[i].partName.toString(),
  //         "item_count": data[i].quantity.toString(),
  //         "price": data[i].price.toString(),
  //       },
  //     );
  //   }
  //   calculateAmount();
  //   setState(() {
  //     loadingQuotation = false;
  //   });
  // }

  // void calculateAmount() {
  //   for (int i = 0; i < billData.length; i++) {
  //     totalAmount += int.parse(billData[i]['price']);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 85),
        child: Container(
          height: 85,
          padding: const EdgeInsets.only(top: 25),
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 28,
                      color: color1,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "VIEW CLOSED REQUEST",
                    style: TextStyle(
                      color: color1,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
              Divider(
                color: color3,
                height: 1,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: HttpApiCall().getClosedRequestData(
          {
            'service_id': widget.data['service_id'],
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ClosedRequestData res = snapshot.data!;
            final temp = res.resultArray![0].serviceDetailsArray![0];

            Map<String, dynamic> list = {
              'customer_name': temp.customerName,
              "mobile_no": temp.customerMobileNo,
              "comment": temp.comments,
              "device": "${temp.brandName} ${temp.modelName}",
              'status': "Device Repaired"
            };
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service Details:",
                      style: TextStyle(
                        color: color5,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      list['customer_name'],
                      style: TextStyle(
                        color: color5,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mobile Number: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: color5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            list['mobile_no'],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: color5,
                              decoration: TextDecoration.none,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Comment: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: color5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            list['comment'] ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: color5,
                              decoration: TextDecoration.none,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Device: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: color5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            list['device'],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: color5,
                              decoration: TextDecoration.none,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Device Images: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: color5,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (temp.photoPhoto1 != null &&
                            temp.photoPhoto1!.length > 44)
                          Container(
                            height: 100,
                            width: 100,
                            // margin: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: color5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.network(
                                temp.photoPhoto1!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        if (temp.photoPhoto1!.length < 45)
                          Container(
                            height: 100,
                            width: 100,
                            // margin: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: color5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.asset(
                                'assets/no_image.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        if (temp.photoPhoto2 != null &&
                            temp.photoPhoto2!.length > 44)
                          Container(
                            height: 100,
                            width: 100,
                            // margin: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: color5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.network(
                                temp.photoPhoto2!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        if (temp.photoPhoto2!.length < 45)
                          Container(
                            height: 100,
                            width: 100,
                            // margin: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: color5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.asset(
                                'assets/no_image.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        if (temp.photoPhoto3 != null &&
                            temp.photoPhoto3!.length > 44)
                          Container(
                            height: 100,
                            width: 100,
                            // margin: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: color5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.network(
                                temp.photoPhoto3!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        if (temp.photoPhoto3!.length < 45)
                          Container(
                            height: 100,
                            width: 100,
                            // margin: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: color5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.asset(
                                'assets/no_image.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Customers Signature:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: color5,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if (temp.esignPath != null && temp.esignPath!.length > 44)
                      InkWell(
                        onTap: () {
                          print(temp.esignPath);
                          print(temp.esignPath!.length);
                        },
                        child: Container(
                          height: 50,
                          width: 130,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(color: color5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.network(
                            temp.esignPath!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    if (temp.esignPath!.length < 44)
                      Container(
                        height: 50,
                        width: 130,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: color5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Signature \nUnavailable',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: color3,
                              decoration: TextDecoration.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: green,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            list['status'],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: green,
                              decoration: TextDecoration.none,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    temp.stickerPhoto!.length > 81
                        ? Text(
                            "Sticker Image:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: color5,
                              decoration: TextDecoration.none,
                            ),
                          )
                        : Text(''),
                    const SizedBox(
                      height: 10,
                    ),
                    if (temp.stickerPhoto != null &&
                        temp.stickerPhoto!.length > 81)
                      Container(
                        height: 100,
                        width: 100,
                        // margin: const EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.network(
                            temp.stickerPhoto!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (billData.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Parts used for service: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: color5,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.425,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(color: color5, width: 1),
                                    top: BorderSide(color: color5, width: 1),
                                  ),
                                ),
                                child: const Text(
                                  "Items",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.23,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(color: color5, width: 1),
                                    top: BorderSide(color: color5, width: 1),
                                    right: BorderSide(color: color5, width: 1),
                                  ),
                                ),
                                child: const Text(
                                  "Quantity",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          for (int i = 0; i < billData.length; i++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.425,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: color5, width: 1),
                                      top: BorderSide(color: color5, width: 1),
                                      bottom: i == billData.length - 1
                                          ? BorderSide(color: color5, width: 1)
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      billData[i][
                                          'item_name'], // Display the selected item
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.23,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: color5, width: 1),
                                      top: BorderSide(color: color5, width: 1),
                                      right:
                                          BorderSide(color: color5, width: 1),
                                      bottom: i == billData.length - 1
                                          ? BorderSide(color: color5, width: 1)
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${billData[i]['item_count']}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    // if (billData.isNotEmpty)
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         "Quotation: ",
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 13,
                    //           color: color5,
                    //           decoration: TextDecoration.none,
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 8,
                    //       ),
                    //       Row(
                    //         children: [
                    //           Container(
                    //             width:
                    //                 MediaQuery.of(context).size.width * 0.425,
                    //             height: 50,
                    //             alignment: Alignment.center,
                    //             decoration: BoxDecoration(
                    //               border: Border(
                    //                 left: BorderSide(color: color5, width: 1),
                    //                 top: BorderSide(color: color5, width: 1),
                    //               ),
                    //             ),
                    //             child: const Text(
                    //               "Items",
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 13,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //             ),
                    //           ),
                    //           Container(
                    //             width: MediaQuery.of(context).size.width * 0.23,
                    //             height: 50,
                    //             alignment: Alignment.center,
                    //             decoration: BoxDecoration(
                    //               border: Border(
                    //                 left: BorderSide(color: color5, width: 1),
                    //                 top: BorderSide(color: color5, width: 1),
                    //               ),
                    //             ),
                    //             child: const Text(
                    //               "Quantity",
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //             ),
                    //           ),
                    //           Container(
                    //             width: MediaQuery.of(context).size.width * 0.23,
                    //             height: 50,
                    //             alignment: Alignment.center,
                    //             decoration: BoxDecoration(
                    //               border: Border(
                    //                 left: BorderSide(color: color5, width: 1),
                    //                 top: BorderSide(color: color5, width: 1),
                    //                 right: BorderSide(color: color5, width: 1),
                    //               ),
                    //             ),
                    //             child: const Text(
                    //               "Price",
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       for (int i = 0; i < billData.length; i++)
                    //         Row(
                    //           children: [
                    //             Container(
                    //               width:
                    //                   MediaQuery.of(context).size.width * 0.425,
                    //               height: 40,
                    //               decoration: BoxDecoration(
                    //                 border: Border(
                    //                   left: BorderSide(color: color5, width: 1),
                    //                   top: BorderSide(color: color5, width: 1),
                    //                   bottom: i == billData.length - 1
                    //                       ? BorderSide(color: color5, width: 1)
                    //                       : BorderSide.none,
                    //                 ),
                    //               ),
                    //               child: Center(
                    //                 child: Text(
                    //                   billData[i][
                    //                       'item_name'], // Display the selected item
                    //                   style: const TextStyle(
                    //                     fontSize: 13,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             Container(
                    //               width:
                    //                   MediaQuery.of(context).size.width * 0.23,
                    //               height: 40,
                    //               decoration: BoxDecoration(
                    //                 border: Border(
                    //                   left: BorderSide(color: color5, width: 1),
                    //                   top: BorderSide(color: color5, width: 1),
                    //                   bottom: i == billData.length - 1
                    //                       ? BorderSide(color: color5, width: 1)
                    //                       : BorderSide.none,
                    //                 ),
                    //               ),
                    //               child: Center(
                    //                 child: Text(
                    //                   "${billData[i]['item_count']}",
                    //                   style: const TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: 13,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             Container(
                    //               height: 40,
                    //               width:
                    //                   MediaQuery.of(context).size.width * 0.23,
                    //               decoration: BoxDecoration(
                    //                 border: Border(
                    //                   left: BorderSide(color: color5, width: 1),
                    //                   top: BorderSide(color: color5, width: 1),
                    //                   right:
                    //                       BorderSide(color: color5, width: 1),
                    //                   bottom: i == billData.length - 1
                    //                       ? BorderSide(color: color5, width: 1)
                    //                       : BorderSide.none,
                    //                 ),
                    //               ),
                    //               child: Center(
                    //                 child: Text(
                    //                   "${int.parse(billData[i]['price'])}",
                    //                   style: const TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: 13,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       const SizedBox(
                    //         height: 15,
                    //       ),
                    //       Container(
                    //         height: 45,
                    //         padding: const EdgeInsets.only(right: 15),
                    //         decoration: BoxDecoration(
                    //           border:
                    //               Border.all(color: Colors.black, width: 0.7),
                    //         ),
                    //         alignment: Alignment.centerRight,
                    //         child: Text(
                    //           "Total Amount: ₹$totalAmount",
                    //           style: const TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 20,
                    //       ),
                    //     ],
                    //   ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);

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
    );
  }
}
