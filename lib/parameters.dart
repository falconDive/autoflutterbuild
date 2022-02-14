

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Parameters{

  //AppName: can be changed from android/app/src/main/AndroidManifest.xml --- android:label
  //Package Name: can be changed from android/app/build.gradle --- applicationId
  //Version: can be changed from /pubspec.yaml --- version:

  //App icon path: can be changed from android/app/src/main/res
  //Admob banner ID: can be changed from android/app/src/main/AndroidManifest.xml
  /*
  <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-3940256099942544~3347511713"/>
   */
  //Google Analytics ID: Just add googleService.json file android/app folder from Firebase. App cannot run without it. So I removed related codes.
  static late String webViewURL;
  static late String splashScreenImagePath ;
  static late int splashScreenBackgroundColor ;
  static late int primaryColor = 0XFF000000 ;
  static late int secondaryColor = 0XFFFFFFFF ;
  static late String onesignalID ;
  static late String appOrientation ; //auto //portrait //landscape
  static late String webViewMode ; // mobile//desktop
  static late String admobPosition; //top //bottom
  static late String adUnitId ;
  static late bool darkMode = false;
  static late bool pullToReload ;
  static late bool zoomControl ;
  static late List permissions ; // ['camera']  //['location'] // []




}