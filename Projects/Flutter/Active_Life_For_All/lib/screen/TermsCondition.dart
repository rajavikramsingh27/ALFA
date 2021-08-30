
import 'package:alfa/utils/Constents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var isAccept = true;

class TermsCondition extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TermsConditionState ();
}


class TermsConditionState extends State<TermsCondition> {
  var terms = '';

  @override
  void initState() {
    Future.delayed(Duration(milliseconds:1),() async {
//      FirebaseAuth.instance.currentUser().then((value) {
//        isAccept = false;
//        setState(() {
//
//        });
//      });

      showLoading(context);
      QuerySnapshot querySnapshot = await Firestore.instance.collection(tblTermsPrivacyAppVersion).getDocuments();
      List<Map<String, dynamic>> arrServiceList = querySnapshot.documents.map((DocumentSnapshot doc) {
        return doc.data;
      }).toList();
      dismissLoading(context);
      terms = arrServiceList[0][kTerms];

      setState(() {

      });
    });

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
          title:Text(
            'Terms and Conditions',
            style:TextStyle(
                fontSize:18,
                fontFamily:AppConstant.kPoppins,
                color:AppConstant.color_blue_dark,
                fontWeight:FontWeight.bold
            ),
          ),
          textTheme:TextTheme(
              title: TextStyle(
                  color: Colors.black
              )
          ),
          centerTitle:false,
          backgroundColor:Colors.white,
          brightness:Brightness.light,
          elevation:0.5,
          leading:IconButton(
              icon:Icon(
                Icons.arrow_back,
                color:Colors.black,
                size:30,
              ),
              onPressed:() {
                Navigator.pop(context);
              })
      ),
      body:Container(
        padding:EdgeInsets.only(left:20,right:20),
        child:SingleChildScrollView(
            padding:EdgeInsets.only(bottom:40,top:20),
            child:Column(
              children: <Widget>[
                Text(
                  terms,
                  style:TextStyle(
                      color:HexColor('#84828F'),
                      fontFamily:AppConstant.kPoppins,
                      fontWeight:FontWeight.normal,
                      fontSize:15
                  ),
                ),
                Visibility(
                  visible:isAccept,
                  child:Container(
                  height:56,
                  margin:EdgeInsets.only(left:30,right:30,top:40),
                  width:MediaQuery.of(context).size.width-60,
                  decoration:kButtonThemeGradientColor(),
                  child:FlatButton(
                    padding:EdgeInsets.all(0),
                    child:Text(
                      'Accept',
                      style:TextStyle(
                          color:Colors.white,
                          fontFamily:AppConstant.kPoppins,
                          fontWeight:FontWeight.normal,
                          fontSize:18
                      ),
                    ),
                    onPressed:() {
                      Navigator.pushNamed(context, '/fitnessgoal');
                    },
                  ),
                ),)
              ],
            )
        ),
      ),
    );
  }
}

