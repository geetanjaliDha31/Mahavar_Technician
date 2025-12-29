// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/provider/panel_provider.dart';
import 'package:mahavar_technician/screens/Profile/Profile%20Sliding%20panel%20items/logout.dart';
import 'package:mahavar_technician/screens/Profile/Profile%20Sliding%20panel%20items/parts_inventory.dart';
import 'package:mahavar_technician/screens/Profile/Profile%20Sliding%20panel%20items/profile_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfilePage extends StatefulWidget {
  final PanelController controller;
  const ProfilePage({super.key, required this.controller});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loading = true;
  String? fname = '';
  String? lname = '';
  String? email = '';
  String? mobile = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    loading = false;
  }

  _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fname = prefs.getString("first_name") ?? '';
      lname = prefs.getString("last_name") ?? '';
      email = prefs.getString("email") ?? '';
      mobile = prefs.getString("mobile_no") ?? '';
      imageUrl = prefs.getString("profile_image") ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: color4,
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/profile_background.png"),
                              fit: BoxFit.fill),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$fname"" ""$lname",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "+91" " " "$mobile",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        '$email',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(imageUrl),
                                    radius: 35,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        height: 40,
                        child: InkWell(
                          onTap: () {
                            context.read<PanelProvider>().openPanel(
                                ProfiledetailsPage(
                                  controller: widget.controller,
                                ),
                                MediaQuery.of(context).size.height * 0.6);
                            widget.controller.open();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: Colors.black,
                                size: 22,
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Profile details",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: color3,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(13, 0, 20, 0),
                        height: 40,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PartsInventory(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/part_bg.svg',
                                height: 38,
                                width: 38,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Parts Inventory",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: color3,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        height: 40,
                        child: InkWell(
                          onTap: () {
                            context.read<PanelProvider>().openPanel(
                                Logout(controller: widget.controller),
                                MediaQuery.of(context).size.height * 0.25);
                            widget.controller.open();
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: Colors.black,
                                size: 22,
                              ),
                              SizedBox(width: 20),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: color3,
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
        ),
        // SlidingUpPanel(
        //   controller: _controller,
        //   minHeight: 0.0,
        //   maxHeight: _panelHeight(),
        //   panelBuilder: (sc) {
        //     return _buildPanelContent();
        //   },
        //   borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        //   // backdropTapClosesPanel: true,
        //   // isDraggable: false,
        //   backdropEnabled: true,
        //   backdropColor: Colors.black,
        //   backdropOpacity: 0.4,
        //   onPanelOpened: () {
        //     isPanelOpen = true;
        //     context.read<BottomNavbarProvider>().toggleNavbar(true);
        //   },
        //   onPanelClosed: () {
        //     isPanelOpen = false;
        //     context.read<BottomNavbarProvider>().toggleNavbar(false);
        //     index = 0;
        //   },
        // )
      ],
    );
  }
}
