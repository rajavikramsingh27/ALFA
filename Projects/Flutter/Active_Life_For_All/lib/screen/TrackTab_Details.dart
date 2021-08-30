
import 'package:alfa/res.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:toast/toast.dart';
import 'package:dart_notification_center/dart_notification_center.dart';


String formattedDate = '';
double stepsFromHealth = 0;

class TrackTab_Details extends StatefulWidget {
  @override
  _TrackTab_DetailsState createState() => _TrackTab_DetailsState();
}

class _TrackTab_DetailsState extends State<TrackTab_Details> {
  double _value = 1000;
  double _valueWater = 500;
  double _valueExercises = 15;
  int selectedBreakfastFeel = 0;

  double drop = 0;
  double exercise = 0;

  String trackForDates = '';
  double steps = 0;

  @override
  void initState() {
    var newDateTimeObj2 = DateFormat('yyyy_MMM_dd').parse(formattedDate);

    var formatter = DateFormat('yyyy MMM dd');
    trackForDates = formatter.format(newDateTimeObj2);

    Future.delayed(Duration(milliseconds:1),() {
      getTrackDetails();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  getTrackDetails() {
    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) {
      // print(Firestore.instance.collection(tblTracks)
      //     .document(value.email+kFireBaseConnect+value.uid).collection(value.uid).document(formattedDate).path);
      Firestore.instance.collection(tblTracks)
          .document(value.email+kFireBaseConnect+value.uid).collection(value.uid).document(formattedDate)
          .get().then((value) {
        dismissLoading(context);

        _value = double.parse(value.data[kSteps]);

        _valueWater = double.parse(value.data[kWater]);
        _valueExercises = double.parse(value.data[kExerciseTime]);
        selectedBreakfastFeel = int.parse(value.data[kAchieveGoal]);
        
        steps = double.parse((stepsFromHealth / 8000).toStringAsFixed(1));

        drop = double.parse((_valueWater / 2000).toStringAsFixed(1));
        exercise = double.parse((_valueExercises / 60).toStringAsFixed(1));

        setTrackCricular();

        setState(() {

        });
      });
    }).catchError((error) {
      dismissLoading(context);
    });
  }

  setTrackCricular() {
    if (steps == 1000) {
      steps = 0;
    } else if (steps < 8001 && steps > 1000) {
      steps = double.parse((steps / 8000).toStringAsFixed(1));
    } else {
      steps = 1;
    }

    if (drop == 500) {
      drop = 0;
    } else if (drop < 2001 && drop > 500) {
      drop = double.parse((drop / 2000).toStringAsFixed(1));
    } else {
      drop = 1;
    }

    if (exercise == 15) {
      exercise = 0;
    } else if (exercise < 60 && exercise > 15) {
      exercise = double.parse((exercise / 60).toStringAsFixed(1));
    } else {
      exercise = 1;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
        ),
        body: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left:0, right: 20, top: 30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 0.4, color: HexColor('#BEBEBE')),
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon:Icon(
                            Icons.arrow_back,
                            color:Colors.black,
                            size:36,
                          ),
                          onPressed:() {
                            Navigator.pop(context);

                            DartNotificationCenter.post(
                              channel:tblTracks,
                              options:'',
                            );
                          }),
                      SizedBox(width:10,),
                      Text(
                        'Track',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: AppConstant.kPoppins,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      SizedBox(width:10,),
                      Text(
                        ' $trackForDates',
                        style: TextStyle(
                            color:HexColor('54C9AF'),
                            fontFamily:AppConstant.kPoppins,
                            fontWeight:FontWeight.w600,
                            fontSize:19),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 80, left: 0, right: 0),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top:0, bottom:30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:EdgeInsets.only(left: 20, right: 20, top:20),
                              child:Text(
                                'How many steps have you done today?',
                                style:TextStyle(
                                    color:HexColor('#84828F'),
                                    fontFamily:AppConstant.kPoppins,
                                    fontWeight:FontWeight.w500,
                                    fontSize:16),
                              ),
                            ),
                            Container(
                              margin:EdgeInsets.only(right:24),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      height:80,
                                      width: MediaQuery.of(context).size.width - 104,
                                      alignment: Alignment.bottomLeft,
                                      margin:EdgeInsets.only(left:0,right:0, bottom: 0),
                                      child:Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          SliderTheme(
                                            data:SliderTheme.of(context).copyWith(
                                              thumbColor: HexColor('#54C9AF'),
                                              valueIndicatorColor: HexColor('#54C9AF'),
                                              activeTrackColor: HexColor('#54C9AF'),
                                              inactiveTrackColor: HexColor('#C5C5C5'),
                                              trackHeight: 5,
                                              thumbShape:RoundSliderThumbShape(enabledThumbRadius: 14.0),
                                              trackShape:RoundedRectSliderTrackShape(),
                                            ),
                                            child:IgnorePointer(
                                              ignoring:true,
                                              child:Slider(
                                                label:(_value.toInt()).toString() + ' Steps ',
                                                value:_value,
                                                onChanged:(value) {
                                                  setState(() {
                                                    _value = value;
//                                                  steps = value;

                                                    setTrackCricular();
                                                  });
                                                },
                                                // min:1000,
                                                min:0,
                                                max:20000,
                                                divisions:20000,
                                              ),
                                            )
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20, right: 20),
                                            child:Row(
                                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                              children:<Widget>[
                                                Text(
                                                  '1000',
                                                  style:TextStyle(
                                                      color:HexColor('#84828F'),
                                                      fontFamily:AppConstant.kPoppins,
                                                      fontWeight:FontWeight.normal,
                                                      fontSize:12),
                                                ),
                                                Text(
                                                  '20000',
                                                  style: TextStyle(
                                                      color: HexColor('#84828F'),
                                                      fontFamily: AppConstant.kPoppins,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                  ),
                                  Container(
                                    height:80,
                                    width:80,
                                    child:Stack(
                                      children: [
                                        Positioned(
                                          top:0,
                                          bottom:0,
                                          left:0,
                                          right:0,
                                          child:CircularPercentIndicator(

                                            radius:67.0,
                                            lineWidth:3,
//                                    animation:true,
                                            percent:steps,
                                            backgroundColor:Colors.grey.withOpacity(0.8),
                                            circularStrokeCap:CircularStrokeCap.round,
                                            progressColor:AppConstant.color_blue_dark,
                                          ),
                                        ),
                                        Center(
                                          child:Image.asset(
                                            Res.steps,
                                            height:40,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                              child: Text(
                                'How much water have you drank today?',
                                style: TextStyle(
                                    color: HexColor('#84828F'),
                                    fontFamily: AppConstant.kPoppins,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),




                            Container(
                              margin: EdgeInsets.only(right: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      height: 80,
                                      width: MediaQuery.of(context).size.width - 104,
                                      alignment: Alignment.bottomLeft,
                                      margin:EdgeInsets.only(left:0,right:0, bottom: 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          SliderTheme(
                                            data:SliderTheme.of(context).copyWith(
                                              thumbColor: HexColor('#54C9AF'),
                                              valueIndicatorColor: HexColor('#54C9AF'),
                                              activeTrackColor: HexColor('#54C9AF'),
                                              inactiveTrackColor: HexColor('#C5C5C5'),
                                              trackHeight: 5,
                                              thumbShape:RoundSliderThumbShape(enabledThumbRadius: 14.0),
                                              trackShape:RoundedRectSliderTrackShape(),
                                            ),
                                            child: Slider(
                                              label: (_valueWater > 999)
                                                  ? ((_valueWater.toInt()) / 1000)
                                                  .toStringAsFixed(1) +
                                                  ' L '
                                                  : (_valueWater.toInt()).toString() +
                                                  ' ML ',
                                              value: _valueWater,
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueWater = value;
                                                  drop = value;

                                                  setTrackCricular();

                                                });
                                              },
                                              min:500,
                                              max:3000,
                                              divisions:3000,
                                            ),
                                          ),
                                          Container(
                                            margin:
                                            EdgeInsets.only(left: 20, right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  '500 ML',
                                                  style: TextStyle(
                                                      color: HexColor('#84828F'),
                                                      fontFamily: AppConstant.kPoppins,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  '3 L',
                                                  style: TextStyle(
                                                      color: HexColor('#84828F'),
                                                      fontFamily: AppConstant.kPoppins,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                  Container(
                                    height:80,
                                    width:80,
                                    child:Stack(
                                      children: [
                                        Positioned(
                                          top:0,
                                          bottom:0,
                                          left:0,
                                          right:0,
                                          child:CircularPercentIndicator(
                                            radius:67.0,
                                            lineWidth:3,
//                                    animation:true,
                                            percent:drop,
                                            backgroundColor:Colors.grey.withOpacity(0.8),
                                            circularStrokeCap:CircularStrokeCap.round,
                                            progressColor:AppConstant.color_blue_dark,
                                          ),
                                        ),
                                        Center(
                                          child:Image.asset(
                                            Res.drop,
                                            height:35,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                              child: Text(
                                'How many minutes of exercise have you done today?',
                                style: TextStyle(
                                    color: HexColor('#84828F'),
                                    fontFamily: AppConstant.kPoppins,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      height: 80,
                                      width: MediaQuery.of(context).size.width - 104,
                                      alignment: Alignment.bottomLeft,
                                      margin:EdgeInsets.only(left:0,right:0, bottom: 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          SliderTheme(
                                            data: SliderTheme.of(context).copyWith(
                                              thumbColor: HexColor('#54C9AF'),
                                              valueIndicatorColor: HexColor('#54C9AF'),
                                              activeTrackColor: HexColor('#54C9AF'),
                                              inactiveTrackColor: HexColor('#C5C5C5'),
                                              trackHeight: 5,
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 14.0),
                                              trackShape: RoundedRectSliderTrackShape(),
                                            ),
                                            child: Slider(
                                              label: (_valueExercises > 59)
                                                  ? ((_valueExercises.toInt()) / 60)
                                                  .toStringAsFixed(0) +
                                                  ' Hour'
                                                  : (_valueExercises.toInt())
                                                  .toString() +
                                                  ' Min',
                                              value: _valueExercises,
                                              onChanged: (value) {
                                                setState(() {
                                                  _valueExercises = value;
                                                  exercise = value;
                                                  setTrackCricular();
                                                });
                                              },
                                              min:15,
                                              max:120,
                                              divisions:120,
                                            ),
                                          ),
                                          Container(
                                            margin:
                                            EdgeInsets.only(left: 20, right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  '15 Min',
                                                  style: TextStyle(
                                                      color: HexColor('#84828F'),
                                                      fontFamily: AppConstant.kPoppins,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  '2 Hour',
                                                  style: TextStyle(
                                                      color: HexColor('#84828F'),
                                                      fontFamily: AppConstant.kPoppins,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                  Container(
                                    height:80,
                                    width:80,
                                    child:Stack(
                                      children: [
                                        Positioned(
                                          top:0,
                                          bottom:0,
                                          left:0,
                                          right:0,
                                          child:CircularPercentIndicator(
                                            radius:67.0,
                                            lineWidth:3,
//                                    animation:true,
                                            percent:exercise,
                                            backgroundColor:Colors.grey.withOpacity(0.8),
                                            circularStrokeCap:CircularStrokeCap.round,
                                            progressColor:AppConstant.color_blue_dark,
                                          ),
                                        ),
                                        Center(
                                          child:Image.asset(
                                            Res.heart,
                                            height: 29,
                                            width: 34,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                              child: Text(
                                'Did you achieve your personal goal today?',
                                style: TextStyle(
                                    color: HexColor('#84828F'),
                                    fontFamily: AppConstant.kPoppins,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    height: 26,
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width / 2 - 30,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      textColor: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            (selectedBreakfastFeel == 1)
                                                ? Res.selectedGoalsDetails
                                                : Res.unselectedGoalDetails,
                                            height: 24,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Yes',
                                            style: TextStyle(
                                                color: HexColor('#54C9AF'),
                                                fontFamily: AppConstant.kPoppins,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedBreakfastFeel = 1;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    height: 26,
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width / 2 - 30,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(0),
                                      textColor: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset(
                                            (selectedBreakfastFeel == 2)
                                                ? Res.selectedGoalsDetails
                                                : Res.unselectedGoalDetails,
                                            height: 24,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'No',
                                            style: TextStyle(
                                                color: HexColor('#54C9AF'),
                                                fontFamily: AppConstant.kPoppins,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedBreakfastFeel = 2;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30, right: 30, top: 50),
                              padding: EdgeInsets.all(0),
                              width: double.infinity,
                              height: 54,
                              decoration: kButtonThemeGradientColor(),
                              child: FlatButton(
                                  textColor: Colors.white,
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: AppConstant.kPoppins,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16),
                                  ),
                                  onPressed: () {
                                    showLoading(context);
                                    FirebaseAuth.instance.currentUser().then((value) {
                                      Firestore.instance.collection(tblTracks).document(value.email + kFireBaseConnect + value.uid).collection(value.uid).document(formattedDate)
                                          .updateData({
                                        kSteps:_value.toInt().toString(),
                                        kWater:_valueWater.toInt().toString(),
                                        kExerciseTime:_valueExercises.toInt().toString(),
                                        kAchieveGoal:selectedBreakfastFeel.toString(),
                                      }).then((value) {
                                        dismissLoading(context);
                                        Toast.show(
                                    'Track is added successfully.', context,
                                    backgroundColor: HexColor(greenColor));
                                      });
                                    }).catchError((error) {
                                      dismissLoading(context);
                                      Toast.show(
                                          error.message.toString(), context,
                                          backgroundColor: HexColor(redColor)
                                      );
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            )));
  }
}





