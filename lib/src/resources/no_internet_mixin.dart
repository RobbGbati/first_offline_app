import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:first_offline_app/src/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

 
/// this mixin is use to check if connection state change
/// in the application
/// 
/// how to use it?
/// When using statefull widget, add "with NoInternetMixin".

mixin NoInternetMixin<T extends StatefulWidget> on State<T> {
  bool isInternetAlertOn = false;

  late StreamSubscription connectivityStream;
  var log = Logger();

  @override
  void initState() {
    super.initState();
    log.d("no internet mixin");
    connectivityStream = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        showDialog(barrierDismissible: false, context: context, builder: (_) => Utils().buildAlert("Pas de connexion !"));
        isInternetAlertOn = true;
      } else {
        if (isInternetAlertOn) {
          isInternetAlertOn = false;
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  void dispose() {
    connectivityStream.cancel();
    super.dispose();
  }
}
