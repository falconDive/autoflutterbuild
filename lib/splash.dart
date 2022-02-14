import 'dart:async';

import 'package:flutter/material.dart';

import 'package:freelancer_webview_task1/parameters.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

import 'appwebview.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    OneSignal.shared.setAppId(Parameters.onesignalID);
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    Timer.periodic(const Duration(seconds: 2), (timer) {
      timer.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InAppWebViewExampleScreen()),
      );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Parameters.splashScreenBackgroundColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ADD NEW LOGO TO ASSET FOLDER AND RENAME BELOW
          Center(child: Image.asset(Parameters.splashScreenImagePath)),
        ],
      ),
    );
  }
}
