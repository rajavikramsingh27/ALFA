
import 'dart:ui';

import 'package:alfa/utils/Constents.dart';
import 'package:flutter/material.dart';

import '../res.dart';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';



class ProfileScreenEdit extends StatefulWidget {
  @override
  _ProfileScreenEditState createState() => _ProfileScreenEditState();
}

class _ProfileScreenEditState extends State<ProfileScreenEdit> {
  var isMale = false;
  var isFemale = false;

  var dateOfBirth = 'Date of birth';
  File _image;
  final picker = ImagePicker();

  final textFirstName = TextEditingController();
  final textSecondName = TextEditingController();
  // final textLocation = TextEditingController();
  DateTime picked = null;

  Map<String,dynamic> dictUserDetails = {

  };

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _date = DateTime.now();
     picked = await showDatePicker(
      context: context,
      initialDate:_date,
      firstDate:DateTime(1970),
      lastDate:DateTime(2021),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data:ThemeData.light().copyWith(
//            primaryColor: const Color(0xFF8CE7F1),
//            accentColor: const Color(0xFF8CE7F1),
            colorScheme:ColorScheme.light(primary:HexColor('54C9AF')),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },
    );

    if (picked != null && picked != DateTime.now()) {
      print(picked);

      dateOfBirth = DateFormat('yyyy MMM dd').format(picked);
      setState(() {

      });
    } else {
      dateOfBirth = 'Date of birth';
    }

  }

  Future openCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
      _uploadFile();
    });
  }

  Future openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      _uploadFile();
    });
  }

  Future<void> _uploadFile() async {
    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) async {
      var ref = FirebaseStorage.instance.ref().child('userProfilePicture/').child(value.email+kFireBaseConnect+value.uid);
      var uploadTask = ref.putFile(_image);
      var storageTaskSnapshot = await uploadTask.onComplete;
      var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      Firestore.instance.collection(tblUserDetails).document(value.email+kFireBaseConnect+value.uid).updateData({
        kProfilePicture:downloadUrl
      }).then((value) {
        dismissLoading(context);
        Toast.show(
            'Profile picture updated', context,
            backgroundColor: HexColor(greenColor)
        );
      }).catchError((error) {
        Toast.show(
            error.message.toString(), context,
            backgroundColor: HexColor(redColor));
      });
    }).catchError((error) {
      Toast.show(
          error.message.toString(), context,
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
                    topRight:Radius.circular(20),
                    topLeft:Radius.circular(20)
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
                        'gallery',
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

  @override
  void initState() {
    Future.delayed(Duration(milliseconds:1),() {
      showLoading(context);
      FirebaseAuth.instance.currentUser().then((value) {
        Firestore.instance.collection(tblUserDetails).document(
            value.email + kFireBaseConnect + value.uid).get().then((value) {
          dismissLoading(context);
          dictUserDetails = value.data;
          setState(() {
            textFirstName.text = dictUserDetails[kFirstName];
            textSecondName.text = dictUserDetails[kLastName];
            // textLocation.text = dictUserDetails[kLocation];
            dateOfBirth = dictUserDetails[kDateOfBirth];

            isMale = (dictUserDetails[kGender] == 'Male') ? true : false;
            isFemale = (dictUserDetails[kGender] == 'Female') ? true : false;

            Future.delayed(Duration(milliseconds:5),() {
              // _image = File(dictUserDetails[kProfilePicture]);
            });
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
        backgroundColor:Colors.white,
        appBar:AppBar(
            title:Text(
              'Edit Profile',
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
          margin:EdgeInsets.only(left:30,right:30),
          child:SingleChildScrollView(
            physics:BouncingScrollPhysics(),
            child:Column(
              children: <Widget>[
                SizedBox(height:30,),
                Center(
                  child:FlatButton(
                    textColor:Colors.white,
                    child:ClipRRect(
                        borderRadius:BorderRadius.circular(83),
                        child:_image == null ? FadeInImage(
                          fit:BoxFit.fill,
                          height:90,
                          width:90,
                          image:NetworkImage(
                              dictUserDetails[kProfilePicture].toString()
                          ),
                          placeholder:AssetImage(Res.ic_profile),
                        ) : CircleAvatar(
                          radius:45,
                          backgroundImage:FileImage(_image),
                        )
                    ),
                    onPressed:() {
                      _settingModalBottomSheet(context);
                    },
                  ),
                ),
                SizedBox(height:40,),
                TextField(
                  controller:textFirstName,
                  cursorColor:Color(0xff84828F),
                  decoration:InputDecoration(
                    //labelText: title ,  // you can change this with the top text  like you want
                      labelText: "First name",
                      hintStyle:TextStyle(
                          fontFamily:AppConstant.kPoppins,
                          fontWeight:FontWeight.normal,
                          fontSize:15
                      ),
                      /*border: InputBorder.none,*/
                      fillColor: Color(0xff84828F)
                  ),
                ),
                SizedBox(height:16),
                TextField(
                  controller:textSecondName,
                  cursorColor:Color(0xff84828F),
                  decoration:InputDecoration(
                    //labelText: title ,  // you can change this with the top text  like you want
                      labelText: "Last name",
                      hintStyle:TextStyle(
                          fontFamily:AppConstant.kPoppins,
                          fontWeight:FontWeight.normal,
                          fontSize:15
                      ),
                      /*border: InputBorder.none,*/
                      fillColor: Color(0xff84828F)
                  ),
                ),
                SizedBox(height:16),
                // TextField(
                //   controller:textLocation,
                //   cursorColor:Color(0xff84828F),
                //   decoration:InputDecoration(
                //     //labelText: title ,  // you can change this with the top text  like you want
                //       labelText: "Location",
                //       hintStyle:TextStyle(
                //           fontFamily:AppConstant.kPoppins,
                //           fontWeight:FontWeight.normal,
                //           fontSize:15
                //       ),
                //       /*border: InputBorder.none,*/
                //       fillColor: Color(0xff84828F)
                //   ),
                // ),
                // SizedBox(height:16),
                Container(
                    alignment:Alignment.centerLeft,
                    width:MediaQuery.of(context).size.width,
//                color:Colors.red,
                    child:Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: <Widget>[
                        FlatButton(
                          padding:EdgeInsets.all(0),
                          child:Text(
                            dateOfBirth,
                            style:TextStyle(
                                color:Colors.black,
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:15
                            ),
                          ),
                          onPressed:() {
                            _selectDate(context);
                          },
                        ),
                        Container(
                          height:1,
                          color:HexColor('84828F'),
                        )
                      ],
                    )
                ),
                SizedBox(height:30),
                Container(
                  width:MediaQuery.of(context).size.width,
                  alignment:Alignment.centerLeft,
                  child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Gender',
                        style:TextStyle(
                            fontFamily:AppConstant.kPoppins,
                            fontWeight:FontWeight.normal,
                            fontSize:15
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          FlatButton(
                            padding:EdgeInsets.only(left: 0),
                            textColor:Colors.white,
                            child:Row(
                              children: <Widget>[
                                Image.asset(
                                  isMale ? Res.ic_male : Res.maleUnselectet,
                                  height:40,
                                ),
                                SizedBox(width:16),
                                Text(
                                  'Male',
                                  style:TextStyle(
                                      color:HexColor('#000000'),
                                      fontFamily:AppConstant.kPoppins,
                                      fontWeight:FontWeight.normal,
                                      fontSize:16
                                  ),
                                )
                              ],
                            ),
                            onPressed:(){
                              setState(() {
                                isMale = true;
                                isFemale = false;
                              });
                            },
                          ),
                          FlatButton(
                            textColor:Colors.white,
                            child:Row(
                              children: <Widget>[
                                Image.asset(
                                  isFemale ? Res.ic_female : Res.femaleUnselected,
//                                Res.femaleUnselected,
                                  height:40,
                                ),
                                SizedBox(width:16),
                                Text(
                                  'Female',
                                  style:TextStyle(
                                      color:HexColor('#000000'),
                                      fontFamily:AppConstant.kPoppins,
                                      fontWeight:FontWeight.normal,
                                      fontSize:16
                                  ),
                                )
                              ],
                            ),
                            onPressed:(){
                              setState(() {
                                isMale = false;
                                isFemale = true;
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height:60),
                Container(
                  height:56,
                  width:MediaQuery.of(context).size.width,
                  decoration:kButtonThemeGradientColor(),
                  child:FlatButton(
                    padding:EdgeInsets.all(0),
                    child:Text(
                      'Update',
                      style:TextStyle(
                          color:Colors.white,
                          fontFamily:AppConstant.kPoppins,
                          fontWeight:FontWeight.normal,
                          fontSize:18
                      ),
                    ),
                    onPressed:() {
                      if (_image == null) {
                        Toast.show('Select profile picture', context,
                            duration: 2,
                            gravity: Toast.BOTTOM,
                            backgroundColor: HexColor(redColor));
                      } else if (textFirstName.text.isEmpty) {
                        Toast.show('Enter first name', context,
                            duration: 2,
                            gravity: Toast.BOTTOM,
                            backgroundColor: HexColor(redColor));
                      } else if (textSecondName.text.isEmpty) {
                        Toast.show('Enter second name', context,
                            duration: 2,
                            gravity: Toast.BOTTOM,
                            backgroundColor: HexColor(redColor));
                      }

                      // else if (textLocation.text.isEmpty) {
                      //   Toast.show('Select your location', context,
                      //       duration: 2,
                      //       gravity: Toast.BOTTOM,
                      //       backgroundColor: HexColor(redColor));
                      // }

                      else if (dateOfBirth == 'Date of birth') {
                        Toast.show('Select date of birth', context,
                            duration: 2,
                            gravity: Toast.BOTTOM,
                            backgroundColor: HexColor(redColor));
                      } else if (!isMale && !isFemale) {
                        Toast.show('Select your gender', context,
                            duration: 2,
                            gravity: Toast.BOTTOM,
                            backgroundColor: HexColor(redColor));
                      } else {
                        showLoading(context);
                        FirebaseAuth.instance.currentUser().then((value) {
                          Firestore.instance.collection(tblUserDetails).document(value.email+kFireBaseConnect+value.uid).updateData({
                            kFirstName:textFirstName.text,
                            kLastName:textSecondName.text,
                            kLocation:'',
                            // textLocation.text,
                            kDateOfBirth:dateOfBirth,
                            kGender:isMale ? 'Male' : 'Female'
                          }).then((value) {
                            dismissLoading(context);
                            Toast.show(
                                'Updated!',
                                context,
                                duration:2,
                                gravity:Toast.BOTTOM,
                                backgroundColor:HexColor(greenColor));
                          }).catchError((error) {
                            dismissLoading(context);
                            Toast.show(
                                error.message.toString(),
                                context,
                                duration:2,
                                gravity:Toast.BOTTOM,
                                backgroundColor:HexColor(redColor));
                          });
                        }).catchError((error) {
                          dismissLoading(context);
                          Toast.show(
                              error.message.toString(),
                              context,
                              duration:2,
                              gravity:Toast.BOTTOM,
                              backgroundColor:HexColor(redColor));
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height:30),
              ],
            ),
          ),
        )
    );
  }

}

/*
child:Container(
                                    margin:EdgeInsets.only(top:30),
                                    height:166,
                                    width:166,
                                    decoration:BoxDecoration(
                                      color:Colors.white,
                                      borderRadius:BorderRadius.circular(83),
                                      boxShadow:[
                                        BoxShadow(
                                          color:Colors.grey.withOpacity(0.5),
                                          spreadRadius:2,
                                          blurRadius:10,
                                          offset: Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child:
                                    _image == null
                                        ? Image.asset(userPerson, height:90, width:90,)
                                        : CircleAvatar(backgroundImage:FileImage(_image), radius:45.0),
                                  ),
 */
