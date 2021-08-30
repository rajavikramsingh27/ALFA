import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_notification_center/dart_notification_center.dart';


class YourQuote extends StatefulWidget {
  @override
  _YourQuoteState createState() => _YourQuoteState();
}



class _YourQuoteState extends State<YourQuote> {
  final textName = TextEditingController();
  final textSocialMediaType = TextEditingController();
  final textQuotes = TextEditingController();

  shareYourQuotes() {
    String timeForID = DateTime.now().microsecondsSinceEpoch.toString();

    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) => {
      Firestore.instance.collection(tblQuotes).document(value.email+'_'+timeForID).setData({
        kID:timeForID,
        kDocID:value.email+'_'+timeForID,
        kName:textName.text,
        kSocialType:textSocialMediaType.text,
        kQuotes:textQuotes.text
      }).then((value) {
        dismissLoading(context);

        Toast.show(
            'Your Quotes has submitted successfully.',
            context,
            backgroundColor:HexColor(greenColor)
        );
        Future.delayed(Duration(milliseconds:1),() async {
          Navigator.pop(context);
          DartNotificationCenter.post(
            channel:tblQuotes,
            options: '',
          );
        });
      }).catchError((error) {
        dismissLoading(context);
        Toast.show(
            error.message.toString(),
            context,
            backgroundColor: HexColor(redColor)
        );
      })
    }).catchError((error) {
      dismissLoading(context);
      Toast.show(
          error.message.toString(),
          context,
          backgroundColor: HexColor(redColor)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar:AppBar(
          title:Text(
            'Share your quote with us',
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
                'Your Social Media Name',
                style:TextStyle(
                    fontSize:16,
                    fontFamily:AppConstant.kPoppins,
                    color:AppConstant.color_blue_dark,
                    fontWeight:FontWeight.w600
                ),
              ),
              SizedBox(height:14),
              TextFormField(
                controller:textName,
                textAlign: TextAlign.left,
                style:TextStyle(
                    fontSize:16,
                    fontFamily:AppConstant.kPoppins,
                    color:AppConstant.color_blue_dark,
                    fontWeight:FontWeight.w400
                ),
                decoration: InputDecoration(
                  hintText: 'Enter Name @activelifeforall',
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
                'Social Media Type',
                style:TextStyle(
                    fontSize:16,
                    fontFamily:AppConstant.kPoppins,
                    color:AppConstant.color_blue_dark,
                    fontWeight:FontWeight.w600
                ),
              ),
              SizedBox(height:14),
              TextFormField(
                controller:textSocialMediaType,
                textAlign: TextAlign.left,
                style:TextStyle(
                    fontSize:16,
                    fontFamily:AppConstant.kPoppins,
                    color:AppConstant.color_blue_dark,
                    fontWeight:FontWeight.w400
                ),
                decoration: InputDecoration(
                  hintText: 'Social Media Type (FB, Instagram, Twitter, etc...)',
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
                'Share your quote with us',
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
                  controller:textQuotes,
                  textInputAction:TextInputAction.done,
                  textAlign: TextAlign.left,
                  maxLines:10,
                  maxLength:70,
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
                    hintText: 'Enter Your Quote',
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
                    'Share',
                    style:TextStyle(
                        fontSize:18,
                        fontFamily:AppConstant.kPoppins,
                        color:Colors.white,
                        fontWeight:FontWeight.normal
                    ),
                  ),
                ),
                onPressed:() {
                  if (textName.text.isEmpty) {
                    Toast.show(
                        'Enter Name',
                        context,
                        duration: 2,
                        gravity:Toast.BOTTOM,
                        backgroundColor: HexColor(redColor));
                  } else if (textSocialMediaType.text.isEmpty) {
                    Toast.show('Enter your social media type.',
                        context,
                        duration: 2,
                        gravity:Toast.BOTTOM,
                        backgroundColor: HexColor(redColor));
                  } else if (textQuotes.text.isEmpty) {
                    Toast.show('Enter your quotes',
                        context,
                        duration: 2,
                        gravity:Toast.BOTTOM,
                        backgroundColor: HexColor(redColor));
                  } else {
                    shareYourQuotes();
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
