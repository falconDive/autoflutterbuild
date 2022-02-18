
// import 'dart:convert';
import 'dart:collection';
import 'dart:io';
// import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_webview_task1/parameters.dart';
import 'connectivity.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'main.dart';
import 'package:permission_handler/permission_handler.dart';

import 'parameters.dart';

class InAppWebViewExampleScreen extends StatefulWidget {
  @override
  _InAppWebViewExampleScreenState createState() =>
      new _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {

  final GlobalKey webViewKey = GlobalKey();


  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        supportZoom: Parameters.zoomControl,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  // late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  Map _source = {ConnectivityResult.wifi: true};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  final BannerAd myBanner = BannerAd(
    adUnitId: Parameters.adUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );


  getPermissions() async {
    if(Parameters.permissions.length==1) {
      if(Parameters.permissions.contains('camera'))  await Permission.camera.request();
      else await Permission.location.request();
    }
    else if(Parameters.permissions.length==2) {
      await Permission.camera.request();
      await Permission.location.request();
    } else {

    }


  }
  @override
  void initState() {
    getPermissions();
    pullToRefreshController = PullToRefreshController(
      onRefresh: (){
        if(Parameters.pullToReload)
        webViewController!.reload().then((value) {
          pullToRefreshController!.endRefreshing();
        });

      },
    );
    if(Parameters.adUnitId.isNotEmpty) {
      myBanner.load();
    }
    super.initState();
      _connectivity.initialise();
      _connectivity.myStream.listen((source) {
        setState(() => _source = source);
      });


    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });


  }

  @override
  void dispose() {
    if(Parameters.adUnitId.isNotEmpty) {
      myBanner.dispose();
    }
    super.dispose();
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return Future.value(false);
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.confirm,
          confirmBtnColor: Colors.red,
          text: "Exit",
          onConfirmBtnTap: (){
            exit(0);
          }
      );
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: _source.keys.toList()[0]!=ConnectivityResult.none ?  SafeArea(
        child: Scaffold(
            body: Column(

                children: <Widget>[
              Parameters.admobPosition =='top' && Parameters.adUnitId.isNotEmpty ? Container(
                  alignment: Alignment.center,
                  width: myBanner.size.width.toDouble(),
                  height: myBanner.size.height.toDouble(),
                  child: AdWidget(ad: myBanner)):SizedBox(),
              false ? Expanded(
                child: SingleChildScrollView( 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('webViewURL: '+Parameters.webViewURL),
                          )
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('splashScreenImagePath: '+Parameters.splashScreenImagePath),
                              Image.asset(Parameters.splashScreenImagePath),
                            ],
                          ),
                        ),
                      ),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('splashScreenBackgroundColor: '),
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black26),color: Color(Parameters.splashScreenBackgroundColor),),
                                height: 20,
                                width: 20,

                              )
                              ],
                            ),
                          )
                      ),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('primaryColor: '),
                                Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black26),color: Color(Parameters.primaryColor),),
                                  height: 20,
                                  width: 20,

                                )
                              ],
                            ),
                          )
                      ),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text('secondaryColor: '),
                                Container(
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black26),color: Color(Parameters.secondaryColor),),
                                  height: 20,
                                  width: 20,

                                )
                              ],
                            ),
                          )
                      ),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('onesignalID: '+Parameters.onesignalID),
                          )
                      ), Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('appOrientation: '+Parameters.appOrientation),
                          )
                      ), Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('webViewMode: '+Parameters.webViewMode),
                          )
                      ),Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('admobPosition: '+Parameters.admobPosition),
                          )
                      ),Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('adUnitId: '+Parameters.adUnitId),
                          )
                      ),Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('darkMode: '+Parameters.darkMode.toString()),
                          )
                      ),Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('pullToReload: '+Parameters.pullToReload.toString()),
                          )
                      ),Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('zoomControl: '+Parameters.zoomControl.toString()),
                          )
                      ),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('permissions: '+Parameters.permissions.toString()),
                          )
                      ),


                    ],
                  ),
                ),
              )
                  : Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      pullToRefreshController: pullToRefreshController,

                      // contextMenu: contextMenu,
                      /// HERE YOU NEED TO PUT URL BELOW
                      initialUrlRequest:
                      URLRequest(url: Uri.parse(Parameters.webViewURL)),
                      // initialFile: "assets/index.html",
                      initialUserScripts: UnmodifiableListView<UserScript>([]),
                      initialOptions: options,
                      //pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        if(Parameters.webViewMode=='desktop')
                        webViewController!.evaluateJavascript(source: "document.querySelector('meta[name=\"viewport\"]').setAttribute('content', 'width=1024px, initial-scale=' + (document.documentElement.clientWidth / 1024));");
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      androidOnPermissionRequest: (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {

                        var uri = navigationAction.request.url!;

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                            return NavigationActionPolicy.CANCEL;
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {

                        //pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        //pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {

                        if (progress == 100) {
                          //pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.url;
                        });
                      },
                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                    // IgnorePointer(
                    //   ignoring: true,
                    //   child: Center(
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //           children: [
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //             Text('DRAFT' , style: TextStyle(fontSize: 30,color: Colors.white),),
                    //           ],
                    //         ),
                    //
                    //
                    //
                    //
                    //
                    //
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              Parameters.admobPosition =='bottom' && Parameters.adUnitId.isNotEmpty ? Container(
                  alignment: Alignment.center,
                  width: myBanner.size.width.toDouble(),
                  height: myBanner.size.height.toDouble(),
                  child: AdWidget(ad: myBanner)):SizedBox(),
            ])),
      ):
      Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Column(
              children: [
                Icon(Icons.signal_wifi_off,size: 100,),
                SizedBox(height: 20,),
                Text('No Interent Connection',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
              ],
            )),

          ],
        ),
      ),
    );
  }
}