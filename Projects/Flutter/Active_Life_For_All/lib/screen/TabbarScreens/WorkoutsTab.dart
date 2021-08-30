import 'package:alfa/screen/WorkoutDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:alfa/res.dart';
import 'package:g2x_week_calendar/g2x_simple_week_calendar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dart_notification_center/dart_notification_center.dart';



class WorkoutsTab extends StatefulWidget {
  @override
  _WorkoutsTabState createState() => _WorkoutsTabState();
}

class _WorkoutsTabState extends State<WorkoutsTab> {
  String strName = '';

  String strUpper_body = '';
  String strCore_cardio = '';
  String strFull_body = '';
  String strLower_body = '';

  Map<String, dynamic> dictLive = {kLink:'',kThumbnail:'',kLiveOn:''};
  Map<String, dynamic> dictWorkoutOfTheDay = {kLink:'',kThumbnail:'',kLiveOn:''};

  DateTime setDate;

  @override
  void dispose() {
    super.dispose();
  }

  List<Map<String, dynamic>> arrQuotes = [];
  var dictUserDetails = Map<String,dynamic>();
  List<String> arrAdmin = List<String>();

  getQuotes() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection(tblQuotes).getDocuments();
    arrQuotes = querySnapshot.documents.map((DocumentSnapshot doc) {
      return doc.data;
    }).toList();

    setState(() {

    });
  }



  @override
  void initState() {
    DartNotificationCenter.subscribe(channel:tblQuotes,observer:this,onNotification: (result) {
      getQuotes();
    },);

    Future.delayed(Duration(milliseconds:1),() async {
      QuerySnapshot querySnapshotAdmin = await Firestore.instance.collection(tblAdmin).getDocuments();
      List<Map<String, dynamic>> arrAdminDetails = querySnapshotAdmin.documents.map((DocumentSnapshot doc) {
        return doc.data;
      }).toList();

      arrAdmin = List<String>.from(arrAdminDetails[0][kAdminNumber]);
      checkAdmin();

      var now = DateTime.now();
      var formatter = DateFormat('yyyy_MMM_dd');
      String formattedDate = formatter.format(now);
      print(formattedDate);

      getExercises(formattedDate);
      getQuotes();

      FirebaseAuth.instance.currentUser().then((value) {
        Firestore.instance.collection(tblUserDetails).document(
            value.email + kFireBaseConnect + value.uid).get().then((value) {
            dictUserDetails = value.data;
            strName = dictUserDetails[kFirstName]+' '+dictUserDetails[kLastName];

            checkAdmin();

            setState(() {

            });
        }).catchError((error) {
          Toast.show(
              error.message.toString(),
              context,
              backgroundColor: HexColor(redColor)
          );
        }).catchError((error) {
//          dismissLoading(context);
          Toast.show(
              error.message.toString(),
              context,
              backgroundColor: HexColor(redColor)
          );
        });
      });
    });

    super.initState();
  }

  checkAdmin() {
    for (int i = 0;i<arrAdmin.length;i++) {
      if (arrAdmin[i] == dictUserDetails[kEmail]) {
        print('this user is admin');
        kIsAdmin = true;
        break;
      }
    }
  }

  getExercises(String date) async {
    dictLive = {kLink:'',kThumbnail:'',kLiveOn:''};
    dictWorkoutOfTheDay = {kLink:'',kThumbnail:'',kLiveOn:''};

    strUpper_body = '';
    strCore_cardio = '';
    strFull_body = '';
    strLower_body = '';

    Firestore.instance.collection(tblExercises).document(date).get().then((value) {
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
        print(dictWorkoutOfTheDay[kThumbnail]);
      }

      setState(() {

      });
    }).catchError((error) {
//      dismissLoading(context);
      Toast.show(
          error.message.toString(),
          context,
          duration:2,
          gravity:Toast.BOTTOM,
          backgroundColor:HexColor(redColor));
      setState(() {

      });
    });
  }

  showAlertDialog(BuildContext context,String docID) {
    Widget cancelButton = FlatButton(
      child:Text(
        'NO',
        style:TextStyle(
            fontSize:18,
            fontFamily: AppConstant.kPoppins,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      onPressed:() {
        dismissLoading(context);
      },
    );
    Widget continueButton = FlatButton(
      child:Text(
        'YES',
        style:TextStyle(
            fontSize:18,
            fontFamily: AppConstant.kPoppins,
            fontWeight: FontWeight.w600,
            color: Colors.red),
      ),
      onPressed:() {
        dismissLoading(context);
        showLoading(context);
        Firestore.instance.collection(tblQuotes).document(docID)
            .delete();
        dismissLoading(context);
        getQuotes();

        Toast.show(
            'This Quotes has deleted successfully.',
            context,
            backgroundColor: HexColor(greenColor)
        );
      },
    );
    AlertDialog alert = AlertDialog(
      title:Text(
        'Are you sure ?',
        style: TextStyle(
            fontSize: 24,
            fontFamily: AppConstant.kPoppins,
            fontWeight: FontWeight.w500,
            color: Colors.black),),
      content:Text(
        'You want to delete this quote ?',
        style: TextStyle(
            fontSize:18,
            fontFamily: AppConstant.kPoppins,
            fontWeight: FontWeight.normal,
            color: Colors.black),),
      actions:[
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body:Stack(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
                  gradient: LinearGradient(
                    colors: [HexColor('2E4877'), HexColor('29364E')],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                  )),
            ),
            SafeArea(
              child: Container(
                  color:Colors.transparent,
                  child:SingleChildScrollView(
                    padding: EdgeInsets.only(top: 60 - MediaQuery.of(context).padding.top),
                    // physics: BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width:MediaQuery.of(context).size.width-44,
                          margin: EdgeInsets.only(left: 22, right: 22),
                          child: Row(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width:MediaQuery.of(context).size.width-44,
                                child:Text(
                                  'Hello, $strName!',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontFamily: AppConstant.kPoppins,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin:EdgeInsets.only(top:10),
                          child:G2xSimpleWeekCalendar(
                            90.0, DateTime.now(),
                            dateCallback:(date) {
                              var formatter = DateFormat('yyyy_MMM_dd');
                              String formattedDate = formatter.format(date);
                              getExercises(formattedDate);
                            },

                            selectedDateTextStyle:TextStyle(
                                color:Colors.white,
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16),
                            selectedDateBG_Color:AppConstant.color_blue_dark,

                            // selectedDayButtonColor:AppConstant.color_blue_dark,
                            //   selectedDateBackgroundColor:AppConstant.color_blue_dark,

                            typeCollapse:false,
                              backgroundDecoration: BoxDecoration(),
                            selectedTextStyle:TextStyle(
                                color:HexColor('29364E'),
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16),
                            selectedBackgroundDecoration:BoxDecoration(color:Colors.white,
                                borderRadius:BorderRadius.circular(30)),
                            strWeekDays:[
                              'Su',
                              'Mo',
                              'Tu',
                              'We',
                              'Th',
                              'Fr',
                              'Sa',
                            ],
                            defaultTextStyle: TextStyle(
                                color:Colors.white,
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top:30, left: 20, right: 20),
                          height: 110,
                          child: Row(
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
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                    AppConstant.kPoppins,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Image.asset(
                                              Res.lowerBody,
                                              height: 88,
                                              width: 48,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onPressed: () {
                                      kVideoURL = strLower_body;
                                      if (kVideoURL.isNotEmpty) {
                                        Navigator.pushNamed(context, '/WorkoutDetails');
                                      } else {
                                        Toast.show(
                                            'Workout is not available.',
                                            context,
                                            backgroundColor: HexColor(redColor)
                                        );
                                      }
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
                                            right:0,
                                            bottom:0,
                                            child:Image.asset(
                                              Res.upper,
                                              height: 63,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                onPressed:() {
                                  kVideoURL = strUpper_body;
                                  if (kVideoURL.isNotEmpty) {
                                    Navigator.pushNamed(
                                        context, '/WorkoutDetails');
                                  } else {
                                    Toast.show(
                                        'Workout is not available.',
                                        context,
                                        backgroundColor: HexColor(redColor)
                                    );
                                  }
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
                                  kVideoURL = strFull_body;
                                  if (kVideoURL.isNotEmpty) {
                                    Navigator.pushNamed(
                                        context, '/WorkoutDetails');
                                  } else {
                                    Toast.show(
                                        'Workout is not available.',
                                        context,
                                        backgroundColor: HexColor(redColor)
                                    );
                                  }
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
                                  kVideoURL = strCore_cardio;
                                  if (kVideoURL.isNotEmpty) {
                                    Navigator.pushNamed(
                                        context, '/WorkoutDetails');
                                  } else {
                                    Toast.show(
                                        'Workout is not available.',
                                        context,
                                        backgroundColor: HexColor(redColor)
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),

                        Visibility(
//                          visible:true,
                          visible:(dictWorkoutOfTheDay[kLink].isEmpty) ? false : true,
                          child:Column(
                            children: [
                              Container(
                                  width:double.infinity,
                                  height:30,
                                  margin:EdgeInsets.only(left:20, right: 20, top:14),
                                  child:RichText(
                                    text:TextSpan(
                                      text:'Workout of the day',
//                                    style: DefaultTextStyle.of(context).style,
                                      style:TextStyle(
                                          color:Colors.black,
                                          fontFamily:AppConstant.kPoppins,
                                          fontWeight:FontWeight.bold,
                                          fontSize:18
                                      ),
                                      children: <TextSpan>[
//                                        TextSpan(
//                                          text:' on '+dictLive[kLiveOn],
//                                          style:TextStyle(
//                                              color:Colors.blue,
//                                              fontFamily:AppConstant.kPoppins,
//                                              fontWeight:FontWeight.normal,
//                                              fontSize:18
//                                          ),
//                                        ),
                                      ],
                                    ),
                                  )
                              ),
                              Container(
                                margin:EdgeInsets.only(left:20,right:20,top:14),
                                width:double.infinity,
                                height:210,
//                                color:Colors.white,
                                child:Stack(
                                  children: <Widget>[
                                    Container(
//                                      width:double.infinity,
//                                      height:210,
                                      child:ClipRRect(
                                          borderRadius:BorderRadius.circular(10),
                                          child:FadeInImage(
                                            fit:BoxFit.fitWidth,
                                            height:300,
                                            width:double.infinity,
                                            image:NetworkImage(dictWorkoutOfTheDay[kThumbnail]),
                                            placeholder:AssetImage(''),
//                                            placeholder:AssetImage(Res.ImageThumbnailVideo),
                                          )
                                      ),
                                    ),
                                    Center(
                                      child:Container(
                                      width:double.infinity,
                                      height:210,
//                                        width:60,
//                                        height:60,
                                        decoration: BoxDecoration(
                                          color: HexColor('29364E').withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        child: Center(
                                          child: IconButton(
                                              icon: Image.asset(
                                                Res.play,
                                              ),
                                              onPressed: () async {
                                                kVideoURL = dictWorkoutOfTheDay[kLink].toString();
                                                if (kVideoURL.isNotEmpty) {
                                                  Navigator.pushNamed(
                                                      context, '/WorkoutDetails');
                                                } else {
                                                  Toast.show(
                                                      'Workout is not available.',
                                                      context,
                                                      backgroundColor: HexColor(redColor)
                                                  );
                                                }
                                              }
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
//                          visible:true,
                          visible:(dictLive[kLink].isEmpty) ? false : true,
                          child:Container(
                            margin:EdgeInsets.only(left:20, right:20, top: 30),
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
                                'Join Live workout of the day',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppConstant.kPoppins,
                                    fontWeight: FontWeight.normal,
                                    fontSize:18),
                              ),
                              onPressed: () async {
                                var url = dictLive[kLink].toString();
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
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

                        Container(
                          margin:EdgeInsets.only(left:0,right:0,top:20),
                          width:sizeScreen.width,
                            child:Text(
                              "COMPLETE TODAY'S WORKOUT:",
                              textAlign:TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: AppConstant.kPoppins,
                                  fontWeight: FontWeight.bold,
                                  fontSize:18),
                            )),


                        Visibility(
                          visible:arrQuotes.length > 0 ? true : false,
                          child:Container(
                              margin:EdgeInsets.only(left:20,right:20,top:20),
                              height:170,
                              width:sizeScreen.width,
                              decoration:BoxDecoration(
                                  color:HexColor('#C1C1C1').withOpacity(0.5),
                                  borderRadius:BorderRadius.circular(20)),
                              alignment:Alignment.centerLeft,
                              child:Swiper(
                                itemCount:arrQuotes.length,
                                pagination:SwiperPagination(
                                    margin:EdgeInsets.only(bottom: 12),
                                    builder:DotSwiperPaginationBuilder(
                                      color:Colors.white,
                                      activeColor:HexColor('#29364E'),
                                    )
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 24, top: 14),
                                            child:Image.asset(
                                              Res.quete,
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                          Visibility(
                                            child:IconButton(
                                            icon:Icon(
                                              Icons.cancel,
                                              color:Colors.red,
                                            ),
                                            iconSize:30,
                                            onPressed:() {
                                              showAlertDialog(context,arrQuotes[index][kDocID]);
                                            },
                                          ),
                                            visible:kIsAdmin,
                                          )
                                        ],
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 24, top: 10, right: 24),
                                          child: Text(
                                            arrQuotes[index][kQuotes],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: AppConstant.kPoppins,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 24, top: 10, right: 24),
                                          child: Text(
                                            '- @'+arrQuotes[index][kName]+' ( ${arrQuotes[index][kSocialType]} )',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: AppConstant.kPoppins,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ))
                                    ],
                                  );
                                },
                              )),
                        ),
                        Container(
                          margin:EdgeInsets.only(left: 40, right: 40, top: 30),
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
                            child:Text(
                              'Post Your Quote of Day',
                              style:TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppConstant.kPoppins,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                            onPressed:() {
                              Navigator.pushNamed(context, '/YourQuote');
                            },
                          ),
                        ),

//                        Container(
//                          margin: EdgeInsets.only(left: 40, right: 40, top: 30),
//                          width: double.infinity,
//                          height: 50,
//                          decoration: BoxDecoration(
//                            color: HexColor('29364E'),
//                            borderRadius: BorderRadius.circular(10),
//                          ),
//                          child: FlatButton(
//                            child: Text(
//                              'Start 1 Week Trial',
//                              style: TextStyle(
//                                  color: Colors.white,zzzzz
//                                  fontFamily: AppConstant.kPoppins,
//                                  fontWeight: FontWeight.normal,
//                                  fontSize: 16),
//                            ),
//                            onPressed: () {
//                              Navigator.pushNamed(context, '/Subscribe');
//                            },
//                          ),
//                        ),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ));
  }
}


