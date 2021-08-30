import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:g2x_week_calendar/g2x_simple_week_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:dart_notification_center/dart_notification_center.dart';


class FoodDiaryTab extends StatefulWidget {
  @override
  _FoodDiaryTabState createState() => _FoodDiaryTabState();
}

class _FoodDiaryTabState extends State<FoodDiaryTab> {
//  var arrWeeks = ['First week','Second week','Third week','Fourth week'];
  var indexSelected = -1;
  String formattedDate = '';

  String strBreakfast = '0';
  String strLunch = '0';
  String strDinner = '0';
  String strSnacks = '0';
  String strTotal = '0';



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var now = DateTime.now();
    var formatter = DateFormat('yyyy_MMM_dd');
    formattedDate = formatter.format(now);
    print(formattedDate);

    Future.delayed(Duration(milliseconds:1),() {
      getFoodDetailsBreakfast();
      getFoodDetailsDinner();
      getFoodDetailsLunch();
      getFoodDetailsSnacks();

      DartNotificationCenter.subscribe(channel:tblFoodDetails,observer:this,onNotification: (result) {
        getFoodDetailsBreakfast();
        getFoodDetailsDinner();
        getFoodDetailsLunch();
        getFoodDetailsSnacks();
      },
      );

    });
  }

  getFoodDetailsBreakfast() {
    FirebaseAuth.instance.currentUser().then((value) async {
      Firestore.instance.collection(tblFoodDetails).document(value.email + kFireBaseConnect + value.uid)
          .collection(formattedDate).document(kBreakfast)
          .get().then((value) {
        print(value.data);

        if (value.data != null && value.data.isNotEmpty) {
          print(value.data[kCalories]);
          strBreakfast = value.data[kCalories];
        }

        var totalCalories = int.parse(strBreakfast)+int.parse(strLunch)+int.parse(strDinner)+int.parse(strSnacks);
        strTotal = totalCalories.toString();

        setState(() {

        });
    });
  });
  }

  getFoodDetailsDinner() {
    FirebaseAuth.instance.currentUser().then((value) async {
      Firestore.instance.collection(tblFoodDetails).document(value.email + kFireBaseConnect + value.uid)
          .collection(formattedDate).document(kDinner)
          .get().then((value) {
        print(value.data);

        if (value.data != null && value.data.isNotEmpty) {
          print(value.data[kCalories]);
          strDinner = value.data[kCalories];
        }

        var totalCalories = int.parse(strBreakfast)+int.parse(strLunch)+int.parse(strDinner)+int.parse(strSnacks);
        strTotal = totalCalories.toString();

        setState(() {

        });
      });
    });
  }

  getFoodDetailsLunch() {
    FirebaseAuth.instance.currentUser().then((value) async {
      Firestore.instance.collection(tblFoodDetails).document(value.email + kFireBaseConnect + value.uid)
          .collection(formattedDate).document(kLunch)
          .get().then((value) {
        print(value.data);

        if (value.data != null && value.data.isNotEmpty) {
          print(value.data[kCalories]);
          strLunch = value.data[kCalories];
        }

        var totalCalories = int.parse(strBreakfast)+int.parse(strLunch)+int.parse(strDinner)+int.parse(strSnacks);
        strTotal = totalCalories.toString();

        setState(() {

        });
      });
    });
  }

  getFoodDetailsSnacks() {
    FirebaseAuth.instance.currentUser().then((value) async {
      Firestore.instance.collection(tblFoodDetails).document(value.email + kFireBaseConnect + value.uid)
          .collection(formattedDate).document(kSnacks)
          .get().then((value) {
        print(value.data);

        if (value.data != null && value.data.isNotEmpty) {
          print(value.data[kCalories]);
          strSnacks = value.data[kCalories];
        }

        var totalCalories = int.parse(strBreakfast)+int.parse(strLunch)+int.parse(strDinner)+int.parse(strSnacks);
        strTotal = totalCalories.toString();

        setState(() {

        });
      });
    });
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
                  padding:EdgeInsets.only(left:25,right:25,top:20),
//                  decoration:BoxDecoration(
//                      border:Border(
//                        bottom: BorderSide(
//                            width:0.4,
//                            color:HexColor('#BEBEBE')
//                        ),
//                      )
//                  ),
                  child:Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:<Widget>[
                      Container(
                        padding:EdgeInsets.only(top:4),
                        child:Text(
                          'Food Diary',
                          style:TextStyle(
                              color:Colors.black,
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.bold,
                              fontSize:30
                          ),
                        ),
                      ),
                      Container(
                        padding:EdgeInsets.only(bottom:8),
                        child:Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          crossAxisAlignment:CrossAxisAlignment.center,
                          children:<Widget>[
                            IconButton(
                              icon:Icon(
                                  Icons.add_circle,
                                  size:40,
                                  color:AppConstant.color_blue_dark,
                              ),
                              onPressed:() {
                                Navigator.pushNamed(context, '/AddFood');
                              },
                            ),
                            IconButton(
                              icon:Icon(
                                Icons.watch_later,
                                size:40,
                                color:HexColor('#54C9AF'),
                              ),
                              onPressed:() {
                                Navigator.pushNamed(context, '/FoodHistory');
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                    child:Container(
                      margin:EdgeInsets.only(top:78),
                      child:SingleChildScrollView(
                        padding:EdgeInsets.only(top:10,bottom:30),
                        child:Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children:<Widget>[
                            Container(
                              decoration:BoxDecoration(
                                border: Border(
                                  bottom:BorderSide( //                    <--- top side
                                    color:Colors.grey,
                                    width:0.5,
                                  ),
                                ),
                              ),
                              child: G2xSimpleWeekCalendar(
                                90.0, DateTime.now(),
                                dateCallback: (date) {
                                  print(date);

                                  var formatter = DateFormat('yyyy_MMM_dd');
                                  formattedDate = formatter.format(date);
                                  print(formattedDate);

                                  strBreakfast = '0';
                                  strLunch = '0';
                                  strDinner = '0';
                                  strSnacks = '0';
                                  strTotal = '0';

                                  getFoodDetailsBreakfast();
                                  getFoodDetailsDinner();
                                  getFoodDetailsLunch();
                                  getFoodDetailsSnacks();
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
                                selectedTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppConstant.kPoppins,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                                selectedBackgroundDecoration: BoxDecoration(
                                    color: AppConstant.color_blue_dark,
                                    borderRadius: BorderRadius.circular(30)),
                                strWeekDays: ['Su','Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa',],
                                defaultTextStyle: TextStyle(
                                    color: AppConstant.color_blue_dark,
                                    fontFamily: AppConstant.kPoppins,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                            ),

//                            Center(
//                              child:Container(
//                                height:44,
//                                width:220,
//                                margin:EdgeInsets.only(top:10),
//                                alignment:Alignment.center,
//                                decoration:BoxDecoration(
//                                    color:HexColor('#EDEDED'),
//                                    borderRadius:BorderRadius.circular(40)
//                                ),
//                                child:Row(
//                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    IconButton(
//                                      icon:Icon(
//                                          Icons.arrow_back_ios,
//                                          size:20,
//                                          color:AppConstant.color_blue_dark,
//                                      ),
//                                      onPressed:() {
//                                        print('back date');
//                                      },
//                                    ),
//                                    Text(
//                                      'Today, 12 June',
//                                      style:TextStyle(
//                                          color:AppConstant.color_blue_dark,
//                                          fontFamily:AppConstant.kPoppins,
//                                          fontWeight:FontWeight.normal,
//                                          fontSize:16
//                                      ),
//                                    ),
//                                    IconButton(
//                                      icon:Icon(
//                                        Icons.arrow_forward_ios,
//                                        size:20,
//                                        color:AppConstant.color_blue_dark,
//                                      ),
//                                      onPressed:() {
//                                        print('next date');
//                                      },
//                                    ),
//                                  ],
//                                )
//                              ),
//                            ),
//                            Container(
//                              height:44,
//                              margin:EdgeInsets.only(top:20),
//                              child:ListView.builder(
//                                padding:EdgeInsets.only(left:20,right:0),
//                                scrollDirection:Axis.horizontal,
//                                itemCount:arrWeeks.length,
//                                itemBuilder:(context, index) {
//                                  return GestureDetector(
//                                    child:Container(
//                                      height:44,
//                                      width:140,
//                                      margin:EdgeInsets.only(right:20),
//                                      decoration:BoxDecoration(
//                                          color:HexColor('##EDEDED'),
//                                          borderRadius:BorderRadius.circular(40)
//                                      ),
//                                      alignment:Alignment.center,
//                                      child:Text(
//                                        arrWeeks[index],
//                                        style:TextStyle(
//                                            color: (indexSelected == index)
//                                                ? AppConstant.color_blue_dark
//                                                : Colors.grey,
//                                            fontFamily:AppConstant.kPoppins,
//                                            fontWeight:FontWeight.w400,
//                                            fontSize:15
//                                        ),
//                                      ),
//                                    ),
//                                    onTap:() {
//                                      indexSelected = index;
//                                      setState(() {
//
//                                      });
//                                    },
//                                  );
//                                },
//                              ),
//                            ),
                            Center(
                              child:Container(
                                margin:EdgeInsets.only(top:50,bottom:50),
                                width:MediaQuery.of(context).size.width-150,
                                height:MediaQuery.of(context).size.width-150,
                                decoration:BoxDecoration(
                                  color:Colors.white,
                                  borderRadius:BorderRadius.circular(
                                      (MediaQuery.of(context).size.width-150)/2
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:AppConstant.color_blue_dark,
                                      blurRadius:10,
                                      spreadRadius:3,
                                      offset: Offset(0,0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                child:Stack(
                                  children: <Widget>[
                                    Positioned(
                                      top:0,
                                      bottom:0,
                                      left:0,
                                      right:0,
                                      child:



//                                      CircularPercentIndicator(
////                                        radius:double.infinity,
//                                        radius:MediaQuery.of(context).size.width-156,
//                                        lineWidth:12,
////                                    animation:true,
//                                        percent:0.6,
//                                        backgroundColor:HexColor('F2F2F2'),
//                                        circularStrokeCap:CircularStrokeCap.square,
//                                        progressColor:AppConstant.color_blue_dark,
//                                      ),



                                      CircularProgressIndicator(
                                        value:int.parse(strTotal)/2000,
                                        strokeWidth:12,

                                        valueColor:AlwaysStoppedAnimation<Color>(
                                          AppConstant.color_blue_dark,
                                        ),
                                        backgroundColor:HexColor('F2F2F2'),
                                      ),
                                    ),
                                    Positioned(
                                      top:0,
                                      bottom:0,
                                      left:0,
                                      right:0,
                                      child:Column(
                                        crossAxisAlignment:CrossAxisAlignment.center,
                                        mainAxisAlignment:MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            strTotal,
                                            style:TextStyle(
                                                color:Colors.black,
                                                fontFamily:AppConstant.kPoppins,
                                                fontWeight:FontWeight.w600,
                                                fontSize:40
                                            ),
                                          ),
                                          Text(
                                            'kcal',
                                            style:TextStyle(
                                                color:Colors.black,
                                                fontFamily:AppConstant.kPoppins,
                                                fontWeight:FontWeight.normal,
                                                fontSize:16
                                            ),
                                          ),
//                                          Text(
//                                            '2,280',
//                                            style:TextStyle(
//                                                color:Colors.black,
//                                                fontFamily:AppConstant.kPoppins,
//                                                fontWeight:FontWeight.w600,
//                                                fontSize:23
//                                            ),
//
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ),
                            ),
                            Container(
                              width:MediaQuery.of(context).size.width,
                              padding:EdgeInsets.only(left:20,right:20),
                              child:Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          width:MediaQuery.of(context).size.width/2-35,
                                          child:Column(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Breakfast',
                                                style:TextStyle(
                                                    color:Colors.black,
                                                    fontFamily:AppConstant.kPoppins,
                                                    fontWeight:FontWeight.w600,
                                                    fontSize:18
                                                ),
                                              ),
                                              SizedBox(height:5),
                                              ClipRRect(
                                                borderRadius:BorderRadius.circular(8),
                                                child:Container(
                                                  height:6,
                                                  child:LinearProgressIndicator(
                                                    value:int.parse(strBreakfast)/500,
                                                    valueColor:AlwaysStoppedAnimation<Color>(
                                                        HexColor('FAA177')
                                                    ),
                                                    backgroundColor:HexColor('FAA177').withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height:7),
                                              Text(
                                                '${strBreakfast} (500 cal)',
                                                style:TextStyle(
                                                    color:HexColor('#84828F'),
                                                    fontFamily:AppConstant.kPoppins,
                                                    fontWeight:FontWeight.normal,
                                                    fontSize:14
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      SizedBox(width:30),
                                      Container(
                                          width:MediaQuery.of(context).size.width/2-35,
                                          child:Column(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Lunch',
                                                style:TextStyle(
                                                    color:Colors.black,
                                                    fontFamily:AppConstant.kPoppins,
                                                    fontWeight:FontWeight.w600,
                                                    fontSize:18
                                                ),
                                              ),
                                              SizedBox(height:5),
                                              ClipRRect(
                                                borderRadius:BorderRadius.circular(8),
                                                child:Container(
                                                  height:6,
                                                  child:LinearProgressIndicator(
                                                    value:int.parse(strLunch)/500,
                                                    valueColor:AlwaysStoppedAnimation<Color>(
                                                        HexColor('46CEB0')
                                                    ),
                                                    backgroundColor:HexColor('46CEB0').withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height:7),
                                              Text(
                                                '${strLunch} (500 cal)',
                                                style:TextStyle(
                                                    color:HexColor('#84828F'),
                                                    fontFamily:AppConstant.kPoppins,
                                                    fontWeight:FontWeight.normal,
                                                    fontSize:14
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                  SizedBox(height:30)
,                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          width:MediaQuery.of(context).size.width/2-35,
                                          child:Column(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Dinner',
                                                style:TextStyle(
                                                    color:Colors.black,
                                                    fontFamily:AppConstant.kPoppins,
                                                    fontWeight:FontWeight.w600,
                                                    fontSize:18
                                                ),
                                              ),
                                              SizedBox(height:5),
                                              ClipRRect(
                                                borderRadius:BorderRadius.circular(8),
                                                child:Container(
                                                  height:6,
                                                  child:LinearProgressIndicator(
                                                    value:int.parse(strDinner)/500,
                                                    valueColor:AlwaysStoppedAnimation<Color>(
                                                        HexColor('BA5595')
                                                    ),
                                                    backgroundColor:HexColor('BA5595').withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height:7),
                                              Text(
                                                '${strDinner} (500 cal)',
                                                style:TextStyle(
                                                    color:HexColor('#84828F'),
                                                    fontFamily:AppConstant.kPoppins,
                                                    fontWeight:FontWeight.normal,
                                                    fontSize:14
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      SizedBox(width:30),
                                      Container(
                                          width:MediaQuery.of(context).size.width/2-35,
                                          child:Column(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Snacks',
                                                style:TextStyle(
                                                    color:Colors.black,
                                                    fontFamily:AppConstant.kPoppins,
                                                    fontWeight:FontWeight.w600,
                                                    fontSize:18
                                                ),
                                              ),
                                              SizedBox(height:5),
                                              ClipRRect(
                                                borderRadius:BorderRadius.circular(8),
                                                child:Container(
                                                  height:6,
                                                  child:LinearProgressIndicator(
                                                    value:int.parse(strSnacks)/500,
                                                    valueColor:AlwaysStoppedAnimation<Color>(
                                                        HexColor('#4871BA')
                                                    ),
                                                    backgroundColor:HexColor('#4871BA').withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height:7),
                                              Text(
                                                '${strSnacks} (500 cal)',
                                                style:TextStyle(
                                                    color:HexColor('#84828F'),
                                                    fontFamily:AppConstant.kPoppins,
                                                    fontWeight:FontWeight.normal,
                                                    fontSize:14
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ),
              ],
            )
        )
    );
  }
}
