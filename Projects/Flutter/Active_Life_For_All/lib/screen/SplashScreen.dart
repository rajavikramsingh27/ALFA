import 'dart:async';
import 'package:alfa/utils/Constents.dart';
import 'package:flutter/material.dart';

import '../res.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    startTime();
  }

  @override
  Widget build(BuildContext context) {
//    FlutterStatusbarcolor.setStatusBarColor(AppConstant.colorwhite);
//    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    Container baseContainer = Container(
        decoration:BoxDecoration(color:AppConstant.colorwhite
        ),
        child:Center(
          child:Image(
              image: AssetImage(Res.ic_logo,),
              height: 150.0,
              width: 150.0),
        ));
    return Scaffold(
      backgroundColor: AppConstant.colorwhite,
      body: baseContainer,
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    Navigator.pushReplacementNamed(
        context,
        '/intro'
    );
  }

}