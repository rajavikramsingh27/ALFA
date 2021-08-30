
import 'package:alfa/utils/Constents.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alfa/screen/TermsCondition.dart';


class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingScreenState ();
}



class SettingScreenState extends State<SettingScreen> {
  List arrSettingsTitle = ["FAQ's","Terms of Use","Privacy Policy","App Version"];

  var appVersion = '';

  @override
  void initState() {
    Future.delayed(Duration(milliseconds:1),() async {
//      showLoading(context);
      QuerySnapshot querySnapshot = await Firestore.instance.collection(tblTermsPrivacyAppVersion).getDocuments();
      List<Map<String, dynamic>> arrServiceList = querySnapshot.documents.map((DocumentSnapshot doc) {
        return doc.data;
      }).toList();
//      dismissLoading(context);
      appVersion = arrServiceList[0][kAppVersion];
      setState(() {

      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar:AppBar(
          title:Text(
            'Settings',
            style:TextStyle(
                fontSize:18,
                fontFamily:AppConstant.kPoppins,
                color:AppConstant.color_blue_dark,
                fontWeight:FontWeight.bold
            ),
          ),
          textTheme:TextTheme(
              title: TextStyle(
                  color:Colors.black
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
      body:ListView.builder(
        padding: EdgeInsets.only(top:30),
        scrollDirection:Axis.vertical,
        itemCount:arrSettingsTitle.length,
        itemBuilder:(context, index) {
          return GestureDetector(
            child:Container(
              height:60,
              margin:EdgeInsets.only(left:30,right:30),
              child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        arrSettingsTitle[index],
                        style:TextStyle(
                            fontSize:16,
                            fontFamily:AppConstant.kPoppins,
                            color:AppConstant.color_blue_dark,
                            fontWeight:FontWeight.bold
                        ),
                      ),
                      SizedBox(height:5,),
                      Text(
                        index == arrSettingsTitle.length-1
                            ? appVersion : '',
                        style:TextStyle(
                            fontSize:16,
                            fontFamily:AppConstant.kPoppins,
                            color:HexColor('#84828F'),
                            fontWeight:FontWeight.normal
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size:30,
                    color:AppConstant.color_blue_dark,
                  )
                ],
              ),
            ),
            onTap:() {
              if (index == 0) {
                Navigator.pushNamed(context, '/faq');
              } else if (index == 1) {
                isAccept = false;
                Navigator.pushNamed(context, '/terms');
              } else if (index == 2) {
                Navigator.pushNamed(context, '/PrivacyPolicy');
              }
            },
          );
        },
      ),
    );
  }
}