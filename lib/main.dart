// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahavar_technician/constants.dart';
import 'package:mahavar_technician/provider/mobileno_provider.dart';
import 'package:mahavar_technician/provider/panel_provider.dart';
import 'package:mahavar_technician/provider/login_sliding_up.dart';
import 'package:mahavar_technician/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_technician/screens/Getting%20started/getting_started.dart';
import 'package:mahavar_technician/screens/Login/login.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await ScreenProtector.preventScreenshotOn();
  }
  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  // if (Platform.isAndroid) {
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
  // });

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("b8ee35a1-49f5-45f6-880c-b8609110b63d");

  OneSignal.Notifications.requestPermission(true);

  playerId = OneSignal.User.pushSubscription.id;
  print("Player id : $playerId");
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    getPref();
    super.initState();
  }

  bool? getStartedSeen;
  bool? login;

  void getPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    getStartedSeen = prefs.getBool("getStartedSeen");
    login = prefs.getBool("loginInned");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SlidingUpPanelProvider()),
        ChangeNotifierProvider(create: (context) => PanelProvider()),
        ChangeNotifierProvider(create: (_) => MobileNo()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mahavar Technician',
        theme: ThemeData(
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSeed(seedColor: color2),
          useMaterial3: true,
        ),
        home: getStartedSeen != null
            ? login != null
                ? const BottomNavBar()
                : const LoginPage()
            : const GettingStarted(),
      ),
    );
  }
}
