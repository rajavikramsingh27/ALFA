import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final textFeedbackTitle = TextEditingController();
  final textFeedBackDesc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.white,
        appBar:AppBar(
            title:Text(
              'Feedback',
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
          margin:EdgeInsets.only(left:20,right:20),
          child:SingleChildScrollView(
            physics:BouncingScrollPhysics(),
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height:30,),
                Text(
                  'Feeback title',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:14),
                TextFormField(
                  controller:textFeedbackTitle,
                  textAlign: TextAlign.left,
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w400
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter feedback title',
                    contentPadding:EdgeInsets.only(left:16,right:16),
                    border:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(10),
                    ),
                    focusedBorder:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10),
                        borderSide:BorderSide(color:HexColor('#CECECE'))
                    ),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                    disabledBorder:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10),
                        borderSide:BorderSide(color:HexColor('#CECECE'))
                    ),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Text is empty';
                    }
                    return null;
                  },
                ),
                SizedBox(height:30,),
                Text(
                  'Feedback Description',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:14),
                Container(
                  height:200,
                  child:TextFormField(
                    controller:textFeedBackDesc,
                    textInputAction:TextInputAction.done,
                    textAlign: TextAlign.left,
                    maxLines:10,
                    onChanged:(text) {
                      print(text);
                    },
                    style:TextStyle(
                        fontSize:16,
                        fontFamily:AppConstant.kPoppins,
                        color:AppConstant.color_blue_dark,
                        fontWeight:FontWeight.w400
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter feedback description',
                      contentPadding:EdgeInsets.only(left:16,right:16,top:16,bottom:16),
                      border:OutlineInputBorder(
                          borderRadius:BorderRadius.circular(10),
                          borderSide:BorderSide(color:HexColor('#CECECE'))
                      ),
                      focusedBorder:OutlineInputBorder(
                          borderRadius:BorderRadius.circular(10),
                          borderSide:BorderSide(color:HexColor('#CECECE'))
                      ),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
//                    disabledBorder: InputBorder.none,
                    ),

                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height:70),
                FlatButton(
                  textColor:Colors.white,
                  child:Container(
                    height:56,
                    width:double.infinity,
                    margin:EdgeInsets.only(left:20,right:20),
                    padding:EdgeInsets.only(left:20,right:20),
                    decoration:kButtonThemeGradientColor(),
                    alignment:Alignment.center,
                    child:Text(
                      'Send',
                      style:TextStyle(
                          fontSize:18,
                          fontFamily:AppConstant.kPoppins,
                          color:Colors.white,
                          fontWeight:FontWeight.normal
                      ),
                    ),
                  ),
                  onPressed:() {
                    if (textFeedbackTitle.text.isEmpty) {
                      Toast.show(
                      'Enter your feedback title',
                        context,
                        backgroundColor:HexColor(redColor)
                      );
                    } else if (textFeedBackDesc.text.isEmpty) {
                      Toast.show(
                          'Enter your feedback description',
                          context,
                          backgroundColor:HexColor(redColor)
                      );
                    } else {
                      showLoading(context);
                      FirebaseAuth.instance.currentUser().then((value) {
                        Firestore.instance
                            .collection(tblFeedback)
                            .document(value.email+kFireBaseConnect+DateTime.now().millisecondsSinceEpoch.toString())
                            .setData({
                          kFeedbackTitle:textFeedbackTitle.text,
                          kFeedbackDescription:textFeedBackDesc.text
                        }).catchError((error) {
                          Toast.show(
                              error.message.toString(), context,
                              backgroundColor: HexColor(redColor));
                        }).then((value) {
                          dismissLoading(context);
                          Navigator.pop(context);
                          Toast.show('Feedback updated successfully.', context,
                              backgroundColor: HexColor(greenColor));
                        });
                      }).catchError((error) {
                        Toast.show(
                            error.message.toString(), context,
                            backgroundColor: HexColor(redColor));
                      });
                    }
                  },
                )
              ],
            ),
          ),
        )
    );
  }
}
