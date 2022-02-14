import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freelancer_webview_task1/parameters.dart';
import 'package:freelancer_webview_task1/splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:firebase_core/firebase_core.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  //await Firebase.initializeApp();

  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool finished = false;
  @override
  void initState() {
    readJson();
    super.initState();
  }

  Future readJson() async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/configuration.json');
    final dynamic jsonMap = jsonDecode(jsonString);
    Parameters.admobPosition = jsonMap['admobPosition'];
    Parameters.webViewURL = jsonMap['webViewURL'];
    Parameters.splashScreenImagePath = jsonMap['splashScreenImagePath'];
    Parameters.splashScreenBackgroundColor = int.parse(jsonMap['splashScreenBackgroundColor']);
    Parameters.primaryColor = int.parse(jsonMap['primaryColor']);
    Parameters.secondaryColor = int.parse(jsonMap['secondaryColor']);
    Parameters.onesignalID = jsonMap['onesignalID'];
    Parameters.appOrientation = jsonMap['appOrientation'];
    Parameters.webViewMode = jsonMap['webViewMode'];
    Parameters.adUnitId = jsonMap['adUnitId'];
    Parameters.pullToReload = jsonMap['pullToReload'];
    Parameters.darkMode = jsonMap['darkMode'];
    Parameters.zoomControl = jsonMap['zoomControl'];
    Parameters.permissions = jsonMap['permissions'];
    MobileAds.instance.initialize();
    if(Parameters.appOrientation == 'auto' ) {
      //Set to auto
    }
    else  if(Parameters.appOrientation == 'landscape' ) {
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ],
      );
    }
    else  if(Parameters.appOrientation == 'portrait' ) {
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown
        ],
      );
    }
    setState(() {
      finished = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(Parameters.primaryColor), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(Parameters.secondaryColor)),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
      themeMode: Parameters.darkMode ? ThemeMode.dark:ThemeMode.light,
      home: finished ? Splash(): SizedBox(),
    );
  }
}

