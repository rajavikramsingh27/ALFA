
import 'package:alfa/res.dart';
import 'package:alfa/screen/CardDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_notification_center/dart_notification_center.dart';



class MyCards extends StatefulWidget {
  @override
  _MyCardsState createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  var indexSelected = -1;
  List<Map<String, dynamic>> arrActiveDailyLife = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1), () async {
      getAllCards();
      DartNotificationCenter.subscribe(channel:tblPaymentCards,observer:this,onNotification: (result) {
        getAllCards();
        },
      );
    });

    // TODO: implement initState
    super.initState();
  }

getAllCards() async {
  FirebaseAuth.instance.currentUser().then((value) async {
    QuerySnapshot querySnapshot =
    await Firestore.instance.collection(tblPaymentCards)
        .document(value.email + kFireBaseConnect + value.uid)
        .collection(value.uid).getDocuments();
    arrActiveDailyLife = querySnapshot.documents.map((DocumentSnapshot doc) {
      return doc.data;
    }).toList();
    setState(() {});
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
              'My Card',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppConstant.kPoppins,
                  color: AppConstant.color_blue_dark,
                  fontWeight: FontWeight.bold),
            ),
            textTheme: TextTheme(title: TextStyle(color: Colors.black)),
            centerTitle: false,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0.5,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  56 -
                  90,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                scrollDirection: Axis.vertical,
                itemCount: arrActiveDailyLife.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        height: 150,
                        width: 210,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Image.asset(
                                  Res.cardBG,
                                ),
                                Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 16,
                                  right: 16,
                                  child: Container(
                                    height: 150,
                                    width: 210,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          arrActiveDailyLife[index]
                                              [kCardName],
                                          style:TextStyle(
                                              fontSize:16,
                                              fontFamily:AppConstant.kPoppins,
                                              color:Colors.white,
                                              fontWeight:FontWeight.normal),
                                        ),
                                        SizedBox(height:13),
                                        Text(
                                          arrActiveDailyLife[index]
                                              [kCardNumber],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: AppConstant.kPoppins,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 13),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Image.asset(
                                            Res.visaLogo,
                                            height: 16,
                                            width: 54,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Visibility(
                              visible: (indexSelected == index) ? true : false,
                              child: Icon(
                                Icons.check_circle,
                                size: 32,
                                color: HexColor('#54C9AF'),
                              ),
                            )
                          ],
                        )),
                    onTap: () {
                      indexSelected = index;
                      setState(() {
                        dictSelectedDetails = arrActiveDailyLife[index];
                        Navigator.pushNamed(context, '/CardDetails');
                      });
                    },
                  );
                },
              ),
            ),
            SafeArea(
              child: Container(
                  decoration: kButtonThemeGradientColor(),
                  height: 56,
                  width: 300,
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: FlatButton(
                    textColor: Colors.white,
                    child: Text(
                      'Add New Card',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppConstant.kPoppins,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/AddNewCard');
                    },
                  )),
            )
          ],
        ));
  }
}
