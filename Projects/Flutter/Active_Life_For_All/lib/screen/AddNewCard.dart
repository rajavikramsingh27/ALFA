import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:dart_notification_center/dart_notification_center.dart';



class AddNewCard extends StatefulWidget {
  @override
  _AddNewCardState createState() => _AddNewCardState();
}


class _AddNewCardState extends State<AddNewCard> {
  var textCardName = TextEditingController();
  var textCardType = TextEditingController();
  var textCVV = TextEditingController();

  var expiryDate = 'MM/YY';

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _date = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2016),
        lastDate: DateTime(2021)
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        expiryDate = DateFormat('MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
              'Add your card',
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
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
//                name
                Text(
                  'Name',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppConstant.kPoppins,
                      color: AppConstant.color_blue_dark,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 14),
                TextFormField(
                  controller: textCardName,
                  keyboardAppearance: Brightness.light,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppConstant.kPoppins,
                      color: AppConstant.color_blue_dark,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: HexColor('#CECECE'))),
                  ),
                ),
//                Credit/Debit Card
                SizedBox(height: 20),
                Text(
                  'Credit/Debit Card Number',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppConstant.kPoppins,
                      color: AppConstant.color_blue_dark,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 14),
                TextFormField(
                  keyboardType:TextInputType.number,
                  controller: textCardType,
                  keyboardAppearance: Brightness.light,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppConstant.kPoppins,
                      color: AppConstant.color_blue_dark,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    hintText: 'Credit/Debit Card Number',
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: HexColor('#CECECE'))),
                  ),
                ),
//                Expiry
                SizedBox(height: 20),
                Text(
                  'Expiry',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppConstant.kPoppins,
                      color: AppConstant.color_blue_dark,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 14),
                FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        expiryDate,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppConstant.kPoppins,
                            color: AppConstant.color_blue_dark,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    onPressed: () {
                      _selectDate(context);
                    }),
                SizedBox(height: 20),
                Text(
                  'Security Code',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppConstant.kPoppins,
                      color: AppConstant.color_blue_dark,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 14),
                TextFormField(
                  controller: textCVV,
                  keyboardType:TextInputType.number,
                  keyboardAppearance: Brightness.light,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppConstant.kPoppins,
                      color: AppConstant.color_blue_dark,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    hintText: 'Security Code',
                    contentPadding: EdgeInsets.only(left: 16, right: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorenterder.none,
//                    errorBorder: InputBorder.none,
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: HexColor('#CECECE'))),
                  ),
                ),

                SizedBox(height: 70),
                FlatButton(
                  textColor: Colors.white,
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: kButtonThemeGradientColor(),
                    alignment: Alignment.center,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppConstant.kPoppins,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  onPressed: () {
                    if (textCardName.text.isEmpty) {
                      Toast.show('Enter card name', context,
                          backgroundColor: HexColor(redColor));
                    } else if (textCardType.text.isEmpty) {
                      Toast.show('Enter card type', context,
                          backgroundColor: HexColor(redColor));
                    } else if (expiryDate == 'MM/YY') {
                      Toast.show("Enter card's expiry Date", context,
                          backgroundColor: HexColor(redColor));
                    } else if (textCVV.text.isEmpty) {
                      Toast.show("Enter card's cvv", context,
                          backgroundColor: HexColor(redColor));
                    } else {
                      showLoading(context);
                      FirebaseAuth.instance.currentUser().then((value) {
                        Firestore.instance
                            .collection(tblPaymentCards)
                            .document(
                                value.email + kFireBaseConnect + value.uid)
                            .collection(value.uid)
                            .document(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString())
                            .setData({
                          kCardName: textCardName.text,
                          kCardNumber: textCardType.text,
                          kExpiryDate: expiryDate,
                          kCVV: textCVV.text,
                          kVisa: '',
                          kCreatedTime:DateTime.now().millisecondsSinceEpoch.toString()
                        }).then((value) {
                          DartNotificationCenter.post(
                            channel:tblPaymentCards,
                            options:'',
                          );

                          dismissLoading(context);
                          Navigator.pop(context);
                          Toast.show('Card added successfully.', context,
                              backgroundColor: HexColor(greenColor)
                          );
                        }).catchError((error) {
                          dismissLoading(context);
                          Toast.show(
                              error.message.toString(), context,
                              backgroundColor: HexColor(greenColor)
                          );
                        });
                      }).catchError((error) {
                        dismissLoading(context);
                        Toast.show(
                            error.message.toString(),
                            context,
                            backgroundColor:HexColor(greenColor)
                        );
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
