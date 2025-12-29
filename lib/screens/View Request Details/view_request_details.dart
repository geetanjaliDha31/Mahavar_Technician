// ignore_for_file: must_be_immutable, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/http/http.dart';
import 'package:mahavar_technician/models/get_service_details_id.dart';
import 'package:mahavar_technician/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_technician/screens/Close%20Request/close_request.dart';
import 'package:mahavar_technician/screens/Create%20Quotation/create_quotation.dart';
import 'package:mahavar_technician/widgets/toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class ViewRequestDetails extends StatefulWidget {
  Map<String, dynamic> data;
  ViewRequestDetails({super.key, required this.data});

  @override
  State<ViewRequestDetails> createState() => _ViewRequestDetailsState();
}

class _ViewRequestDetailsState extends State<ViewRequestDetails> {
  @override
  void initState() {
    super.initState();
    _fetchServiceDetails();
  }

  String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  bool isLoading = false;

  CameraPosition? defaultLocation;

  double? apiLatitude;
  double? apiLongitude;
  String? userId;
  String? lat;
  String? lng;
  String? addressId;
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BottomNavBar(),
                        ),
                      );
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
                    "REQUEST DETAILS",
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
        future: HttpApiCall().getServiceDetailsbyID(
          {
            'service_id': widget.data['service_id'],
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ServiceDetailsbyId res = snapshot.data!;
            final temp = res.resultArray![0].serviceDetailsArray![0];
            lat = temp.latitude!;
            lng = temp.longitude!;
            addressId = temp.addressId!.toString();
            userId = temp.userId!.toString();
            Map<String, dynamic> data = {
              'service_id': widget.data['service_id'],
              'customer_name': temp.customerName,
              "mobile_no": temp.customerMobileNo,
              "device": "${temp.brandName} ${temp.modelName}",
              "issue": temp.issueName,
              "comment": temp.comments,
              "status": temp.status,
              "address": temp.serviceAddress,
              'address_type': temp.addressType,
            };

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['customer_name'],
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
                                data['mobile_no'],
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
                                data['device'],
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
                                data['issue'],
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
                                data['comment'] ?? 'No comments',
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
                              "Status: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: red,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                data['status'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: red,
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
                        Divider(
                          color: color3,
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 8,
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
                                      initialCameraPosition: defaultLocation ??
                                          defaultLocation ??
                                          CameraPosition(
                                            target:
                                                LatLng(19.175424, 72.9441897),
                                            zoom: 15,
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
                                padding:
                                    const EdgeInsets.only(bottom: 2, top: 4),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
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
                                            data['address_type'] ?? 'Address',
                                            style: TextStyle(
                                              color: color5,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            data['address'] ?? "",
                                            style: TextStyle(
                                              color: color5,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    )
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
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    color: color4,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true; // Show the loader
                                });

                                try {
                                  // Call the updateLoc function and wait for the API response
                                  updateLoc(temp.addressId.toString());

                                  // Optionally show a success message or handle the response
                                } catch (e) {
                                  // Show a toast message if something goes wrong
                                  showToast(
                                      context,
                                      "Something went wrong. Please try again.",
                                      3);
                                } finally {
                                  setState(() {
                                    isLoading = false; // Hide the loader
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color4,
                                padding: const EdgeInsets.all(0),
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.425,
                                    45),
                                maximumSize: Size(
                                    MediaQuery.of(context).size.width * 0.425,
                                    45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: color1,
                                  ),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width:
                                          18, // Width of CircularProgressIndicator
                                      height:
                                          18, // Height of CircularProgressIndicator
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        strokeWidth:
                                            3.0, // Stroke width of the CircularProgressIndicator
                                      ),
                                    )
                                  : Text(
                                      "Update Map Location",
                                      style: TextStyle(
                                        color: color1,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CreateQuotation(
                                      data: data,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color4,
                                padding: const EdgeInsets.all(0),
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.425,
                                    45),
                                maximumSize: Size(
                                    MediaQuery.of(context).size.width * 0.425,
                                    45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: color1,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Create Quotation",
                                style: TextStyle(
                                  color: color1,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CloseRequest(
                                  data: data,
                                  userId: userId!,
                                  lat: temp.latitude ?? '',
                                  lng: temp.longitude ?? '',
                                  addressId: addressId ?? '',
                                ),
                              ),
                            );
                            print(userId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color1,
                            padding: const EdgeInsets.all(0),
                            minimumSize: const Size(double.infinity * 0.42, 45),
                            maximumSize: const Size(double.infinity * 0.42, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: color1,
                              ),
                            ),
                          ),
                          child: const Text(
                            "Close Request",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
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
    );
  }

  Future<void> checkUpdatePermission() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then(
      (Position position) {
        setState(() {
          currentPosition = position;
        });
        if (lat != null && lng != null && lat!.isNotEmpty && lat!.isNotEmpty) {
          print('lat: $lat');
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
                        double.parse(lat ?? ''),
                        double.parse(lng ?? ''),
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
                                            'address_id': addressId,
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

  void updateLoc(String addressId) async {
    PermissionStatus locationStatus = await checkLocationPermission();

    if (locationStatus == PermissionStatus.granted) {
      checkUpdatePermission();
    } else {
      showToast(context, 'Location permission not granted', 3);
    }
  }

  Future<PermissionStatus> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status;
  }
}
