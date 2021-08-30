
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alfa/utils/Constents.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:alfa/screen/TrackTab_Details.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/health.dart';
import 'package:dart_notification_center/dart_notification_center.dart';
import 'package:toast/toast.dart';


class TrackTab extends StatefulWidget {
  @override
  _TrackTabState createState() => _TrackTabState();
}



class _TrackTabState extends State<TrackTab> {
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime(2019, 2, 3));
  DateTime _targetDateTime = DateTime(2019, 2, 3);

  DateTime endDate = DateTime.now();

  var valueStepsCount = 0.0;

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  EventList<Event> _markedDateMap = EventList<Event>();

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child:Icon(
      Icons.person,
      color:Colors.amber,
    ),
  );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    var formatter = DateFormat('yyyy_MMM_dd');
    formattedDate = formatter.format(DateTime.now());
    stepsFromHealth = valueStepsCount;

    Future.delayed(Duration(milliseconds:1),() async {
      getTrackDetails();
      funcGetStepsFromDevice();
    });

    DartNotificationCenter.subscribe(channel:tblTracks,observer:this,onNotification: (result) {
      getTrackDetails();
    },);

    // TODO: implement initState
    super.initState();
  }

  void funcGetStepsFromDevice() async {
    var year = endDate.year;
    var month = endDate.month;
    var day = endDate.day;

    DateTime startDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse('$year-$month-$day 00:00:00');
    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
//        HealthDataType.BODY_MASS_INDEX,
      HealthDataType.STEPS,
//        HealthDataType.WEIGHT,
//        HealthDataType.BODY_MASS_INDEX,
//        HealthDataType.WEIGHT,
//        HealthDataType.ACTIVE_ENERGY_BURNED,
//        HealthDataType.WATER,
//        HealthDataType.BODY_TEMPERATURE,
//        HealthDataType.MINDFULNESS,
    ];

    /// Fetch new data
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, types);
//      print(healthData);

    for (int i=0; i<healthData.length;i++) {
      var dictHealthData = healthData[i].toJson();
//        print(dictHealthData);
//        print(dictHealthData['value']);
//        print(dictHealthData['unit']);
//        print(dictHealthData['data_type']);
//        print(dictHealthData['platform_type']);

      valueStepsCount = valueStepsCount+dictHealthData['value'];
    }

    // print('stepsstepsstepsstepsstepssteps');
    // print(valueStepsCount);

    getTrackDetailsWithDate();
  }

  getTrackDetailsWithDate() {
    FirebaseAuth.instance.currentUser().then((value) {
      Firestore.instance.collection(tblTracks)
          .document(value.email+kFireBaseConnect+value.uid).collection(value.uid).document(formattedDate)
          .get().then((value) {
            if (value.data == null) {
              funcSetData();
            } else {
              funcUpdateData();
            }
      });
    }).catchError((error) {
      dismissLoading(context);
    });
  }

  getTrackDetails() async {
    showLoading(context);

    FirebaseAuth.instance.currentUser().then((value) async {
      QuerySnapshot querySnapshot = await Firestore.instance.collection(tblTracks).document(value.email+kFireBaseConnect+value.uid)
          .collection(value.uid).getDocuments();
      // print('querySnapshot.documentsquerySnapshot.documentsquerySnapshot.documentsquerySnapshot.documents');
      // print(querySnapshot.documents.length);

      for (int i = 0; i < querySnapshot.documents.length; i++) {
        var a = querySnapshot.documents[i];
//        print(a.documentID);

        var newDateTimeObj2 = DateFormat('yyyy_MMM_dd').parse(a.documentID);
//        print(newDateTimeObj2);

        _markedDateMap.add(
            newDateTimeObj2,
            Event(
              date:newDateTimeObj2,
              title: 'Event 5',
              icon: _eventIcon,
            ));
      }

      setState(() {

      });
      dismissLoading(context);
    }).catchError((error) {
      dismissLoading(context);
    });
  }

  funcSetData() {
//    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) {
      Firestore.instance.collection(tblTracks).document(value.email + kFireBaseConnect + value.uid)
          .collection(value.uid).document(formattedDate)
          .setData({
        kSteps:valueStepsCount.toString(),
        kWater:'500',
        kExerciseTime:'15',
        kAchieveGoal:'0',
      }).then((value) {
//        dismissLoading(context);
//        Toast.show(
//            'Track is added successfully.', context,
//            backgroundColor: HexColor(greenColor));
      });
    }).catchError((error) {
//      dismissLoading(context);
      Toast.show(
          error.message.toString(),
          context,
          backgroundColor: HexColor(redColor));
    });
  }

  funcUpdateData() {
    FirebaseAuth.instance.currentUser().then((value) {
      Firestore.instance.collection(tblTracks).document(value.email + kFireBaseConnect + value.uid).collection(value.uid).document(formattedDate)
          .updateData({
        kSteps:valueStepsCount.toString()
      }).then((value) {
//        dismissLoading(context);
//        Toast.show(
//            'Track is added successfully.', context,
//            backgroundColor: HexColor(greenColor));
      });
    }).catchError((error) {
//      dismissLoading(context);
      Toast.show(
          error.message.toString(),
          context,
          backgroundColor: HexColor(redColor));
    });
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
              padding: EdgeInsets.only(left: 20, right: 20, top: 30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 0.4, color: HexColor('#BEBEBE')),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Track',
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
                  margin:EdgeInsets.only(top:80, left:10, right:10),
                  child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:[
                      Container(
                        height:450,
                        width:double.infinity,
                        child:CalendarCarousel<Event>(

                          onDayPressed: (DateTime date, List<Event> events) {
                            this.setState(() => _currentDate2 = date);
                            events.forEach((event) {
                              // print(event.title);
                            });
                          },

                          nextDaysTextStyle:TextStyle(
                              color:Colors.grey,
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.normal,
                              fontSize:20
                          ),
                          daysHaveCircularBorder:false,
                          showOnlyCurrentMonthDate:false,
                          daysTextStyle:TextStyle(
                              color:HexColor('2E4877'),
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.normal,
                              fontSize:20),
                          weekendTextStyle:TextStyle(
                              color:Colors.red,
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.w400,
                              fontSize:20),

                          weekFormat:false,
                          firstDayOfWeek:1,
                          markedDatesMap:_markedDateMap,
                          targetDateTime:_currentDate2,
                          customGridViewPhysics:NeverScrollableScrollPhysics(),

                          markedDateCustomShapeBorder:CircleBorder(
                              side:BorderSide(color:HexColor('54C9AF'))
                          ),
                          markedDateCustomTextStyle:TextStyle(
                              color:HexColor('29364E'),
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.normal,
                              fontSize:20),
                          showHeader:true,
                          weekdayTextStyle:TextStyle(
                              color:HexColor('2E4877'),
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.w500,
                              fontSize:18),
                          headerTextStyle:TextStyle(
                              color:HexColor('2E4877'),
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.w600,
                              fontSize:22),
                          todayTextStyle:TextStyle(
                              color:HexColor('29364E'),
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.normal,
                              fontSize:20),
                          markedDateShowIcon:true,
                          iconColor:HexColor('29364E'),
                          leftButtonIcon:Icon(Icons.arrow_back_ios,size:25,color:HexColor('29364E')),
                          rightButtonIcon:Icon(Icons.arrow_forward_ios,size:25,color:HexColor('29364E')),

                          selectedDayBorderColor:Colors.white,
                          selectedDayButtonColor:HexColor('54C9AF'),
                          selectedDayTextStyle: TextStyle(
                              color:Colors.white,
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.normal,
                              fontSize:20),
                          minSelectedDate:DateTime.now().subtract(Duration(days: 360)),
                          maxSelectedDate:DateTime.now().add(Duration(days:3360)),
                          selectedDateTime:DateTime.now(),
                          prevDaysTextStyle: TextStyle(
                              color:Colors.grey,
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.normal,
                              fontSize:18),

                          inactiveDaysTextStyle:TextStyle(
                              color:Colors.grey,
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.normal,
                              fontSize:20
                          ),

                          onCalendarChanged: (DateTime date) {
                            this.setState(() {
                              // print('datedatedatedatedatedatedate');
                              endDate = date;

                              funcGetStepsFromDevice();

                              _targetDateTime = date;
                              _currentMonth = DateFormat.yMMM().format(DateTime.now());
                            });
                          },

                          onDayLongPressed: (DateTime date) {
                            var formatter = DateFormat('yyyy_MMM_dd');
                            formattedDate = formatter.format(date);
                            stepsFromHealth = valueStepsCount;

                            // print('long pressed date $formattedDate');
                            Navigator.pushNamed(context, '/TrackTab_Details');
                          },
                        ),
                      ),
                      Text(
                        'Long press to get track details on the date.',
                        style:TextStyle(
                            color:Colors.black,
                            fontFamily:AppConstant.kPoppins,
                            fontWeight:FontWeight.w500,
                            fontSize:12),
                      ),
                    ],
                  )
                ))
          ],
        )));
  }
}
