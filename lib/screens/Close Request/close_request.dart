// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, non_constant_identifier_names, sized_box_for_whitespace, unused_import

import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/image_helper.dart';
import 'package:mahavar_technician/models/close_request_final.dart';
import 'package:mahavar_technician/models/get_amc_details.dart';
import 'package:mahavar_technician/widgets/textfield.dart';
import 'package:mahavar_technician/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:url_launcher/url_launcher.dart';

class CloseRequest extends StatefulWidget {
  final Map<String, dynamic> data;
  final String userId;
  final String lat;
  final String lng;
  final String addressId;
  const CloseRequest({
    super.key,
    required this.data,
    required this.userId,
    required this.lat,
    required this.lng,
    required this.addressId,
  });

  @override
  State<CloseRequest> createState() => _CloseRequestState();
}

class _CloseRequestState extends State<CloseRequest> {
  final ImageHelper _imageHelper = ImageHelper();
  List<dynamic> itemList = [];
  bool isDataLoaded = false;
  TextEditingController totalAmount = TextEditingController();
  TextEditingController partialAmount = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController year = TextEditingController();
  String selectedYear = '';
  int? selectedGstType;
  // String? lat;
  // String? lng;
  // String? addressId;

  @override
  void initState() {
    super.initState();
    getData();
    getDropdownData();
    _fetchServiceDetails();
  }

  CameraPosition? defaultLocation;
  String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
  double? apiLatitude;
  double? apiLongitude;
  bool isLoading = false;
  final Set<Marker> marker = {};

  GoogleMapController? mapController;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Position? currentPosition;
  void _fetchServiceDetails() async {
    final response = await HttpApiCall().getServiceDetailsbyID({
      'service_id': widget.data['service_id'],
    });

    if (response != null &&
        response.resultArray != null &&
        response.resultArray!.isNotEmpty) {
      final temp = response.resultArray![0].serviceDetailsArray![0];
      if (temp.latitude != null && temp.longitude != null) {
        final lat = double.tryParse(temp.latitude!);
        final lng = double.tryParse(temp.longitude!);

        setState(() {
          apiLatitude = lat;
          apiLongitude = lng;

          defaultLocation = CameraPosition(
            target: LatLng(lat ?? 19.104839, lng ?? 72.872437),
            zoom: 18,
          );
          marker.add(
            Marker(
              markerId: MarkerId('defaultLocation'),
              position: LatLng(lat ?? 19.104839, lng ?? 72.872437),
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
        });
      }
    }
  }

  void _launchGoogleMaps() async {
    if (apiLatitude != null && apiLongitude != null) {
      // final url =
      //     'https://www.google.com/maps/search/?api=1&query=$apiLatitude,$apiLongitude';
      final response = await HttpApiCall().getServiceDetailsbyID({
        'service_id': widget.data['service_id'],
      });

      if (response != null &&
          response.resultArray != null &&
          response.resultArray!.isNotEmpty) {
        final temp = response.resultArray![0].serviceDetailsArray![0];

        final url = temp.mapUrl;
        final Uri uri = Uri.parse(url ?? "");
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not launch $url';
        }
      } else {
        throw 'Latitude and Longitude not available';
      }
    }
  }

  List<File?> images = [
    null,
    null,
    null,
  ];
  List<String?> base64List = [
    "",
    "",
    "",
  ];

  int? selectedPaymentType;
  int? selectedPaymentMode;
  int? selectedCallType;
  int? selectedRating;
  List<int> itemCount = [
    0,
    0,
  ];
  int quotationCount = 1;

  List<TextEditingController> itemControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  List<TextEditingController> countControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  void addQuotation() {
    setState(() {
      quotationCount += 1;
      itemControllers.add(TextEditingController());
      countControllers.add(TextEditingController());
      itemCount.add(0);
      print(quotationCount);
    });
  }

  void removeQuotation2() {
    setState(() {
      if (quotationCount > 1) {
        int lastIndex = quotationCount - 1;

        // Subtract the price of the item being removed from the total amount

        // Dispose controllers and remove them from the lists
        itemControllers[lastIndex].dispose();
        countControllers[lastIndex].dispose();

        itemControllers.removeAt(lastIndex);
        countControllers.removeAt(lastIndex);
        itemCount.removeAt(lastIndex);

        // Update quotation count
        quotationCount -= 1;
      } else {
        showToast(context, 'Can not remove all items', 3);
      }
    });
  }

  void removeQuotation(int i) {
    setState(() {
      quotationCount -= 1;
      itemControllers.removeAt(i);
      countControllers.removeAt(i);
      itemCount.removeAt(i);
    });
  }

  Future<void> getData() async {
    final response = await HttpApiCall().getDropdownData();
    if (response.isNotEmpty && response["result_array"].isNotEmpty) {
      print(response['result_array'][0]['parts_array']);
      itemList = response['result_array'][0]['parts_array'];
      setState(() {
        isDataLoaded = true;
      });
      // Clear existing controllers
      itemControllers.clear();
      countControllers.clear();
      itemCount.clear();

      // Create controllers based on itemList length
      for (int i = 0; i < itemList.length; i++) {
        itemControllers.add(TextEditingController());
        countControllers.add(TextEditingController());
        itemCount.add(0);
      }
    }
  }

  String findPartId(String partName) {
    for (int i = 0; i < itemList.length; i++) {
      if (itemList[i]['part_name'] == partName) {
        return itemList[i]['parts_id'];
      }
    }
    return '';
  }

  File? image;

  String? image_Base64;
  void convertImage2() {
    List<int> imageBytes = File(image!.path).readAsBytesSync();
    image_Base64 = base64Encode(imageBytes);
  }

  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  TextEditingController comment = TextEditingController();
  Uint8List? _image;
  bool isConfirmed = false;
  List<dynamic> yearList = [];
  String? imageBase64;
  void convertImage(File image, int i) {
    List<int> imageBytes = File(image.path).readAsBytesSync();
    base64List[i] = base64Encode(imageBytes);
  }

  Future<void> getDropdownData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      yearList = [
        {'year_id': 1, 'year': '1 year'},
        {'year_id': 2, 'year': '2 years'},
        {'year_id': 3, 'year': '3 years'},
        {"year_id": 4, "year": "4 years"},
        {"year_id": 5, "year": "5 years"},
      ];
    });
  }

  bool validateAndSubmitDetails() {
    List<String> missingFields = [];
    String errorMessage = "";

    if (selectedCallType == 1) {
      if (totalAmount.text.isEmpty) {
        missingFields.add("Total Amount");
      }
    }

    if (selectedPaymentType == 0) {
      if (partialAmount.text.isEmpty) {
        missingFields.add("Partial Amount");
      }
    }

    if (comment.text.isEmpty) {
      missingFields.add("Comment");
    }

    if (imageBase64 == null) {
      missingFields.add("Save Signature");
    }

    int temp = 0;
    for (int i = 0; i < base64List.length; i++) {
      if (base64List[i] != "") {
        temp++;
      }
    }
    if (temp == 0) {
      missingFields.add("submit atleast 1 Image");
    } else if (missingFields.length == 1) {
      errorMessage = "Please add ${missingFields.join(",")}";
    } else if (missingFields.length > 1) {
      errorMessage = "Please add all fields";
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
                    "CLOSE REQUEST",
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
          : FutureBuilder(
              future: HttpApiCall().getAmcDetails(
                {
                  'service_id': widget.data['service_id'],
                },
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  GetAmcDetails getAmcDetails = snapshot.data!;
                  final data = getAmcDetails.resultArray![0];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Customer Details:",
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
                                      widget.data['comment'],
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
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          color: color4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Parts used for service: ",
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
                                          if (quotationCount >=
                                              itemList.length) {
                                            showToast(context,
                                                'Cannot add more items', 3);
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.495,
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 0.7),
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
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 0.7),
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
                                ],
                              ),
                              for (int i = 0; i < quotationCount; i++)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DropdownMenu<dynamic>(
                                      width: MediaQuery.of(context).size.width *
                                          0.495,
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
                                            MaterialStatePropertyAll(
                                                Colors.white),
                                      ),
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        constraints:
                                            const BoxConstraints(maxHeight: 55),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 0.7),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 0.7),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                      onSelected: (dynamic value) {
                                        setState(() {
                                          // partId = value!['parts_id'].toString();
                                          itemControllers[i].text = value!;
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
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 0.7),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 60,
                                              child: InkWell(
                                                splashColor: Colors.white,
                                                onTap: () {
                                                  if (itemCount[i] >= 0 &&
                                                      itemControllers[i]
                                                          .text
                                                          .isNotEmpty) {
                                                    setState(() {
                                                      if (itemCount[i] == 1) {
                                                        itemCount[i] -= 1;
                                                        removeQuotation(i);
                                                      } else {
                                                        itemCount[i] -= 1;
                                                      }
                                                    });
                                                  } else {
                                                    showToast(
                                                        context,
                                                        "Please select item",
                                                        3);
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
                                                    itemCount[i] += 1;
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
                                  ],
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      removeQuotation2();
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
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          color: color4,
                        ),

                        Column(
                          children: [
                            data.amcStatus == 1
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "AMC Active: ",
                                              style: TextStyle(
                                                color: green,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${data.amcStartDate} to ${data.amcEndDate}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "AMC Inactive: ",
                                          style: TextStyle(
                                            color: red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          "Call Type: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 13,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedCallType = 0;
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
                                                  border:
                                                      Border.all(color: color1),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: selectedCallType == 0
                                                        ? color1
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                "AMC",
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
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedCallType = 1;
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
                                                  border:
                                                      Border.all(color: color1),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: selectedCallType == 1
                                                        ? color1
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                "One Time Repair",
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
                                  ),
                          ],
                        ),

                        Container(
                          height: 20,
                          color: color4,
                        ),
                        selectedCallType == 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "AMC Period: ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextBox(
                                      controller: startDate,
                                      hinttext: " Start Date",
                                      readOnly: true,
                                      icon: Icons.calendar_month_outlined,
                                      width: MediaQuery.of(context).size.width *
                                          0.86,
                                      label: "",
                                      obscureText: false,
                                      onTap: () {
                                        print(selectedYear);
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1999),
                                            lastDate: DateTime(
                                                DateTime.now().year + 5),
                                            selectableDayPredicate:
                                                (DateTime date) {
                                              // Disable previous dates (highlighting)
                                              return date.isAfter(DateTime.now()
                                                  .subtract(Duration(days: 1)));
                                            }).then(
                                          (value) {
                                            if (value != null) {
                                              setState(
                                                () {
                                                  // Format the selected date to "day month year" format
                                                  final formattedDate =
                                                      DateFormat('dd-MM-yyyy')
                                                          .format(value);
                                                  startDate.text =
                                                      formattedDate;
                                                },
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    DropdownMenu<dynamic>(
                                      width: MediaQuery.of(context).size.width *
                                          0.86,
                                      initialSelection: yearList[0]['year'],
                                      textStyle:
                                          GoogleFonts.inter(fontSize: 13),
                                      menuHeight: 250,
                                      label: Text(
                                        "Select Year",
                                        style: GoogleFonts.inter(
                                            color: color3, fontSize: 13),
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
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          Colors.white,
                                        ),
                                        elevation:
                                            MaterialStatePropertyAll<double>(
                                                0.5),
                                        side: MaterialStatePropertyAll(
                                          BorderSide(
                                            color: color3,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        constraints:
                                            const BoxConstraints(maxHeight: 50),
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
                                          selectedYear =
                                              value!['year_id'].toString();
                                          year.text = value!['year'];
                                        });
                                      },
                                      controller: year,
                                      // underline: SizedBox.shrink(),
                                      dropdownMenuEntries: yearList
                                          .map<DropdownMenuEntry<dynamic>>(
                                              (dynamic value) {
                                        return DropdownMenuEntry<dynamic>(
                                          value: value,
                                          label: value['year'],
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        Container(
                          height: 20,
                          color: color4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Comment: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              TextBox(
                                controller: comment,
                                hinttext: "Comment",
                                label: "",
                                obscureText: false,
                                textInputType: TextInputType.multiline,
                                height: 120,
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          color: color4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // const SizedBox(
                                  //   width: 5,
                                  // ),
                                  const Icon(
                                    Icons.cloud_upload_rounded,
                                    color: Color(0xFFE8A22E),
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Please upload Sticker Image File",
                                          style: TextStyle(
                                            color: color5,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Choose file .jpg, .jpeg, .png not more than 10MB",
                                          style: TextStyle(
                                            color: color5,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final file =
                                          await _imageHelper.getImage();
                                      if (file != null) {
                                        final cropped =
                                            await _imageHelper.crop(file);
                                        if (cropped != null) {
                                          setState(() {
                                            image = cropped;
                                          });
                                          convertImage2();
                                        }
                                      }
                                    },
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      color: color5,
                                      dashPattern: const [6, 6],
                                      // padding: const EdgeInsets.all(5),
                                      child: image == null
                                          ? Container(
                                              height: 95,
                                              width: 95,
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.cloud_upload_rounded,
                                                    color: color5,
                                                    size: 28,
                                                  ),
                                                  Text(
                                                    "Upload",
                                                    style: TextStyle(
                                                      color: color5,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              height: 115,
                                              width: 115,
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: FileImage(image!),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          color: color4,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Google Rating & Reviews: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedRating = 1;
                                        });
                                        print(selectedRating);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedRating == 1
                                            ? color1
                                            : color4,
                                        padding: const EdgeInsets.all(0),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                            45),
                                        maximumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                            45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                            color: color1,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "YES",
                                        style: TextStyle(
                                          color: selectedRating == 1
                                              ? Colors.white
                                              : color1,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedRating = 0;
                                        });
                                        print(selectedRating);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedRating == 0
                                            ? color1
                                            : color4,
                                        padding: const EdgeInsets.all(0),
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                            45),
                                        maximumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.38,
                                            45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                            color: color1,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "NO",
                                        style: TextStyle(
                                          color: selectedRating == 0
                                              ? Colors.white
                                              : color1,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          color: color4,
                        ),

                        Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: const Icon(
                                Icons.cloud_upload,
                                color: Color(0xFFE8A22E),
                                size: 28,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15),
                                  Text(
                                    "Please upload Device Images",
                                    style: TextStyle(
                                      color: color5,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "Choose file .jpg, .jpeg, .png file not more than 10MB",
                                    style: TextStyle(
                                      color: color5,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < 3; i++)
                              InkWell(
                                onTap: () async {
                                  final file = await _imageHelper.getImage();
                                  if (file != null) {
                                    final cropped =
                                        await _imageHelper.crop(file);
                                    if (cropped != null) {
                                      setState(() {
                                        images[i] = cropped;
                                      });
                                      convertImage(cropped, i);
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(5),
                                      strokeWidth: 0.8,
                                      dashPattern: const [7, 7],
                                      color: color5,
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(3),
                                        child: images[i] == null
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.cloud_upload_rounded,
                                                    color: color5,
                                                    size: 25,
                                                  ),
                                                  Text(
                                                    "Upload",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: color5,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image:
                                                        FileImage(images[i]!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        // if (selectedCallType == 1)
                        Container(
                          height: 15,
                          color: color4,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "GST: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
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
                                height: 10,
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
                        ),
                        // Container(
                        //   height: 20,
                        //   color: color4,
                        // ),
                        Column(
                          children: [
                            Container(
                              height: 20,
                              color: color4,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Payment Type: ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPaymentType = 1;
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
                                              color: selectedPaymentType == 1
                                                  ? color1
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "Full Payment",
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
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPaymentType = 0;
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
                                              color: selectedPaymentType == 0
                                                  ? color1
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "Partial Payment",
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
                                    height: 15,
                                  ),
                                  TextBox(
                                    controller: totalAmount,
                                    hinttext: "Total Amount",
                                    label: "",
                                    obscureText: false,
                                    isNumber: true,
                                  ),
                                  if (selectedPaymentType == 0)
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextBox(
                                          controller: partialAmount,
                                          hinttext: "Partial Payment Amount",
                                          label: "",
                                          obscureText: false,
                                          isNumber: true,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              height: 20,
                              color: color4,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Payment Mode: ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPaymentMode = 0;
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
                                              color: selectedPaymentMode == 0
                                                  ? color1
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Image(
                                          image: AssetImage(
                                              'assets/a22f9204a175e35eb8e718554e380774.png'),
                                          height: 20,
                                          width: 20,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "UPI",
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
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPaymentMode = 1;
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
                                              color: selectedPaymentMode == 1
                                                  ? color1
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Image(
                                          image:
                                              AssetImage('assets/cheque.png'),
                                          height: 23,
                                          width: 23,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Cheque",
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
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPaymentMode = 2;
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
                                              color: selectedPaymentMode == 2
                                                  ? color1
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Image(
                                          image: AssetImage(
                                              'assets/pay-on_shop.png'),
                                          height: 23,
                                          width: 23,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Pay on shop",
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
                            ),
                          ],
                        ),
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: color4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Update Map Location (Optional): ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 300,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.4)),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          width: double
                                              .infinity, // Adjust the width as needed
                                          height: 242,
                                          child: GoogleMap(
                                            initialCameraPosition:
                                                defaultLocation ??
                                                    defaultLocation ??
                                                    CameraPosition(
                                                      target: LatLng(19.175424,
                                                          72.9441897),
                                                      zoom: 16,
                                                    ),
                                            zoomControlsEnabled: false,
                                            myLocationEnabled: true,
                                            myLocationButtonEnabled: true,
                                            zoomGesturesEnabled: true,
                                            markers: marker,
                                            onMapCreated: _onMapCreated,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 2,
                                        top: 4,
                                        left: 6,
                                        right: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: color5.withOpacity(0.8),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.data['address_type'] ??
                                                      'Address',
                                                  style: TextStyle(
                                                    color: color5,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  widget.data['address'] ?? "",
                                                  style: TextStyle(
                                                    color: color5,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              PermissionStatus locationStatus =
                                                  await checkLocationPermission();

                                              if (locationStatus ==
                                                  PermissionStatus.granted) {
                                                await checkUpdatePermission();
                                              } else {
                                                showToast(
                                                    context,
                                                    'Location permission not granted',
                                                    3);
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: color1.withOpacity(0.8),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    _launchGoogleMaps();
                                  },
                                  child: Text(
                                    "VIEW ON MAP",
                                    style: TextStyle(
                                      color: color1,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: color4,
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 50,
                                color: color2,
                                padding: const EdgeInsets.all(15),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.data['customer_name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                color: const Color(0xFFE9E9E9),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 180,
                                      width: double.infinity,
                                      child: _image != null
                                          ? Image.memory(_image!)
                                          : SfSignaturePad(
                                              key: _signaturePadKey,
                                              backgroundColor: Colors.white,
                                              minimumStrokeWidth: 3,
                                              maximumStrokeWidth: 3,
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _image = null;
                                            _signaturePadKey.currentState
                                                ?.clear();
                                            setState(() {
                                              isConfirmed = false;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            padding: const EdgeInsets.all(0),
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.38,
                                                45),
                                            maximumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.38,
                                                45),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                color: color1,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "CLEAR",
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
                                          onPressed: () async {
                                            print(selectedCallType);
                                            final image = await _signaturePadKey
                                                .currentState
                                                ?.toImage();

                                            final byteData = await image!
                                                .toByteData(
                                                    format:
                                                        ui.ImageByteFormat.png);
                                            final bytes =
                                                byteData!.buffer.asUint8List();
                                            imageBase64 = base64Encode(bytes);

                                            setState(() {
                                              _image = bytes;
                                              isConfirmed = true;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: color2,
                                            padding: const EdgeInsets.all(0),
                                            minimumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.38,
                                                45),
                                            maximumSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.38,
                                                45),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                color: color1,
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "CONFIRM",
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
                            ],
                          ),
                        ),

                        SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                              List<Map<String, dynamic>> temp = [];

                              for (int i = 0; i < quotationCount; i++) {
                                String itemName = itemControllers[i].text;
                                int quantity = itemCount[i];
                                String partId = findPartId(itemName);

                                Map<String, dynamic> itemData = {
                                  'items': itemName.toString(),
                                  'quantity': quantity.toString(),
                                  'id': partId.toString(),
                                };
                                temp.add(itemData);
                              }
                              String jsonData = jsonEncode(temp);

                              if (isConfirmed) {
                                if (validateAndSubmitDetails()) {
                                  CloseRequestFinal data = CloseRequestFinal(
                                    serviceId:
                                        widget.data['service_id'].toString(),
                                    userId: widget.userId,
                                    image1: base64List[0],
                                    image2: base64List[1],
                                    image3: base64List[2],
                                    callType: selectedCallType.toString(),
                                    paymentType: selectedPaymentType.toString(),
                                    paymentMode: selectedPaymentMode.toString(),
                                    fullAmount: totalAmount.text,
                                    partialAmount: partialAmount.text,
                                    review: comment.text,
                                    sign: imageBase64,
                                    partsDetails: jsonData,
                                    sticker: image_Base64,
                                    isGst: selectedGstType.toString(),
                                    year: selectedYear,
                                    amcStartDate: startDate.text,
                                    rating: selectedRating.toString(),
                                  );
                                  await HttpApiCall()
                                      .closeRequestFinal(context, data);
                                }
                              }

                              setState(() {
                                isLoading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isConfirmed
                                  ? color2
                                  : color2.withOpacity(0.4),
                              padding: const EdgeInsets.all(0),
                              minimumSize:
                                  const Size(double.infinity * 0.42, 45),
                              maximumSize:
                                  const Size(double.infinity * 0.42, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isConfirmed
                                      ? color1
                                      : color2.withOpacity(0.3),
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
                                    "Close Service",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
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

  Future<void> checkUpdatePermission() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then(
      (Position position) {
        setState(() {
          currentPosition = position;
        });
        if (widget.lat.isNotEmpty && widget.lat.isNotEmpty) {
          if (currentPosition != null) {
            showToast(context, 'Move your screen to select location', 3);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Stack(
                  children: [
                    PlacePicker(
                      apiKey: googleApiKey,
                      initialPosition: LatLng(
                        double.parse(widget.lat),
                        double.parse(widget.lng),
                      ),
                      resizeToAvoidBottomInset: true,
                      useCurrentLocation: false,
                      selectInitialPosition: true,
                      usePlaceDetailSearch: true,
                      selectedPlaceWidgetBuilder:
                          (context, place, details, animationController) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(0.0, -3.0),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      place?.formattedAddress ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        double? latitude;
                                        double? longitude;

                                        setState(() {
                                          latitude =
                                              place?.geometry!.location.lat;
                                          longitude =
                                              place?.geometry!.location.lng;
                                          HttpApiCall()
                                              .updateMapLocation(context, {
                                            'address_id': widget.addressId,
                                            'latitude': latitude.toString(),
                                            'longitude': longitude.toString(),
                                            'service_id':
                                                widget.data['service_id'],
                                          });
                                        });
                                      },
                                      child: Text('Select This Place'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      forceSearchOnZoomChanged: true,
                      automaticallyImplyAppBarLeading: false,
                      autocompleteLanguage: "en",
                      region: 'us',
                    ),
                    Positioned(
                      bottom: -1.5,
                      left: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color2,
                          padding: const EdgeInsets.all(0),
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.38, 50),
                          maximumSize: Size(
                              MediaQuery.of(context).size.width * 0.38, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2),
                            ),
                            side: BorderSide(
                              color: color2,
                            ),
                          ),
                        ),
                        child: const Text(
                          "Select Your Location",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          showToast(context, 'Latitude & Logitude are null', 3);
        }
      },
    ).catchError((e) {
      showToast(context, e, 3);
      print(e);
    });
  }

  Future<PermissionStatus> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status;
  }
}
