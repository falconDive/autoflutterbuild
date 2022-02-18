import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_webview_task1/parameters.dart';
import 'package:fl_webview_task1/splash.dart';
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
    if(jsonMap['splashScreenImagePath'].toString().isNotEmpty) {
      if(jsonMap['splashScreenBackgroundColor'].toString().isNotEmpty) {
        Parameters.splashScreenBackgroundColor = int.parse(jsonMap['splashScreenBackgroundColor']);
      }
      else {
        Parameters.splashScreenBackgroundColor = 0XFFFFFFFF;
      }
    } else {
      Parameters.splashScreenBackgroundColor = 0XFFFFFFFF;
    }

    if(jsonMap['primaryColor'].toString().isNotEmpty) {
      Parameters.primaryColor = int.parse(jsonMap['primaryColor']);
    } else {
      Parameters.primaryColor  = 0XFF000000;
    }

    if(jsonMap['secondaryColor'].toString().isNotEmpty) {
      Parameters.secondaryColor = int.parse(jsonMap['secondaryColor']);
    } else {
      Parameters.secondaryColor  = 0XFFFFFFFF;
    }


    Parameters.onesignalID = jsonMap['onesignalID'];
    Parameters.appOrientation = jsonMap['appOrientation'];
    Parameters.webViewMode = jsonMap['webViewMode'];
    Parameters.adUnitId = jsonMap['adUnitId'];
    Parameters.pullToReload = jsonMap['pullToReload']=='true';
    Parameters.darkMode = jsonMap['darkMode']=='true';
    Parameters.zoomControl = jsonMap['zoomControl']=='true';
    if(jsonMap['permissions'].runtimeType.toString()=='List<dynamic>') {
      Parameters.permissions = jsonMap['permissions'];
    }
    else {
      Parameters.permissions = [];
    }


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
