// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/models/get_inventory_list.dart';
import 'package:mahavar_technician/screens/Profile/Profile%20Sliding%20panel%20items/no_data_page.dart';

class PartsInventory extends StatefulWidget {
  const PartsInventory({super.key});

  @override
  State<PartsInventory> createState() => _PartsInventoryState();
}

class _PartsInventoryState extends State<PartsInventory> {
  List<Map<String, dynamic>> inventory = [
    {
      'parts': 'HydroPurify Ultrafiltration Membrane Module',
      'qty': '8',
    },
    {
      'parts': 'ClearFlow Contaminant Removal Cartridge System',
      'qty': '5',
    },
    {
      'parts': 'AquaFlex Adjustable Flow Rate Valve Assembly',
      'qty': '2',
    },
  ];

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
                    width: 18,
                  ),
                  Text(
                    "PARTS INVENTORY",
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
                height: 6,
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: HttpApiCall().getInventoryList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            GetInventoryList inventory = snapshot.data!;
            if (inventory.resultArray != null &&
                inventory.resultArray!.isNotEmpty) {
              final data = inventory.resultArray![0].inventoryDetailsArray!;

              List<Map<String, dynamic>> inventoryList = [];
              for (int i = 0; i < data.length; i++) {
                inventoryList.add(
                  {
                    'parts': data[i].partName,
                    'qty': data[i].qty.toString(),
                  },
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PARTS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'QTY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: inventoryList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/parts_in.svg',
                                  height: 32,
                                  width: 32,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    inventoryList[index]['parts'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Container(
                                  height: 26,
                                  width: 26,
                                  decoration: BoxDecoration(
                                    color: color2.withOpacity(0.26),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Center(
                                      child: Text(
                                        inventoryList[index]['qty'],
                                        style: TextStyle(
                                          color: color2.withOpacity(0.92),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Divider(
                              color: color3.withOpacity(0.6),
                            )
                          ],
                        );
                      },
                    )
                  ],
                ),
              );
            } else {
              return NoDataPage();
            }
          } else if (snapshot.hasError) {
            return const Text('No internet connection');
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
