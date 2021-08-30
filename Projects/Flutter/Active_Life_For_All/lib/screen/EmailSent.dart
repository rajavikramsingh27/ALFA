import 'package:alfa/res.dart';
import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';


class EmailSent extends StatefulWidget {
  @override
  _EmailSentState createState() => _EmailSentState();
}

class _EmailSentState extends State<EmailSent> {
  Future<bool> onpressedBack() {
    var nav = Navigator.of(context);
    nav.pop();
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
          backgroundColor:Colors.white,
          brightness:Brightness.light,
          elevation:0.5,
          leading:IconButton(
              icon:Icon(
                Icons.arrow_back,
                color:Colors.black,
                size:30,
              ),
              onPressed:() => onpressedBack()),
      ),
      body:WillPopScope(
        onWillPop:onpressedBack,
        child:Center(
        child:Column(
          children: <Widget>[
            SizedBox(
              height:30,
            ),
            Image.asset(
              Res.emailSent,
              height:110,
              width:120,
            ),
            SizedBox(
              height:30,
            ),
            Text('Email Sent!',
              style:TextStyle(
                  fontSize:30,
                  fontWeight:FontWeight.bold,
                  fontFamily:AppConstant.kPoppins,
                  color: AppConstant.color_blue_dark
              ),
            ),
            SizedBox(
              height:20,
            ),
            Text('Email sent to your email address to create',
              style:TextStyle(
                  fontSize:13,
                  fontWeight:FontWeight.normal,
                  fontFamily:AppConstant.kPoppins,
                  color: AppConstant.color_blue_dark
              ),
            ),
            Text('new password',
              style:TextStyle(
                  fontSize:13,
                  fontWeight:FontWeight.normal,
                  fontFamily:AppConstant.kPoppins,
                  color: AppConstant.color_blue_dark
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}


