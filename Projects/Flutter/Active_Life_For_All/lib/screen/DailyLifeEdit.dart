import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';


class DailyLifeEdit extends StatefulWidget {
  @override
  _DailyLifeEditState createState() => _DailyLifeEditState();
}

class _DailyLifeEditState extends State<DailyLifeEdit> {

  var indexSelected = -1;

  List<Map<String, dynamic>> arrActiveDailyLife = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds:1),() async {
      QuerySnapshot querySnapshot = await Firestore.instance.collection(tblActiveDailyLife).getDocuments();
      arrActiveDailyLife = querySnapshot.documents.map((DocumentSnapshot doc) {
        return doc.data;
      }).toList();
      showLoading(context);

      FirebaseAuth.instance.currentUser().then((value) {
        Firestore.instance.collection(tblUserDetails).document(
            value.email + kFireBaseConnect + value.uid).get().then((value) {
          dismissLoading(context);
          for (var i = 0; i < arrActiveDailyLife.length; i++) {
            if (arrActiveDailyLife[i][kTitle] ==  value.data[kActiveDailyLife]) {
              indexSelected = i;
              break;
            }
          }

          setState(() {

          });
        }).catchError((error) {
          dismissLoading(context);
          Toast.show(
              error.message.toString(),
              context,
              backgroundColor: HexColor(redColor)
          );
        }).catchError((error) {
          dismissLoading(context);
          Toast.show(
              error.message.toString(),
              context,
              backgroundColor: HexColor(redColor)
          );
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        bottom:false,
        child:Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
                decoration:BoxDecoration(
                    border:Border(
                      bottom: BorderSide(
                          width:0.4,
                          color:HexColor('#BEBEBE')
                      ),
                    )
                ),
                padding:EdgeInsets.only(left:5,top:5,bottom:10),
                alignment:Alignment.centerLeft,
                child:Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        icon:Icon(
                          Icons.arrow_back,
                          color:Colors.black,
                          size:30,
                        ),
                        onPressed:() {
                          Navigator.pop(context);
                        }),
                    SizedBox(width:5),
                    Text(
                      'How Active Are You In \nYour Daily Life?',
                      style:TextStyle(
                          fontSize:22,
                          fontFamily: AppConstant.kPoppins,
                          color: AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w700
                      ),
                    ),
                  ],
                )
            ),
            SafeArea(
              child:Container(
                margin:EdgeInsets.only(top:0),
                height:MediaQuery.of(context).size.height-151
                    -MediaQuery.of(context).padding.bottom,
                child:ListView.builder(
                  padding:EdgeInsets.only(bottom:20+MediaQuery.of(context).padding.bottom),
                  scrollDirection:Axis.vertical,
                  itemCount:arrActiveDailyLife.length+1,
                  itemBuilder:(context, index) {
                    if (index == arrActiveDailyLife.length) {
                      return Container(
                        height:54,
                        margin:EdgeInsets.only(top:35,left:35,right:35),
                        width:MediaQuery.of(context).size.width-90,
                        decoration:(indexSelected > -1)
                            ? kButtonThemeGradientColor()
                            : BoxDecoration(
                            color:HexColor('#C1C1C1'),
                            borderRadius:BorderRadius.circular(14)
                        ),
                        child:FlatButton(
                          padding:EdgeInsets.all(0),
                          child:Text(
                            'Finish',
                            style:TextStyle(
                                color:Colors.white,
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16
                            ),
                          ),
                          onPressed:() {
                            showLoading(context);
                            FirebaseAuth.instance.currentUser().then((value) {
                              Firestore.instance.collection(
                                  tblUserDetails).document(value.email+kFireBaseConnect+value.uid).updateData({
                                kFitnessGoal:arrActiveDailyLife[indexSelected][kTitle]
                              }).then((value) {
                                dismissLoading(context);
                                Toast.show(
                                   'Updated!',
                                    context,
                                    backgroundColor:HexColor(greenColor)
                                );
                              }).catchError((error) {
                                dismissLoading(context);
                                Toast.show(
                                    error.message.toString(),
                                    context,
                                    backgroundColor:HexColor(redColor)
                                );
                              });
                            });
                          },
                        ),
                      );
                    } else {
                      return GestureDetector(
                          child:Container(
//                                height:80,
                              margin:EdgeInsets.only(left:16,right: 16,top:20),
                              padding:EdgeInsets.only(left:20,right:10),
                              width:double.infinity,
                              decoration: (index == indexSelected)
                                  ? kFitnessThemeGradientColor()
                                  : BoxDecoration(
                                  color:Colors.white,
                                  border: Border.all(color: Color(0xff54C9AF)),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height:14),
                                  Text(
                                    arrActiveDailyLife[index][kTitle],
                                    style:TextStyle(
                                        fontSize:18,
                                        fontFamily: AppConstant.kPoppins,
                                        color: (index == indexSelected)
                                            ? Colors.white
                                            : AppConstant.color_blue_dark,
                                        fontWeight:FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(height:4,),
                                  Text(
                                    arrActiveDailyLife[index][kSubtitle],
                                    style:TextStyle(
                                        fontSize:12,
                                        fontFamily:AppConstant.kPoppins,
                                        color:(index == indexSelected)
                                            ? Colors.white
                                            : HexColor('#84828F'),
                                        fontWeight:FontWeight.normal
                                    ),
                                  ),
                                  SizedBox(height:14),
                                ],
                              )
                          ),
                          onTap:() {
                            indexSelected = index;
                            setState(() {

                            });
                          }
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
