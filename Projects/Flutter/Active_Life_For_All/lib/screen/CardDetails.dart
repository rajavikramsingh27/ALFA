import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:alfa/res.dart';
import 'package:toast/toast.dart';
import 'package:dart_notification_center/dart_notification_center.dart';


Map<String,dynamic> dictSelectedDetails;

class CardDetails extends StatefulWidget {
  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  _settingModalBottomSheet(context,) {
    showModalBottomSheet(
        backgroundColor:Colors.transparent,
        context: context,
        builder:(BuildContext bc) {
          return Container(
              height:360,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius:BorderRadius.only(
                    topRight:Radius.circular(30),
                    topLeft:Radius.circular(30)
                ),
//              border: Border.all(width:3,color: Colors.green,style: BorderStyle.solid)
              ),
              child:Center(
                child:Column(
                  children:<Widget>[
                    SizedBox(height:40),
                    Text(
                      'Remove Card',
                      style:TextStyle(
                          fontSize:22,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.bold
                      ),
                    ),
                    SizedBox(height:20),
                    Image.asset(
                      Res.deleteCard,
                      height:56,
                      width:52,
                    ),
                    SizedBox(height:28),
                    Text(
                      'Are your sure! \nYour want to remove your Card?',
                      textAlign:TextAlign.center,
                      style:TextStyle(
                          fontSize:14,
                          fontFamily:AppConstant.kPoppins,
                          color:HexColor('#84828F'),
                          fontWeight:FontWeight.normal
                      ),
                    ),
                    SizedBox(height:25),
                    Container(
                      margin:EdgeInsets.only(left:25,right: 25),
                      child:Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            padding:EdgeInsets.all(0),
                            child:Container(
                              alignment:Alignment.center,
                              height:56,
                              width:MediaQuery.of(context).size.width/2-40,
                              child:Text(
                                'Cancel',
                                textAlign:TextAlign.center,
                                style:TextStyle(
                                    fontSize:16,
                                    fontFamily:AppConstant.kPoppins,
                                    color:Colors.white,
                                    fontWeight:FontWeight.bold
                                ),
                              ),
                              decoration:BoxDecoration(
                                  color:AppConstant.color_blue_dark,
                                  borderRadius:BorderRadius.circular(14)
                              ),
                            ),
                            onPressed:() {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            padding:EdgeInsets.all(0),
                            child:Container(
                              alignment:Alignment.center,
                              height:56,
                              width:MediaQuery.of(context).size.width/2-40,
                              child:Text(
                                'Yes',
                                textAlign:TextAlign.center,
                                style:TextStyle(
                                    fontSize:16,
                                    fontFamily:AppConstant.kPoppins,
                                    color:Colors.white,
                                    fontWeight:FontWeight.bold
                                ),
                              ),
                              decoration:BoxDecoration(
                                  color:HexColor('#54C9AF'),
                                  borderRadius:BorderRadius.circular(14)
                              ),
                            ),
                            onPressed:() {
                              Navigator.pop(context);

                              showLoading(context);
                              FirebaseAuth.instance.currentUser().then((value) {
                                Firestore.instance.collection(tblPaymentCards)
                                    .document(value.email+kFireBaseConnect+value.uid)
                                    .collection(value.uid)
                                    .document(dictSelectedDetails[kCreatedTime]).delete()
                                .then((value) {
                                  dismissLoading(context);
                                  DartNotificationCenter.post(
                                    channel:tblPaymentCards,
                                    options:'',
                                  );
                                  Toast.show(
                                      'Payment card is deleted successfully.',
                                      context,
                                      backgroundColor: HexColor(greenColor));
                                  Navigator.pop(context);
                                }).catchError((error) {
                                  dismissLoading(context);
                                  Toast.show(
                                      error.message.toString(),
                                      context,
                                      backgroundColor: HexColor(greenColor));
                                });
                              }).catchError((error) {
                                dismissLoading(context);
                                Toast.show(
                                    error.message.toString(), context,
                                    backgroundColor: HexColor(greenColor));
                              });
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar:AppBar(
          title:Text(
            'Card Details',
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
              }),
      ),
      body:Container(
        margin:EdgeInsets.all(40),
        child:Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset(
                  Res.cardBG,
                ),
                Positioned(
                  top:0,
                  bottom:0,
                  left:16,
                  right:16,
                  child:Container(
                    height:150,
                    width:210,
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dictSelectedDetails[kCardName],
                          style:TextStyle(
                              fontSize:16,
                              fontFamily:AppConstant.kPoppins,
                              color:Colors.white,
                              fontWeight:FontWeight.normal
                          ),
                        ),
                        SizedBox(height:13),
                        Text(
                          dictSelectedDetails[kCardNumber],
                          style:TextStyle(
                              fontSize:16,
                              fontFamily:AppConstant.kPoppins,
                              color:Colors.white,
                              fontWeight:FontWeight.bold
                          ),
                        ),
                        SizedBox(height:13),
                        Container(
                          alignment:Alignment.centerRight,
                          child: Image.asset(
                            Res.visaLogo,
                            height:16,
                            width:54,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height:40,),
            Container(
                decoration:BoxDecoration(
                  color:HexColor('#C1C1C1'),
                  borderRadius:BorderRadius.circular(16)
                ),
                height:56,
                width:300,
//                margin:EdgeInsets.only(left:30,right:30),
                child:FlatButton(
                  textColor:Colors.white,
                  child:Text(
                    'Remove Card',
                    style:TextStyle(
                        fontSize:18,
                        fontFamily:AppConstant.kPoppins,
                        color:Colors.white,
                        fontWeight:FontWeight.normal
                    ),
                  ),
                  onPressed:() {
                    _settingModalBottomSheet(context);
                  },
                )
            ),
          ],
        ),
      )
    );
  }
}
