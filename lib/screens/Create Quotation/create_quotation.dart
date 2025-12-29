// ignore_for_file: unused_import, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/widgets/textfield.dart';
import 'package:mahavar_technician/widgets/toast.dart';

class CreateQuotation extends StatefulWidget {
  final Map<String, dynamic> data;
  const CreateQuotation({super.key, required this.data});

  @override
  State<CreateQuotation> createState() => _CreateQuotationState();
}

class _CreateQuotationState extends State<CreateQuotation> {
  List<dynamic> itemList = [];
  bool isDataLoaded = false;
  bool isLoading = false;
  int? selectedGstType;
  @override
  void initState() {
    super.initState();
    getData();
  }

  List<int> itemCount = [
    1,
    1,
  ];
  int quotationCount = 1;

  List<TextEditingController> itemControllers = [];
  List<TextEditingController> countControllers = [];

  List<TextEditingController> priceControllers = [];

  int totalAmount = 0;

  void addQuotation() {
    setState(() {
      quotationCount += 1;
      itemControllers.add(TextEditingController());
      countControllers.add(TextEditingController());
      priceControllers.add(TextEditingController());
      itemCount.add(1);
      print(quotationCount);
    });
  }

  void removeQuotation() {
    setState(() {
      if (quotationCount > 1) {
        int lastIndex = quotationCount - 1;

        // Subtract the price of the item being removed from the total amount
        totalAmount -= int.tryParse(priceControllers[lastIndex].text) ?? 0;

        // Dispose controllers and remove them from the lists
        itemControllers[lastIndex].dispose();
        countControllers[lastIndex].dispose();
        priceControllers[lastIndex].dispose();

        itemControllers.removeAt(lastIndex);
        countControllers.removeAt(lastIndex);
        priceControllers.removeAt(lastIndex);
        itemCount.removeAt(lastIndex);

        // Update quotation count
        quotationCount -= 1;

        // Recalculate total amount
        totalCalulate();
      } else {
        showToast(context, 'Can not remove all items', 3);
      }
    });
  }

  void removeQuotation2(int i) {
    setState(() {
      quotationCount -= 1;
      itemControllers.removeAt(i);
      countControllers.removeAt(i);
      priceControllers.removeAt(i);
      itemCount.removeAt(i);
    });
  }

  Future<void> getData() async {
    final response = await HttpApiCall().getDropdownData();

    if (response.isNotEmpty && response["result_array"].isNotEmpty) {
      print(response['result_array'][0]['parts_array']);

      // Assign the parts_array to itemList
      itemList = response['result_array'][0]['parts_array'];

      // Clear existing controllers
      itemControllers.clear();
      countControllers.clear();
      priceControllers.clear();
      itemCount.clear();

      // Check if itemList has any elements before proceeding
      if (itemList.isNotEmpty) {
        // Create controllers based on itemList length
        for (int i = 0; i < itemList.length; i++) {
          itemControllers.add(TextEditingController());
          countControllers.add(TextEditingController());
          priceControllers.add(TextEditingController());
          itemCount.add(1); // Add default values to itemCount
        }
      } else {
        // If parts_array is empty, handle appropriately (e.g., show a message)
        showToast(context, "No parts available", 3);
      }

      setState(() {
        isDataLoaded = true;
      });
    }
  }

  String findPrice(String partName) {
    for (int i = 0; i < itemList.length; i++) {
      if (itemList[i]['part_name'] == partName) {
        return itemList[i]['part_price'];
      }
    }
    return '';
  }

  String findPartId(String partName) {
    for (int i = 0; i < itemList.length; i++) {
      if (itemList[i]['part_name'] == partName) {
        return itemList[i]['parts_id'];
      }
    }
    return '';
  }

  void totalCalulate() {
    totalAmount = 0;

    // Try both the logic and see which one works '_'
    // for (int i = 0; i < quotationCount; i++) {
    //   totalAmount += int.parse(priceControllers[i].text);
    // }
    for (int i = 0; i < quotationCount; i++) {
      totalAmount +=
          int.parse(findPrice(itemControllers[i].text)) * itemCount[i];
    }
  }

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
                    "CREATE QUOTATION",
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
      body: !isDataLoaded
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data['customer_name'],
                          style: TextStyle(
                            color: color5,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
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
                                widget.data['mobile_no'],
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
                                widget.data['device'],
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
                              "Issue: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: color5,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.data['issue'],
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
                              "Address: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: color5,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.data['address'],
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
                      ],
                    ),
                  ),
                  Container(
                    height: 15,
                    color: color4,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 20, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GST:',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedGstType = 1;
                                });
                              },
                              splashColor: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: color1),
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedGstType == 1
                                            ? color1
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "With GST",
                                    style: TextStyle(
                                      color: color5,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedGstType = 2;
                                });
                              },
                              splashColor: Colors.white,
                              child: Row(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: color1),
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedGstType == 2
                                            ? color1
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Without GST",
                                    style: TextStyle(
                                      color: color5,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 15,
                    color: color4,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Quatation: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (quotationCount >= itemList.length) {
                                      showToast(
                                          context, 'Cannot add more items', 3);
                                      print('count exceed');
                                    } else {
                                      addQuotation();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color1,
                                    padding: const EdgeInsets.all(0),
                                    minimumSize: const Size(25, 25),
                                    maximumSize: const Size(25, 25),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const Text(
                                  "Add item",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.435,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 0.7),
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
                                border:
                                    Border.all(color: Colors.black, width: 0.7),
                              ),
                              child: const Text(
                                "Quantity",
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
                                border:
                                    Border.all(color: Colors.black, width: 0.7),
                              ),
                              child: const Text(
                                "Price",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int i = 0; i < quotationCount; i++)
                          Row(
                            children: [
                              DropdownMenu<dynamic>(
                                width:
                                    MediaQuery.of(context).size.width * 0.435,
                                // initialSelection: itemList[0]['part_name'],
                                hintText: 'Select Item',
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  // overflow: TextOverflow.clip,
                                ),
                                trailingIcon: Icon(
                                  CupertinoIcons.chevron_down,
                                  color: color3,
                                  size: 14,
                                ),
                                selectedTrailingIcon: Icon(
                                  CupertinoIcons.chevron_up,
                                  color: color3,
                                  size: 14,
                                ),
                                menuStyle: const MenuStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.white),
                                ),
                                inputDecorationTheme: InputDecorationTheme(
                                  constraints:
                                      const BoxConstraints(maxHeight: 55),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 0.7),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 0.7),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                                onSelected: (dynamic value) {
                                  setState(() {
                                    // partId = value!['parts_id'].toString();
                                    itemControllers[i].text = value!;
                                    int currentPrice =
                                        int.tryParse(findPrice(value)) ?? 0;
                                    totalAmount += currentPrice;
                                    priceControllers[i].text =
                                        currentPrice.toString();
                                    totalCalulate();
                                  });
                                },
                                // controller: itemControllers[i],
                                dropdownMenuEntries: itemList
                                    .map<DropdownMenuEntry<dynamic>>(
                                        (dynamic item) {
                                  return DropdownMenuEntry<dynamic>(
                                    value: item['part_name'],
                                    label: item['part_name'],
                                  );
                                }).toList(),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.23,
                                height: 55,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 0.7),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 60,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            if (itemCount[i] >= 0) {
                                              setState(() {
                                                if (itemCount[i] == 1) {
                                                  // Subtract the price of the item from totalAmount
                                                  int itemPrice = int.parse(
                                                      findPrice(
                                                          itemControllers[i]
                                                              .text));
                                                  totalAmount -= itemPrice;
                                                  itemCount[i] -= 1;
                                                  removeQuotation2(i);
                                                  totalCalulate();
                                                } else {
                                                  itemCount[i] -= 1;

                                                  int temp = int.parse(
                                                        findPrice(
                                                            itemControllers[i]
                                                                .text),
                                                      ) *
                                                      itemCount[i];

                                                  priceControllers[i].text =
                                                      temp.toString();
                                                  totalCalulate();
                                                }
                                              });
                                            }
                                          },
                                          child: Icon(
                                            CupertinoIcons.minus,
                                            color: color2,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (itemCount.isNotEmpty &&
                                        i < itemCount.length)
                                      Text(
                                        "${itemCount[i]}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 55,
                                        child: InkWell(
                                          splashColor: Colors.white,
                                          onTap: () {
                                            setState(() {
                                              if (itemControllers[i]
                                                  .text
                                                  .isNotEmpty) {
                                                itemCount[i] += 1;
                                                int temp = int.parse(findPrice(
                                                      itemControllers[i].text,
                                                    )) *
                                                    itemCount[i];
                                                priceControllers[i].text =
                                                    temp.toString();
                                                totalCalulate();
                                              } else {
                                                showToast(context,
                                                    "Please select item", 3);
                                              }
                                            });
                                          },
                                          child: Icon(
                                            Icons.add_rounded,
                                            color: color2,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                width: MediaQuery.of(context).size.width * 0.23,
                                child: TextField(
                                  readOnly: true,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: priceControllers[i],
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.7),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(0),
                                      ),
                                    ),
                                    // error: SizedBox.shrink(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.7),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                removeQuotation();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color1,
                                padding: const EdgeInsets.all(0),
                                minimumSize: const Size(25, 25),
                                maximumSize: const Size(25, 25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Icon(
                                Icons.remove_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const Text(
                              "Remove item",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 6, 10, 10),
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            padding: const EdgeInsets.only(right: 25),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.7),
                            ),
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Total Amount: ₹$totalAmount",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true; // Show the loader
                            });

                            List<Map<String, dynamic>> temp = [];

                            for (int i = 0; i < quotationCount; i++) {
                              String itemName = itemControllers[i].text;
                              int quantity = itemCount[i];
                              int price =
                                  int.tryParse(findPrice(itemName))! * quantity;
                              String partId = findPartId(itemName);

                              Map<String, dynamic> itemData = {
                                'items': itemName.toString(),
                                'quantity': quantity.toString(),
                                'price': price.toString(),
                                'id': partId.toString(),
                              };
                              temp.add(itemData);
                            }
                            String jsonData = jsonEncode(temp);
                            print(jsonData);

                            try {
                              // Call your API method here
                              await HttpApiCall().createQuotation(context, {
                                "service_id": widget.data['service_id'].toString(),
                                "quotation_details": jsonData,
                                'gst': selectedGstType.toString(),
                              });
                            } catch (e) {
                              // Handle any errors here
                              print("Error: $e");
                            } finally {
                              setState(() {
                                isLoading = false; // Hide the loader
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color1,
                            padding: const EdgeInsets.all(0),
                            minimumSize: const Size(140, 45),
                            maximumSize: const Size(140, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: color1,
                              ),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 3.0,
                                  ),
                                )
                              : const Text(
                                  "CREATE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
