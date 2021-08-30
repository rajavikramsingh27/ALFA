import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {

  var privacyPolicy = '';

  @override
  void initState() {
    Future.delayed(Duration(milliseconds:1),() async {
      showLoading(context);
      QuerySnapshot querySnapshot = await Firestore.instance.collection(tblTermsPrivacyAppVersion).getDocuments();
      List<Map<String, dynamic>> arrServiceList = querySnapshot.documents.map((DocumentSnapshot doc) {
        return doc.data;
      }).toList();
      dismissLoading(context);
      privacyPolicy = arrServiceList[0][kPrivacyPolicy];
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
            'Privacy Policy',
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
            padding:EdgeInsets.only(top:20,bottom:20,),
            child:Text(
              privacyPolicy,
              style:TextStyle(
                  color:HexColor('#84828F'),
                  fontFamily:AppConstant.kPoppins,
                  fontWeight:FontWeight.normal,
                  fontSize:15
              ),
            ),
        ),
      ),
    );
  }
}
