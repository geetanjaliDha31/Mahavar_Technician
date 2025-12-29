// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/models/get_customer_address.dart';
import 'package:mahavar_technician/widgets/textfield.dart';
import 'package:mahavar_technician/widgets/toast.dart';

class UpdateAddress extends StatefulWidget {
  Map<String, dynamic> data;
  UpdateAddress({super.key, required this.data});

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  TextEditingController pincode = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController addressType = TextEditingController();
  bool isDataLoaded = false;
  GetCustomerAddress? getAdd;
  int selectedAddressType = 0;
  List<String> addressTypeList = [
    "Home",
    "Office",
    "Other",
  ];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    loadData().whenComplete(() => getPrefilledData());
    setState(() {
      isDataLoaded = true;
    });
  }

  Future loadData() async {
    getAdd = await HttpApiCall().getCustomerAddress({
      "service_id": widget.data['service_id'],
    });
  }

  Future<void> getPrefilledData() async {
    setState(() {
      pincode.text = getAdd!.resultArray![0].pincode ?? '';
      area.text = getAdd!.resultArray![0].city ?? '';
      address.text = getAdd!.resultArray![0].houseNo ?? '';
      landmark.text = getAdd!.resultArray![0].streetName ?? '';
      addressType.text = getAdd!.resultArray![0].addressType ?? '';
    });
  }

  bool validateAndSubmitDetails() {
    List<String> missingFields = [];
    String errorMessage = "";

    if (address.text.isEmpty) {
      missingFields.add("House No, Building Name, Street Name");
    }

    if (pincode.text.isEmpty) {
      missingFields.add("Pincode");
    }

    if (area.text.isEmpty) {
      missingFields.add("Area");
    }
    if (missingFields.length > 1) {
      errorMessage = "All Fields are required";
    } else if (missingFields.length == 1) {
      errorMessage = "Please Enter ${missingFields[0]}";
    }

    if (missingFields.isNotEmpty) {
      showToast(context, errorMessage, 5);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: color4,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color: color1,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Update Service Address",
            style: GoogleFonts.montserrat(
                fontSize: 13, fontWeight: FontWeight.w500, color: color1),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "House No., Building Name, Street Name",
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "*",
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: red,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                TextBox(
                  controller: address,
                  hinttext: "House No., Building Name, Street Name",
                  labelSize: 13,
                  label: "",
                  inputType: true,
                  textInputType: TextInputType.multiline,
                  maxLines: 4,
                  obscureText: false,
                  height: 60,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextBox(
              controller: landmark,
              hinttext: "Landmark",
              labelSize: 13,
              label: "Landmark",
              obscureText: false,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Pincode",
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "*",
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextBox(
                      controller: pincode,
                      hinttext: "Pincode",
                      labelSize: 13,
                      label: "",
                      obscureText: false,
                      isNumber: true,
                      width: MediaQuery.of(context).size.width * 0.43,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Area",
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "*",
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextBox(
                      controller: area,
                      hinttext: "Area",
                      labelSize: 13,
                      label: "",
                      obscureText: false,
                      isNumber: true,
                      width: MediaQuery.of(context).size.width * 0.43,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Set address as:    ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                for (int i = 0; i < addressTypeList.length; i++)
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedAddressType = i;
                        addressType.text = addressTypeList[i];
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 60,
                      margin: const EdgeInsets.only(right: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedAddressType == i ? color2 : Colors.white,
                        border: Border.all(
                          color: color2,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        addressTypeList[i],
                        style: TextStyle(
                          color:
                              selectedAddressType == i ? Colors.white : color2,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    pincode.clear();
                    area.clear();
                    address.clear();
                    landmark.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.38, 45),
                    maximumSize:
                        Size(MediaQuery.of(context).size.width * 0.38, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: color2,
                      ),
                    ),
                  ),
                  child: Text(
                    "DISCARD",
                    style: TextStyle(
                      color: color1,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    // if (validateAndSubmitDetails()) {
                    //   HttpApiCall().updateAddress(context, {
                    //     'service_id': widget.data['service_id'],
                    //     'pincode': pincode.text,
                    //     'area': area.text,
                    //     'address_line_1': address.text,
                    //     'address_type': addressType.text,
                    //     'landmark': landmark.text,
                    //   });
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color2,
                    padding: const EdgeInsets.all(0),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.38, 45),
                    maximumSize:
                        Size(MediaQuery.of(context).size.width * 0.38, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: color2,
                      ),
                    ),
                  ),
                  child: const Text(
                    "SAVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
