import 'package:alfa/screen/WorkoutDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:alfa/res.dart';
import 'package:g2x_week_calendar/g2x_simple_week_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import '../res.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';



class SetWorkouts extends StatefulWidget {
  @override
  _SetWorkoutsState createState() => _SetWorkoutsState();
}

class _SetWorkoutsState extends State<SetWorkouts> {
  String strName = '';
  String strExerciseName = '';
  String strTitleBody = '';
  String strParamTitle = '';
  String strUpper_body = '';
  String strCore_cardio = '';
  String strFull_body = '';
  String strLower_body = '';

  Map<String, dynamic> dictLive = {kLink:'',kThumbnail:'',kLiveOn:''};
  Map<String, dynamic> dictWorkoutOfTheDay = {kLink:'',kThumbnail:'',kLiveOn:''};

  String downloadUrl = '';
  String formattedDate = '';

  String strThumbnail = 'Thumbnail';
  File _image;
  final picker = ImagePicker();

  bool isPopUpVisible = false;
  bool isPopUpVisibleLinks = false;
  bool isThumbnail = false;

  DateTime setDate;

  TextEditingController txtLink = TextEditingController();
  TextEditingController txtLiveOn = TextEditingController();

  TextEditingController txtLink_1 = TextEditingController();
  TextEditingController txtLink_2 = TextEditingController();
  TextEditingController txtLink_3 = TextEditingController();
  TextEditingController txtLink_4 = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<Map<String, dynamic>> arrQuotes = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds:1),() async {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy_MMM_dd');
      formattedDate = formatter.format(now);

      getData();
//      getExercises(formattedDate);
    });
    // TODO: implement initState
    super.initState();
  }

  setExercise(String strExercise) {
    var arrString = strExercise
        .split('~~')                       // split the text into an array
        .map((text) => (text)) // put the text inside a widget
        .toList();
//    print(arrString);

    if (arrString.length > 0) {
      txtLink_1.text = arrString[0];
    }
    if (arrString.length > 1) {
      txtLink_2.text = arrString[1];
    }
    if (arrString.length > 2) {
      txtLink_3.text = arrString[2];
    }
    if (arrString.length > 3) {
      txtLink_4.text = arrString[3];
    }
  }

clearText() {
  txtLink_1.text = '';
  txtLink_2.text = '';
  txtLink_3.text = '';
  txtLink_4.text = '';

  txtLink.text = '';
  txtLiveOn.text = '';
}

  getData() {
    dictLive = {kLink:'',kThumbnail:'',kLiveOn:''};
    dictWorkoutOfTheDay = {kLink:'',kThumbnail:'',kLiveOn:''};

    strUpper_body = '';
    strCore_cardio = '';
    strFull_body = '';
    strLower_body = '';

    showLoading(context);
    Firestore.instance.collection(tblExercises).document(formattedDate).get().then((value) {
      print(value.data);
      dismissLoading(context);

      if (value.data == null) {
        setData();
      } else {
        if (value.data[kUpper_body] is Map) {
          strUpper_body = value.data[kUpper_body][kLink];
        }
        if (value.data[kCore_cardio] is Map) {
          strCore_cardio = value.data[kCore_cardio][kLink];
        }
        if (value.data[kFull_body] is Map) {
          strFull_body = value.data[kFull_body][kLink];
        }
        if (value.data[kLower_body] is Map) {
          strLower_body = value.data[kLower_body][kLink];
        }

        if (value.data[kLive] is Map) {
          dictLive = value.data[kLive];
        }

        if (value.data[kWorkoutOfTheDay] is Map) {
          dictWorkoutOfTheDay = value.data[kWorkoutOfTheDay];
        }

        print(strUpper_body);
        print(strCore_cardio);
        print(strFull_body);
        print(strLower_body);
        print('object');
      }
    }).catchError((error) {
      setData();
      dismissLoading(context);

//      Toast.show(error.toString(), context,
//          backgroundColor:HexColor(redColor)
//      );
    });
  }

  setData() {
    showLoading(context);
    Firestore.instance
        .collection(tblExercises)
        .document(formattedDate)
        .setData({
      kUpper_body:'',
      kCore_cardio:'',
      kFull_body:'',
      kLower_body:'',
      kWorkoutOfTheDay:'',
      kLive:''
    }).then((value) {
      dismissLoading(context);
    }).catchError((error) {
      dismissLoading(context);
      Toast.show(
          error.message.toString(), context,
          backgroundColor: HexColor(redColor));
    });
  }

  updateData(String strExerciseTitle) {
    showLoading(context);
    Firestore.instance.collection(tblExercises).document(formattedDate).updateData({
      strExerciseTitle:downloadUrl
    }).then((value) {
      downloadUrl = '';

      dismissLoading(context);
      Toast.show(
          '${strTitleBody} is updated', context,
          backgroundColor: HexColor(greenColor)
      );
    }).catchError((error) {
      dismissLoading(context);
      Toast.show(
          error.message.toString(), context,
          backgroundColor: HexColor(redColor));
    });
  }

  updateLiveData(String strExerciseTitle,Map LiveData) {
    showLoading(context);
    Firestore.instance.collection(tblExercises).document(formattedDate).updateData({
      strExerciseTitle:LiveData
    }).then((value) {
      downloadUrl = '';
      txtLiveOn.text = '';
      txtLink.text = '';

      txtLink_1.text = '';
      txtLink_2.text = '';
      txtLink_3.text = '';
      txtLink_4.text = '';

      dismissLoading(context);

      Toast.show(
          '${strTitleBody} is updated', context,
          backgroundColor: HexColor(greenColor));

      getData();
    }).catchError((error) {
      dismissLoading(context);
      Toast.show(
          error.message.toString(), context,
          backgroundColor: HexColor(redColor)
      );
    });

  }

  var myColor = Colors.red;

  Future<void> _uploadFile(String tblName) async {
      showLoading(context);

      var ref = FirebaseStorage.instance.ref().child(tblName).child(formattedDate+"_"+strParamTitle);
      var uploadTask = ref.putFile(_image);
      var storageTaskSnapshot = await uploadTask.onComplete;
      downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      dismissLoading(context);

//      if (strParamTitle.contains('live')) {
//        print('updating live...');
//        strThumbnail = 'Thumbnail is selected.';
//
//        setState(() {
//
//        });
//      } else {
//        updateData(strParamTitle);
//      }
  }

  Future openCameraForImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
      _uploadFile('liveThumbnail/');
    });
  }

  Future openGalleryForImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      _uploadFile('liveThumbnail/');
    });
  }

  _settingModalBottomSheet(context,) {
    showModalBottomSheet(
        backgroundColor:Colors.transparent,
        context: context,
        builder:(BuildContext bc) {
          return Container(
              height:300,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius:BorderRadius.only(
                    topRight:Radius.circular(20),
                    topLeft:Radius.circular(20)
                ),
              ),
              child:Center(
                child:Column(
                  children:<Widget>[
                    SizedBox(height:30),
                    Text(
//                        '$strTitleBody \nPlease select an option.',
                      'Please select an option.',
                        textAlign:TextAlign.center,
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
                        if (strParamTitle.contains('live')) {
                          openCameraForImage();
                        } else {
                          openCameraForImage();
                        }
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
                        if (strParamTitle.contains('live')) {
                          openGalleryForImage();
                        } else {
                          openGalleryForImage();
                        }
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
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:Colors.white,
      body:Stack(
        children:[
          SafeArea(
            child:Container(
              color:Colors.transparent,
              child:SingleChildScrollView(
                  padding: EdgeInsets.only(top:60 - MediaQuery.of(context).padding.top),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                      children:<Widget>[
                        Container(
                          width:MediaQuery.of(context).size.width-44,
                          margin:EdgeInsets.only(left:0, right: 22),
                          child:Row(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon:Icon(
                                  Icons.arrow_back,
                                  color:AppConstant.color_blue_dark,
                                  size:30,
                                ),
                                iconSize:30,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Container(
//                                color:Colors.red,
                                width:MediaQuery.of(context).size.width-100,
                                child:Text(
                                  'Hello, Admin!',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: AppConstant.kPoppins,
                                      fontWeight: FontWeight.normal,
                                      color:AppConstant.color_blue_dark
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
//                                color:Colors.red,
                          width:MediaQuery.of(context).size.width-130,
                          child:Text(
                            'You can set exercises and live video for a particular date.',
                            style: TextStyle(
                                fontSize:14,
                                fontFamily: AppConstant.kPoppins,
                                fontWeight: FontWeight.normal,
                                color:AppConstant.color_blue_dark),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border:Border(
                              bottom:BorderSide(width:1.0, color:Color(0xff84828F)),
                            ),
                            color: Colors.white,
                          ),
//                          margin:EdgeInsets.only(top:10),
                          padding:EdgeInsets.only(bottom:20),
                          child:G2xSimpleWeekCalendar(
                            90.0, DateTime.now(),
                            dateCallback:(date) {
                              var formatter = DateFormat('yyyy_MMM_dd');
                              formattedDate = formatter.format(date);

                              getData();
//                              getExercises(formattedDate);
                            },

                            selectedDateTextStyle:TextStyle(
                                color:AppConstant.color_blue_dark,
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16),
                            selectedDateBG_Color:Colors.white,

                            // selectedDateBackgroundColor:Colors.white,
                            // selectedDateTextColor:AppConstant.color_blue_dark,

                            typeCollapse: false,
                            selectedTextStyle:TextStyle(
                                color:Colors.white,
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16),
                            selectedBackgroundDecoration: BoxDecoration(
                                color:AppConstant.color_blue_dark,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            strWeekDays: ['Su','Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa',],
                            defaultTextStyle: TextStyle(
                                color: AppConstant.color_blue_dark,
                                fontFamily: AppConstant.kPoppins,
                                fontWeight: FontWeight.normal,
                                fontSize: 16),
                          ),
                        ),
                        Container(
                          margin:EdgeInsets.only(top:20, left: 20, right: 20),
                          height:110,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  width: (sizeScreen.width - 70) / 2,
                                  padding: EdgeInsets.only(
                                      top: 10, left: 16, right: 10),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: [
                                          HexColor('#84828F'),
                                          HexColor('424148')
                                        ],
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                      )),
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(
                                        children: <Widget>[
                                          Text(
                                            'Lower Body\nWorkouts',
                                            style:TextStyle(
                                                color:Colors.white,
                                                fontFamily:
                                                AppConstant.kPoppins,
                                                fontWeight: FontWeight.normal,
                                                fontSize:15),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child:Image.asset(
                                              Res.lowerBody,
                                              height:88,
                                              width:48,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onPressed: () {
                                      strTitleBody = 'Lower body workouts';
                                      strParamTitle = kLower_body;

                                      isPopUpVisibleLinks = true;

                                      clearText();
                                      setExercise(strLower_body);

                                      setState(() {

                                      });
                                    },
                                  )),
                              FlatButton(
                                padding:EdgeInsets.all(0),
                                textColor:Colors.white,
                                child:Container(
                                    width:(sizeScreen.width - 70) / 2,
                                    padding:EdgeInsets.only(
                                        top:10, left: 16, right: 10),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors:[
                                            HexColor('3ACBAB'),
                                            HexColor('0EAA88')
                                          ],
                                          begin:FractionalOffset.topCenter,
                                          end:FractionalOffset.bottomCenter,
                                        )),
                                    child:Container(
                                      width:double.infinity,
                                      height:double.infinity,
                                      child:Stack(
                                        children:<Widget>[
                                          Text(
                                            'Upper Body\nWorkouts',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: AppConstant.kPoppins,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Image.asset(
                                              Res.upper,
                                              height: 63,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                onPressed:() {
                                  strTitleBody = 'Upper body workouts';
                                  strParamTitle = kUpper_body;

                                  isPopUpVisibleLinks = true;

                                  clearText();
                                  setExercise(strUpper_body);

                                  setState(() {

                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin:EdgeInsets.only(top: 30, left: 20, right: 20),
                          height:110,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FlatButton(
                                padding:EdgeInsets.all(0),
                                textColor:Colors.white,
                                child:Container(
                                    width: (sizeScreen.width - 70) / 2,
                                    padding: EdgeInsets.only(
                                        top: 10, left: 16, right: 10),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            HexColor('34486F'),
                                            HexColor('314467')
                                          ],
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                        )),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(
                                        children: <Widget>[
                                          Text(
                                            'Full Body\nWorkouts',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: AppConstant.kPoppins,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Image.asset(
                                              Res.fullBody,
//                                      fit:BoxFit.cover,
                                              height: 100,
                                              width: 40,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                onPressed:() {
                                  strTitleBody = 'Full body workouts';
                                  strParamTitle = kFull_body;

                                  isPopUpVisibleLinks = true;

                                  clearText();
                                  setExercise(strFull_body);

                                  setState(() {

                                  });
                                },
                              ),
                              FlatButton(
                                padding:EdgeInsets.all(0),
                                textColor:Colors.white,
                                child:Container(
                                    width: (sizeScreen.width - 70) / 2,
                                    padding: EdgeInsets.only(top: 10, left: 16, right:0),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            HexColor('F4C3AC'),
                                            HexColor('F3976B')
                                          ],
                                          begin:FractionalOffset.topCenter,
                                          end:FractionalOffset.bottomCenter,
                                        )),
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(
                                        children: <Widget>[
                                          Text(
                                            'Core & Cardio\nWorkouts',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: AppConstant.kPoppins,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Image.asset(
                                              Res.core,
                                              height: 90,
                                              width: 130,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                onPressed:() {
                                  strTitleBody = 'Core & Cardio workouts';
                                  strParamTitle = kCore_cardio;

                                  isPopUpVisibleLinks = true;

                                  clearText();
                                  setExercise(strCore_cardio);

                                  setState(() {

                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible:true,
//                          (dictLive[kLink].isEmpty) ? false : true,
                          child:Container(
                            margin:EdgeInsets.only(left:20, right:20, top:20),
                            width:double.infinity,
                            height:50,
                            decoration:BoxDecoration(
                              borderRadius:BorderRadius.circular(10),
                              gradient:LinearGradient(
                                colors:[HexColor('54C9AF'), HexColor('1CA386')],
                                begin:FractionalOffset.topCenter,
                                end:FractionalOffset.bottomCenter,
                              ),
                            ),
                            child: FlatButton(
                              child: Text(
                                'Upload workout of the day',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppConstant.kPoppins,
                                    fontWeight: FontWeight.normal,
                                    fontSize:16),
                              ),
                              onPressed: () async {
                                strTitleBody = 'Upload workout of the day';
                                strParamTitle = kWorkoutOfTheDay;

                                isPopUpVisible = true;
                                isThumbnail = true;

                                clearText();
                                txtLink.text = dictLive[kLink];

                                setState(() {

                                });
                              },
                            ),
                          ),

//                          Column(
//                            children: [
//                              Container(
//                                  width:double.infinity,
//                                  height:30,
//                                  margin:EdgeInsets.only(left: 20, right: 20,top:16),
//                                  child:RichText(
//                                    text: TextSpan(
//                                      text:'Upload workout of the day.',
////                                    style: DefaultTextStyle.of(context).style,
//                                      style: TextStyle(
//                                          color: Colors.black,
//                                          fontFamily: AppConstant.kPoppins,
//                                          fontWeight: FontWeight.bold,
//                                          fontSize: 18),
//                                      children: <TextSpan>[
//                                        TextSpan(
//                                          text:''+dictLive[kLiveOn],
//                                          style:TextStyle(
//                                              color:Colors.blue,
//                                              fontFamily:AppConstant.kPoppins,
//                                              fontWeight:FontWeight.normal,
//                                              fontSize:18),
//                                        ),
//                                      ],
//                                    ),
//                                  )
//                              ),
//                              FlatButton(
//                                padding:EdgeInsets.all(0),
//                                child:Container(
//                                  margin:EdgeInsets.only(left: 20, right: 20, top:16),
//                                  width:double.infinity,
//                                  height:210,
//                                  child:Stack(
//                                    children: <Widget>[
//                                      Container(
//                                        width:double.infinity,
//                                        height:210,
//                                        child:ClipRRect(
//                                            borderRadius:BorderRadius.circular(10),
//                                            child:FadeInImage(
//                                              fit:BoxFit.fill,
//                                              height:300,
//                                              width:double.infinity,
//                                              image:NetworkImage(dictLive[kThumbnail]),
//                                              placeholder:AssetImage(Res.ImageThumbnailVideo),
//                                            )
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                                onPressed:() {
//                                  strTitleBody = 'Upload workout of the day';
//                                  strParamTitle = kWorkoutOfTheDay;
//
//                                  isPopUpVisible = true;
//                                  isThumbnail = true;
//
//                                  setState(() {
//
//                                  });
//                                },
//                              )
//                            ],
//                          ),
                        ),
                        Visibility(
                          visible:true,
//                          visible:(dictLive[kLink].isEmpty) ? false : true,
                          child:Container(
                            margin:EdgeInsets.only(left:20, right:20, top:16),
                            width:double.infinity,
                            height:50,
                            decoration:BoxDecoration(
                              borderRadius:BorderRadius.circular(10),
                              gradient:LinearGradient(
                                colors:[HexColor('54C9AF'), HexColor('1CA386')],
                                begin:FractionalOffset.topCenter,
                                end:FractionalOffset.bottomCenter,
                              ),
                            ),
                            child: FlatButton(
                              child: Text(
                                'Upload Join Live workout of the day',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppConstant.kPoppins,
                                    fontWeight: FontWeight.normal,
                                    fontSize:16),
                              ),
                              onPressed: () async {
                                strTitleBody = 'Upload Join Live workout of the day';
                                strParamTitle = kLive;

                                isPopUpVisible = true;
                                isThumbnail = false;

                                clearText();
                                txtLink.text = dictWorkoutOfTheDay[kLink];

                                setState(() {

                                });
                              },
                            ),
                          ),



//                          Column(
//                            children: [
//                              Container(
//                                  width:double.infinity,
//                                  height:30,
//                                  margin:EdgeInsets.only(left: 20, right: 20, top:15),
//                                  child:RichText(
//                                    text:TextSpan(
//                                      text:'Join Live workout of the day',
////                                    style: DefaultTextStyle.of(context).style,
//                                      style:TextStyle(
//                                          color:Colors.black,
//                                          fontFamily:AppConstant.kPoppins,
//                                          fontWeight:FontWeight.bold,
//                                          fontSize:18
//                                      ),
//                                      children: <TextSpan>[
//                                        TextSpan(
//                                          text:' on '+dictLive[kLiveOn],
//                                          style:TextStyle(
//                                              color:Colors.blue,
//                                              fontFamily:AppConstant.kPoppins,
//                                              fontWeight:FontWeight.normal,
//                                              fontSize:18
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  )
//                              ),
//                              Container(
//                                margin:EdgeInsets.only(left: 20, right: 20, top:15),
//                                width:double.infinity,
//                                height:210,
//                                child:Stack(
//                                  children: <Widget>[
//                                    Container(
//                                      width: double.infinity,
//                                      height: 210,
//                                      child:ClipRRect(
//                                          borderRadius:BorderRadius.circular(10),
//                                          child:FadeInImage(
//                                            fit:BoxFit.fill,
//                                            height:300,
//                                            width:double.infinity,
//                                            image:NetworkImage(dictLive[kThumbnail]),
//                                            placeholder:AssetImage(Res.ImageThumbnailVideo),
//                                          )
//                                      ),
//                                    ),
//                                    Container(
//                                      width: double.infinity,
//                                      height: 210,
//                                      decoration: BoxDecoration(
//                                        color: HexColor('29364E').withOpacity(0.4),
//                                        borderRadius: BorderRadius.circular(10),
//                                      ),
//                                    ),
//                                    Container(
//                                        child: Center(
//                                          child: IconButton(
//                                              icon: Image.asset(
//                                                Res.play,
//                                              ),
//                                              onPressed: () async {
//                                                var url = dictLive[kLink].toString();
//                                                if (await canLaunch(url)) {
//                                                  await launch(url);
//                                                } else {
//                                                  throw 'Could not launch $url';
//                                                }
//                                              }
//                                          ),
//                                        )),
//                                  ],
//                                ),
//                              ),
//                            ],
//                          ),
                        ),
                        SizedBox(
                          height: 40,
                        )
                      ]
                  )
              )
            ),
          ),
          Visibility(
            visible:isPopUpVisible,
            child:FlatButton(
              padding:EdgeInsets.all(0),
              child:Container(
                color:Colors.grey.withOpacity(0.6),
                padding:EdgeInsets.only(top:MediaQuery.of(context).size.height-400,),
                child:Container(
                    height:double.infinity,
                    decoration:BoxDecoration(
//                      color:Colors.red,
                      color:Colors.white,
                      borderRadius:BorderRadius.only(
                          topRight:Radius.circular(20),
                          topLeft:Radius.circular(20)
                      ),
//              border: Border.all(width:3,color: Colors.green,style: BorderStyle.solid)
                    ),
                    child:Container(
//                        margin:EdgeInsets.only(top:MediaQuery.of(context).size.height-300,),
                        margin:EdgeInsets.only(bottom: 0),
                        padding:EdgeInsets.only(left:25,right:25),
                        decoration:BoxDecoration(
//                          color:Colors.red,
//                          color:Colors.white,
                          borderRadius:BorderRadius.only(
                              topRight:Radius.circular(20),
                              topLeft:Radius.circular(20)
                          ),
                        ),
                        child:SingleChildScrollView(
                          child:Column(
                            children:[
                              SizedBox(height:60),
                              Text(
                                strTitleBody,
                                textAlign:TextAlign.center,
                                style:TextStyle(
                                    fontSize:18,
                                    fontFamily:AppConstant.kPoppins,
                                    color:AppConstant.color_blue_dark,
                                    fontWeight:FontWeight.bold
                                ),
                              ),
                              SizedBox(height:10),
                              TextField(
                                controller:txtLink,
                                keyboardAppearance:Brightness.light,
                                cursorColor:Color(0xff84828F),
                                decoration:InputDecoration(
                                  //labelText: title ,  // you can change this with the top text  like you want
                                    labelText:'Link',
                                    hintStyle:TextStyle(
                                        fontFamily:AppConstant.kPoppins,
                                        fontWeight:FontWeight.normal,
                                        fontSize:15
                                    ),
                                    /*border: InputBorder.none,*/
                                    fillColor: Color(0xff84828F)
                                ),
                              ),
                              SizedBox(height:20),
//                              TextField(
//                                controller:txtLiveOn,
//                                keyboardAppearance:Brightness.light,
//                                cursorColor:Color(0xff84828F),
//                                decoration:InputDecoration(
//                                  //labelText: title ,  // you can change this with the top text  like you want
//                                    labelText:'Live On (Zoom, Youtube, Facebook, etc...)',
//                                    hintStyle:TextStyle(
//                                        fontFamily:AppConstant.kPoppins,
//                                        fontWeight:FontWeight.normal,
//                                        fontSize:15
//                                    ),
//                                    /*border: InputBorder.none,*/
//                                    fillColor:Color(0xff84828F)
//                                ),
//                              ),
                              Visibility(
                                visible:isThumbnail,
                                child:Container(
//                                margin:EdgeInsets.only(left:20, right:20, top: 30),
                                  width:double.infinity,
                                  height:50,
                                  decoration:BoxDecoration(
                                    borderRadius:BorderRadius.circular(16),
                                    gradient:LinearGradient(
                                      colors:[HexColor('54C9AF'), HexColor('1CA386')],
                                      begin:FractionalOffset.topCenter,
                                      end:FractionalOffset.bottomCenter,
                                    ),
                                  ),
                                  child: FlatButton(
                                    textColor:Colors.white,
                                    child:Text(
                                      'Upload a thumbnail',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: AppConstant.kPoppins,
                                          fontWeight: FontWeight.normal,
                                          fontSize:18),
                                    ),
                                    onPressed: () async {
                                      _settingModalBottomSheet(context);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height:20),
                              Container(
                                height:50,
                                width:MediaQuery.of(context).size.width,
                                decoration:kButtonThemeGradientColor(),
                                child:FlatButton(
                                  padding:EdgeInsets.all(0),
                                  child:Text(
                                    'Upload',
                                    style:TextStyle(
                                        color:Colors.white,
                                        fontFamily:AppConstant.kPoppins,
                                        fontWeight:FontWeight.normal,
                                        fontSize:18
                                    ),
                                  ),
                                  onPressed:() {
                                    if (txtLink.text.isEmpty) {
                                      Toast.show('Enter a link for live', context,
                                          backgroundColor:HexColor(redColor)
                                      );
                                      return ;
                                    }

                                    if (isThumbnail) {
                                      if (downloadUrl.isEmpty) {
                                        Toast.show('Select a thumbnail', context,
                                            backgroundColor:HexColor(redColor)
                                        );
                                        return ;
                                      }
                                    }

                                      isPopUpVisible = false;
                                      setState(() {

                                      });

                                      Map dictLiveData = {
                                        kLink:txtLink.text,
                                        kLiveOn:txtLiveOn.text,
                                        kThumbnail:downloadUrl
                                      };

                                      Future.delayed(Duration(milliseconds:1),() {
                                        updateLiveData(strParamTitle,dictLiveData);
                                      });

                                  },
                                ),
                              ),
                              SizedBox(height:20),
                            ],
                          ),
                        )
                    )
                ),
              ),
              onPressed:() {
                print('flatting...');

                isPopUpVisible = false;
                setState(() {

                });
              },
            )
          ),
          Visibility(
              visible:isPopUpVisibleLinks,
              child:FlatButton(
                padding:EdgeInsets.all(0),
                child:Container(
                  color:Colors.grey.withOpacity(0.6),
                  padding:EdgeInsets.only(top:MediaQuery.of(context).size.height-500,),
                  child:Container(
                      height:double.infinity,
                      decoration:BoxDecoration(
//                      color:Colors.red,
                        color:Colors.white,
                        borderRadius:BorderRadius.only(
                            topRight:Radius.circular(20),
                            topLeft:Radius.circular(20)
                        ),
//              border: Border.all(width:3,color: Colors.green,style: BorderStyle.solid)
                      ),
                      child:Container(
//                        margin:EdgeInsets.only(top:MediaQuery.of(context).size.height-300,),
                          margin:EdgeInsets.only(bottom: 0),
                          padding:EdgeInsets.only(left:25,right:25),
                          decoration:BoxDecoration(
                            borderRadius:BorderRadius.only(
                                topRight:Radius.circular(20),
                                topLeft:Radius.circular(20)
                            ),
                          ),
                          child:SingleChildScrollView(
                            child:Column(
                              children:[
                                SizedBox(height:30),
                                Text(
                                  strTitleBody,
                                  textAlign:TextAlign.center,
                                  style:TextStyle(
                                      fontSize:18,
                                      fontFamily:AppConstant.kPoppins,
                                      color:AppConstant.color_blue_dark,
                                      fontWeight:FontWeight.bold
                                  ),
                                ),
                                SizedBox(height:12),
                                Text(
                                  'Type your links here...',
                                  textAlign:TextAlign.center,
                                  style:TextStyle(
                                      fontSize:16,
                                      fontFamily:AppConstant.kPoppins,
                                      color:Colors.black,
                                      fontWeight:FontWeight.normal
                                  ),
                                ),
                                SizedBox(height:10),
                                TextField(
                                  controller:txtLink_1,
                                  keyboardAppearance:Brightness.light,
                                  cursorColor:Color(0xff84828F),
                                  decoration:InputDecoration(
                                    //labelText: title ,  // you can change this with the top text  like you want
                                      labelText:'Link 1',
                                      hintStyle:TextStyle(
                                          fontFamily:AppConstant.kPoppins,
                                          fontWeight:FontWeight.normal,
                                          fontSize:15
                                      ),
                                      /*border: InputBorder.none,*/
                                      fillColor: Color(0xff84828F)
                                  ),
                                ),
                                SizedBox(height:20),
                                TextField(
                                  controller:txtLink_2,
                                  keyboardAppearance:Brightness.light,
                                  cursorColor:Color(0xff84828F),
                                  decoration:InputDecoration(
                                    //labelText: title ,  // you can change this with the top text  like you want
                                      labelText:'Link 2',
                                      hintStyle:TextStyle(
                                          fontFamily:AppConstant.kPoppins,
                                          fontWeight:FontWeight.normal,
                                          fontSize:15
                                      ),
                                      /*border: InputBorder.none,*/
                                      fillColor: Color(0xff84828F)
                                  ),
                                ),
                                SizedBox(height:20),
                                TextField(
                                  controller:txtLink_3,
                                  keyboardAppearance:Brightness.light,
                                  cursorColor:Color(0xff84828F),
                                  decoration:InputDecoration(
                                    //labelText: title ,  // you can change this with the top text  like you want
                                      labelText:'Link 3',
                                      hintStyle:TextStyle(
                                          fontFamily:AppConstant.kPoppins,
                                          fontWeight:FontWeight.normal,
                                          fontSize:15
                                      ),
                                      /*border: InputBorder.none,*/
                                      fillColor: Color(0xff84828F)
                                  ),
                                ),
                                SizedBox(height:20),
                                TextField(
                                  controller:txtLink_4,
                                  keyboardAppearance:Brightness.light,
                                  cursorColor:Color(0xff84828F),
                                  decoration:InputDecoration(
                                    //labelText: title ,  // you can change this with the top text  like you want
                                      labelText:'Link 4',
                                      hintStyle:TextStyle(
                                          fontFamily:AppConstant.kPoppins,
                                          fontWeight:FontWeight.normal,
                                          fontSize:15
                                      ),
                                      /*border: InputBorder.none,*/
                                      fillColor: Color(0xff84828F)
                                  ),
                                ),
                                SizedBox(height:20),
                                Container(
                                  height:50,
                                  width:MediaQuery.of(context).size.width,
                                  decoration:kButtonThemeGradientColor(),
                                  child:FlatButton(
                                    padding:EdgeInsets.all(0),
                                    child:Text(
                                      'Upload',
                                      style:TextStyle(
                                          color:Colors.white,
                                          fontFamily:AppConstant.kPoppins,
                                          fontWeight:FontWeight.normal,
                                          fontSize:18
                                      ),
                                    ),
                                    onPressed:() {
                                      if (txtLink_1.text.isEmpty && txtLink_2.text.isEmpty
                                          && txtLink_3.text.isEmpty && txtLink_4.text.isEmpty ) {
                                        Toast.show('Enter atleast a link', context,
                                            backgroundColor:HexColor(redColor)
                                        );
                                        return ;
                                      }

                                      isPopUpVisibleLinks = false;

                                      setState(() {

                                      });

                                      String strLinks = '';
                                      if (txtLink_1.text.isNotEmpty) {
                                        strLinks = txtLink_1.text;
                                      }

                                      if (txtLink_2.text.isNotEmpty) {
                                        strLinks = strLinks+'~~'+txtLink_2.text;
                                      }

                                      if (txtLink_3.text.isNotEmpty) {
                                        strLinks = strLinks+'~~'+txtLink_3.text;
                                      }

                                      if (txtLink_4.text.isNotEmpty) {
                                        strLinks = strLinks+'~~'+txtLink_4.text;
                                      }

                                      print(strLinks);

                                      Map dictLiveData = {
                                        kLink:strLinks,
                                        kLiveOn:txtLiveOn.text,
                                        kThumbnail:downloadUrl
                                      };
//                                      print(dictLiveData);

                                      Future.delayed(Duration(milliseconds:1),() {
                                        updateLiveData(strParamTitle,dictLiveData);
                                      });

                                    },
                                  ),
                                ),
                                SizedBox(height:20),
                              ],
                            ),
                          )
                      )
                  ),
                ),
                onPressed:() {
                  print('flatting...');

                  isPopUpVisibleLinks = false;
                  setState(() {

                  });
                },
              )
          )
        ],
      )
    );
  }
}


