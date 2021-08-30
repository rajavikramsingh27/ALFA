import 'package:alfa/utils/Constents.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.05, 0.9],
      colors: [AppConstant.colorPrimary, AppConstant.colorPrimaryDark]);

  static showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static Widget getLoader() {
    return CircularProgressIndicator();
  }

  static void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print("${match.group(0)}"));
  }
}
