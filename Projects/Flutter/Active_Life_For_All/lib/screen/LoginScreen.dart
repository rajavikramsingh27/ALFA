import 'package:alfa/res.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:toast/toast.dart';
import 'dart:io' show Platform;


class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final textEmail = TextEditingController();
  final textPassword = TextEditingController();

  var isEnableLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.center,
                child: Image.asset(Res.ic_logo, width: 190, height: 80),
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                "Login",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: AppConstant.kPoppins,
                    fontWeight: FontWeight.bold,
                    color: AppConstant.color_blue_dark),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Padding(
                  padding: EdgeInsets.only(left: 1),
                  child: TextField(
                    controller:textEmail,
                    keyboardType: TextInputType.emailAddress,
                    keyboardAppearance:Brightness.light,
                    cursorColor: Color(0xff84828F),
                    decoration: InputDecoration(
                        //labelText: title ,  // you can change this with the top text  like you want
                        labelText: "Email Address",
                        hintStyle: TextStyle(
                            fontFamily: AppConstant.kPoppins,
                            fontWeight: FontWeight.normal,
                            fontSize: 12),
                        /*border: InputBorder.none,*/
                        fillColor: Color(0xff84828F)),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Padding(
                  padding: EdgeInsets.only(left: 1),
                  child: TextField(
                    controller: textPassword,
                    keyboardType: TextInputType.text,
                    keyboardAppearance:Brightness.light,
                    obscureText: true,
                    cursorColor: Color(0xff84828F),
                    decoration: InputDecoration(
                        //labelText: title ,  // you can change this with the top text  like you want
                        labelText: 'Password',
                        hintStyle: TextStyle(
                            fontFamily: AppConstant.kPoppins,
                            fontWeight: FontWeight.normal,
                            fontSize: 12),
                        /*border: InputBorder.none,*/
                        fillColor: Color(0xff84828F)),

                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/forgotpassword');
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      color: AppConstant.color_blue_dark,
                      fontSize: 16,
                      fontFamily: AppConstant.kPoppins,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                padding: EdgeInsets.all(0),
                width: double.infinity,
                height: 50,
                decoration:kButtonThemeGradientColor(),
                child: FlatButton(
                    textColor: Colors.white,
                    onPressed: () {
                      bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(textEmail.text);
                      if (textEmail.text.isEmpty) {
                        Toast.show('Enter Email-ID', context,
                            duration: 2,
                            gravity: Toast.BOTTOM,
                            backgroundColor: HexColor(redColor));
                      } else if (!emailValid) {
                        Toast.show('Enter a valid email ID', context,
                            duration: 2,
                            gravity: Toast.BOTTOM,
                            backgroundColor: HexColor(redColor));
                      } else if (textPassword.text.isEmpty) {
                        Toast.show("Enter password", context,
                            duration: 2,
                            gravity: Toast.BOTTOM,
                            backgroundColor: HexColor(redColor));
                      } else if (textPassword.text.length < 6) {
                        Toast.show(
                            "Password length must be more than 6 characters",
                            context,
                            duration: 2,
                            gravity: Toast.BOTTOM,
                            backgroundColor: HexColor(redColor));
                      } else {
                        showLoading(context);
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email:textEmail.text,
                            password:textPassword.text).then((value) {
                              Firestore.instance.collection(tblUserDetails)
                                  .document(value.user.email+kFireBaseConnect+value.user.uid).updateData({
                                kDeviceToken:deviceToken,
                                kDeviceType: Platform.isIOS ? 'iOS' : 'Android',
                              }).then((value) {
                                dismissLoading(context);
                                Navigator.pushNamed(context, '/TabbarScreen');
                              }).catchError((error) {
                                dismissLoading(context);
                                Toast.show(
                                    error.message.toString(),
                                    context,
                                    backgroundColor:HexColor(redColor)
                                );
                              });
                        }).catchError((error) {
                              dismissLoading(context);
                              Toast.show(
                                  error.message.toString(),
                                  context,
                                backgroundColor:HexColor(redColor)
                              );
                        });
                      }
                    },
                    child: Text(
                      'Login',
                      style:TextStyle(
                          color: Colors.white,
                          fontFamily: AppConstant.kPoppins,
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    )),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
