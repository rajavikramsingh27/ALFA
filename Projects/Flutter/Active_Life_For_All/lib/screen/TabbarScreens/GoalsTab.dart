import 'dart:io';
import 'package:alfa/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class GoalsTab extends StatefulWidget {
  @override
  _GoalsTabState createState() => _GoalsTabState();
}

class _GoalsTabState extends State<GoalsTab> {
  bool isImage = false;
  File _image;
  final picker = ImagePicker();
  var textGoalsDescription = TextEditingController();
  String strImage = '';
  String formattedDate = '';


  Future openCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    isImage = true;
    setState(() {
      _image = File(pickedFile.path);
      _uploadFile();
    });
  }

  Future openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    isImage = true;

    setState(() {
      _image = File(pickedFile.path);
      _uploadFile();
    });
  }

  Future<void> _uploadFile() async {
    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) async {
      var ref = FirebaseStorage.instance.ref().child(kGoalPhoto).child(value.email+kFireBaseConnect+value.uid);
      var uploadTask = ref.putFile(_image);
      var storageTaskSnapshot = await uploadTask.onComplete;
      var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      Firestore.instance.collection(tblGoals).document(value.email+kFireBaseConnect+value.uid).collection(formattedDate).document(formattedDate)
          .updateData({
        kGoalsPicture:downloadUrl,
      }).then((value) {
        dismissLoading(context);
        Toast.show(
            'Goal photo updated.',
            context,
            backgroundColor: HexColor(greenColor)
        );
      }).catchError((error) {
        Toast.show(error.message.toString(), context,
            backgroundColor: HexColor(redColor));
      });
    }).catchError((error) {
      Toast.show(error.message.toString(), context,
          backgroundColor: HexColor(redColor));
    });
  }

  Future<void> updateGoalDescription() async {
    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) async {
      Firestore.instance.collection(tblGoals).document(value.email+kFireBaseConnect+value.uid).collection(formattedDate).document(formattedDate)
          .updateData({
        kGoalsDescription:textGoalsDescription.text
      }).then((value) {
        dismissLoading(context);
        Toast.show(
            'Goal description updated.',
            context,
            backgroundColor: HexColor(greenColor)
        );
      }).catchError((error) {
        Toast.show(error.message.toString(), context,
            backgroundColor: HexColor(redColor));
      });
    }).catchError((error) {
      Toast.show(error.message.toString(), context,
          backgroundColor: HexColor(redColor));
    });
  }

  _settingModalBottomSheet(context,) {
    showModalBottomSheet(
        backgroundColor:Colors.transparent,
        context: context,
        builder:(BuildContext bc) {
          return Container(
              height:280,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(
                    topRight:  Radius.circular(20),
                    topLeft:  Radius.circular(20)
                ),
//              border: Border.all(width:3,color: Colors.green,style: BorderStyle.solid)
              ),
              child:Center(
                child:Column(
                  children:<Widget>[
                    SizedBox(height:30),
                    Text(
                      'Please select an option',
                      style:TextStyle(
                          fontSize:18,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.bold
                      ),
                    ),
                    SizedBox(height:10),
                    FlatButton(
                      child:Text(
                        'Camera',
                        style:TextStyle(
                            fontSize:16,
                            fontFamily:AppConstant.kPoppins,
                            color:AppConstant.color_blue_dark,
                            fontWeight:FontWeight.normal
                        ),
                      ),
                      onPressed:() {
                        Navigator.pop(context);
                        openCamera();
                      },
                    ),
                    FlatButton(
                      child:Text(
                        'Gallery',
                        style:TextStyle(
                            fontSize:16,
                            fontFamily:AppConstant.kPoppins,
                            color:AppConstant.color_blue_dark,
                            fontWeight:FontWeight.normal
                        ),
                      ),
                      onPressed:() {
                        Navigator.pop(context);
                        openGallery();
                      },
                    ),
                    SizedBox(height:30,),
                    FlatButton(
                      child:Text(
                        'Cancel',
                        style:TextStyle(
                            fontSize:18,
                            fontFamily:AppConstant.kPoppins,
                            color:Colors.red,
                            fontWeight:FontWeight.normal
                        ),
                      ),
                      onPressed:() {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              )
          );
        }
    );
  }

  setGoals() {
    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) {
      Firestore.instance
          .collection(tblGoals)
          .document(value.email + kFireBaseConnect + value.uid).collection(formattedDate).document(formattedDate)
          .setData({
        kGoalsPicture:'',
        kGoalsDescription:'',
        kDailyGoalsCheckIn:'',
        kWeeklyGoalsTracker:'',
      }).then((value) {
        dismissLoading(context);
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

  @override
  void initState() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy_MMM_dd');
    formattedDate = formatter.format(now);

    Future.delayed(Duration(milliseconds:5),() {
      FirebaseAuth.instance.currentUser().then((value) {
        Firestore.instance.collection(tblGoals).document(value.email + kFireBaseConnect + value.uid).collection(formattedDate).document(formattedDate)
            .get().then((value) {
          value.data;
          if (value.data == null) {
            setGoals();
          } else {
            textGoalsDescription.text = value.data[kGoalsDescription];
            strImage = value.data[kGoalsPicture];

            if (strImage.isNotEmpty) {
              isImage = true;
            }
          }
          setState(() {

          });
        }).catchError((error) {
          print(error.toString());
          Toast.show(
              error.message.toString(),
              context,
              backgroundColor:HexColor(redColor)
          );
        });
      }).then((value) {

      }).catchError((error) {
        print(error.toString());
        Toast.show(
          error.message.toString(),
          context,
          backgroundColor:HexColor(redColor)
        );
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar:PreferredSize(
        preferredSize:Size.fromHeight(0),
        child:AppBar(
          elevation:0,
          backgroundColor:Colors.white,
          brightness:Brightness.light,
        ),
      ),
      body:SafeArea(
        child:Stack(
          children: <Widget>[
            Container(
              padding:EdgeInsets.only(left:30,right:30,top:30),
              decoration:BoxDecoration(
                border:Border(
                  bottom: BorderSide(
                      width:0.4,
                      color:HexColor('#BEBEBE')
                  ),
                )
              ),
              child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Text(
                    'Goals',
                    style:TextStyle(
                        color:Colors.black,
                        fontFamily:AppConstant.kPoppins,
                        fontWeight:FontWeight.bold,
                        fontSize:30
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child:Container(
                margin:EdgeInsets.only(top:78),
                child:SingleChildScrollView(
                  padding:EdgeInsets.only(top:10,bottom:30),
//                  physics:BouncingScrollPhysics(),
                  child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:<Widget>[
                      Padding(
                        padding:EdgeInsets.only(left:30,right:30),
                        child:Stack(
                          children: <Widget>[
                            FlatButton(
                              padding:EdgeInsets.all(0),
                              onPressed:() {
                                _settingModalBottomSheet(context);
                              },
                              child:isImage
                                  ? Container(
                                decoration:BoxDecoration(
                                    color:AppConstant.colorAccent.withOpacity(0.2),
                                    borderRadius:BorderRadius.circular(23)
                                ),
                                child:ClipRRect(
                                    borderRadius:BorderRadius.circular(23),
                                    child:_image == null
                                        ? FadeInImage(
                                      fit:BoxFit.fill,
                                      height:300,
                                      width:double.infinity,
                                      image:NetworkImage(strImage),
                                      placeholder:AssetImage(''),
                                    ) : Container(
                                      height:300,
                                      width:double.infinity,
                                      decoration:BoxDecoration(
                                        image:DecorationImage(
                                            fit:BoxFit.fill,
                                          image:FileImage(_image)
                                        )
                                      ),
                                    )
                                ),
                              )
                                  : Container(
                                height:300,
                                width:double.infinity,
                                margin:EdgeInsets.only(left:0,right:0,top:0),
                                decoration:BoxDecoration(
                                    color:Colors.white,
                                    border:Border.all(
                                        color:HexColor('#BEBEBE'),
                                        width:1
                                    ),
                                    borderRadius:BorderRadius.circular(20)
                                ),
                                child:Column(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  crossAxisAlignment:CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      Res.add_Image,
                                      height:46,
                                    ),
                                    SizedBox(height:12),
                                    Text(
                                      'Upload Your Goal Photo',
                                      style:TextStyle(
                                          fontSize:16,
                                          fontFamily:AppConstant.kPoppins,
                                          color:HexColor('#84828F'),
                                          fontWeight:FontWeight.w600
                                      ),
                                    ),
                                    SizedBox(height:12),
                                    Text(
                                      '(This Should Be An Image That \nInspires You To Achieve Your Goal)',
                                      style:TextStyle(
                                          fontSize:14,
                                          fontFamily:AppConstant.kPoppins,
                                          color:HexColor('#84828F'),
                                          fontWeight:FontWeight.normal
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                      SizedBox(height:30),
                      Container(
                        margin:EdgeInsets.only(left:30,right:30),
                        height:100,
                        child:TextFormField(
                          controller:textGoalsDescription,
                          textInputAction:TextInputAction.done,
                          keyboardAppearance:Brightness.light,
                          textAlign: TextAlign.left,
                          maxLines:6,
                          onFieldSubmitted:(_) {
                            updateGoalDescription();
                          },
                          style:TextStyle(
                              fontSize:14,
                              fontFamily:AppConstant.kPoppins,
                              color:AppConstant.color_blue_dark,
                              fontWeight:FontWeight.normal
                          ),
                          decoration: InputDecoration(
                            hintText: 'The reason i want to achieve this goal is....',
                            contentPadding:EdgeInsets.only(left:16,right:16,top:20),
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
                        ),
                      ),
                      SizedBox(height:30),
                      Container(
                        decoration:kGoalButtonThemeGradientColor(),
                        margin:EdgeInsets.only(left:30,right:30),
                        width:double.infinity,
                        height:54,
                        child:FlatButton(
                          textColor:Colors.white,
                          child:Text(
                            'Daily Goal Check In',
                            style:TextStyle(
                                fontSize:18,
                                fontFamily:AppConstant.kPoppins,
                                color:Colors.white,
                                fontWeight:FontWeight.normal
                            ),
                          ),
                          onPressed:() {
                            Navigator.pushNamed(context, '/DailyGoalCheckIn');
                          },
                        ),
                      ),
                      SizedBox(height:30),
                      Container(
                        decoration:kGoalButtonThemeGradientColor(),
                        margin:EdgeInsets.only(left:30,right:30),
                        width:double.infinity,
                        height:54,
                        child:FlatButton(
                          textColor:Colors.white,
                          child:Text(
                            'Weekly Progress Tracker',
                            style:TextStyle(
                                fontSize:18,
                                fontFamily:AppConstant.kPoppins,
                                color:Colors.white,
                                fontWeight:FontWeight.normal
                            ),
                          ),
                          onPressed:() {
                            Navigator.pushNamed(context, '/WeeklyProgressTracker');
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            )
          ],
        )
      )
    );
  }
}

