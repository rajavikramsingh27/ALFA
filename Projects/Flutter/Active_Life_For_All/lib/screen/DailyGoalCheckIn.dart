import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:alfa/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';
import 'package:g2x_week_calendar/g2x_simple_week_calendar.dart';
import 'package:intl/intl.dart';

class DailyGoalCheckIn extends StatefulWidget {
  @override
  _DailyGoalCheckInState createState() => _DailyGoalCheckInState();
}


class _DailyGoalCheckInState extends State<DailyGoalCheckIn> {
  bool isDidYouAchieveYour_Health_FitnessGoal = false;
  bool isDidYouAchieveYour_Work_PersonalGoal = false;

  var textWhatAreYou_GratFul_ForToday = TextEditingController();
  var textWhatIsYour_Health_Fitness_Goal = TextEditingController();
  var textWhatIsYourWork_Personal_LifeGoal = TextEditingController();
  var textWhatCouldIDoBetterTomorrow = TextEditingController();
  String formattedDate = '';

  @override
  void initState() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy_MMM_dd');
    formattedDate = formatter.format(now);

    Future.delayed(Duration(milliseconds:5),() {
      getTracks();
    });

    // TODO: implement initState
    super.initState();
  }

  getTracks() {
    FirebaseAuth.instance.currentUser().then((value) {
      Firestore.instance.collection(tblGoals).document(value.email + kFireBaseConnect + value.uid).collection(formattedDate).document(formattedDate)
          .get().then((value) {
        if (value.data == null) {
          setGoals();
        } else {
          textWhatAreYou_GratFul_ForToday.text = '';
          textWhatIsYour_Health_Fitness_Goal.text = '';
          textWhatIsYourWork_Personal_LifeGoal.text = '';
          textWhatCouldIDoBetterTomorrow.text = '';
          isDidYouAchieveYour_Health_FitnessGoal = false;
          isDidYouAchieveYour_Work_PersonalGoal = false;

          var dictDailyGoalsCheckIn = Map<String,dynamic>.from(value.data[kDailyGoalsCheckIn]);
          setState(() {
            if (dictDailyGoalsCheckIn != null) {
              textWhatAreYou_GratFul_ForToday.text = dictDailyGoalsCheckIn[kWhatAreYou_GreateFul_For_Today];
              textWhatIsYour_Health_Fitness_Goal.text = dictDailyGoalsCheckIn[kWhatIsYour_Health_Fitness_Goal];
              textWhatIsYourWork_Personal_LifeGoal.text = dictDailyGoalsCheckIn[kWhatIsYour_Work_Personal_Life_Goals];
              textWhatCouldIDoBetterTomorrow.text = dictDailyGoalsCheckIn[kWhatCouldIDoBetter_Tomorrow];
              isDidYouAchieveYour_Health_FitnessGoal = dictDailyGoalsCheckIn[kDidYouAchieveYour_Health_FitnessGoal];
              isDidYouAchieveYour_Work_PersonalGoal = dictDailyGoalsCheckIn[kDidYouAchieveYour_Work_PersonalGoal];
            }
          });
        }
      }).catchError((error) {
        print(error.message.toString());
        Toast.show(
            error.message.toString(),
            context,
            backgroundColor:HexColor(redColor)
        );
      });
    }).then((value) {

    }).catchError((error) {
      print(error.message.toString());
      Toast.show(
          error.message.toString(),
          context,
          backgroundColor:HexColor(redColor)
      );
    });
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
      Toast.show (
          error.message.toString(),
          context,
          backgroundColor:HexColor(redColor)
      );
    });
  }

  Future<void> updateGoalDescription() async {
    showLoading(context);

    var dictDailyGoalsCheckIn = {
      kWhatAreYou_GreateFul_For_Today:textWhatAreYou_GratFul_ForToday.text,
      kWhatIsYour_Health_Fitness_Goal:textWhatIsYour_Health_Fitness_Goal.text,
      kWhatIsYour_Work_Personal_Life_Goals:textWhatIsYourWork_Personal_LifeGoal.text,
      kWhatCouldIDoBetter_Tomorrow:textWhatCouldIDoBetterTomorrow.text,
      kDidYouAchieveYour_Health_FitnessGoal:isDidYouAchieveYour_Health_FitnessGoal,
      kDidYouAchieveYour_Work_PersonalGoal:isDidYouAchieveYour_Work_PersonalGoal
    };

    FirebaseAuth.instance.currentUser().then((value) async {
      Firestore.instance.collection(tblGoals).document(value.email+kFireBaseConnect+value.uid).collection(formattedDate).document(formattedDate)
          .updateData({
        kDailyGoalsCheckIn:dictDailyGoalsCheckIn
      }).then((value) {
        dismissLoading(context);
        Toast.show(
            'Daily Goal are updated.',
            context,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar:AppBar(
          title:Text(
            'Daily Goal Check In',
            style:TextStyle(
                fontSize:20,
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
          elevation:0,
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
//          margin:EdgeInsets.only(left:20,right:20),
          child:SingleChildScrollView(
//            physics:BouncingScrollPhysics(),
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:EdgeInsets.only(top:0,bottom:16),
                  decoration:BoxDecoration(
                    border: Border(
                      bottom:BorderSide( //                    <--- top side
                        color:Colors.grey,
                        width:0.5,
                      ),
                    ),
                  ),
                  child:G2xSimpleWeekCalendar(
                    90.0, DateTime.now(),
                    dateCallback:(date) {
                      print(date);
                      var formatter = DateFormat('yyyy_MMM_dd');
                      formattedDate = formatter.format(date);
                      print(formattedDate);

                      getTracks();
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
//                SizedBox(height:30,),
                Container(
                  margin:EdgeInsets.only(left:20,right:20),
                  child:Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:[
                    Text(
                      'What Are You Grateful For Today?',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    SizedBox(height:20),
                    TextFormField(
                      controller:textWhatAreYou_GratFul_ForToday,
                      textAlign: TextAlign.left,
                      keyboardAppearance:Brightness.light,
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w400
                      ),
                      decoration: InputDecoration(
                        hintText: '',
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
                      'What Is Your Health And Fitness Goal?',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    SizedBox(height:20),
                    TextFormField(
                      controller:textWhatIsYour_Health_Fitness_Goal,
                      textAlign: TextAlign.left,
                      keyboardAppearance:Brightness.light,
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w400
                      ),
                      decoration: InputDecoration(
                        hintText: '',
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
                      'What Is Your Work/ Personal Life Goal?',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    SizedBox(height:20),
                    TextFormField(
                      controller:textWhatIsYourWork_Personal_LifeGoal,
                      textAlign:TextAlign.left,
                      keyboardAppearance:Brightness.light,
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w400
                      ),
                      decoration: InputDecoration(
                        hintText: '',
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
                      'Did You Achieve Your Health And Fitness Goal Today?',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    SizedBox(height:20),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          padding:EdgeInsets.only(left: 0),
                          textColor:Colors.white,
                          child:Row(
                            children: <Widget>[
                              Image.asset(
                                isDidYouAchieveYour_Health_FitnessGoal ? Res.selectedGoalsDetails : Res.unselectedGoalDetails,
                                height:24,
                              ),
                              SizedBox(width:16),
                              Text(
                                'Yes',
                                style:TextStyle(
                                    color:HexColor('54C9AF'),
                                    fontFamily:AppConstant.kPoppins,
                                    fontWeight:FontWeight.normal,
                                    fontSize:16
                                ),
                              )
                            ],
                          ),
                          onPressed:(){
                            setState(() {
                              isDidYouAchieveYour_Health_FitnessGoal = !isDidYouAchieveYour_Health_FitnessGoal;
                            });
                          },
                        ),
                        SizedBox(width:50,),
                        FlatButton(
                          textColor:Colors.white,
                          child:Row(
                            children: <Widget>[
                              Image.asset(
                                !isDidYouAchieveYour_Health_FitnessGoal ? Res.selectedGoalsDetails : Res.unselectedGoalDetails,
                                height:24,
                              ),
                              SizedBox(width:16),
                              Text(
                                'No',
                                style:TextStyle(
                                    color:HexColor('#54C9AF'),
                                    fontFamily:AppConstant.kPoppins,
                                    fontWeight:FontWeight.normal,
                                    fontSize:16
                                ),
                              )
                            ],
                          ),
                          onPressed:(){
                            setState(() {
                              isDidYouAchieveYour_Health_FitnessGoal = !isDidYouAchieveYour_Health_FitnessGoal;
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(height:30,),
                    Text(
                      'Did You Achieve Your Work/ Personal Life Goal Today?',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    SizedBox(height:20),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          padding:EdgeInsets.only(left: 0),
                          textColor:Colors.white,
                          child:Row(
                            children: <Widget>[
                              Image.asset(
                                isDidYouAchieveYour_Work_PersonalGoal ? Res.selectedGoalsDetails : Res.unselectedGoalDetails,
                                height:24,
                              ),
                              SizedBox(width:16),
                              Text(
                                'Yes',
                                style:TextStyle(
                                    color:HexColor('54C9AF'),
                                    fontFamily:AppConstant.kPoppins,
                                    fontWeight:FontWeight.normal,
                                    fontSize:16
                                ),
                              )
                            ],
                          ),
                          onPressed:(){
                            setState(() {
                              isDidYouAchieveYour_Work_PersonalGoal = !isDidYouAchieveYour_Work_PersonalGoal;
                            });
                          },
                        ),
                        SizedBox(width:50,),
                        FlatButton(
                          textColor:Colors.white,
                          child:Row(
                            children: <Widget>[
                              Image.asset(
                                !isDidYouAchieveYour_Work_PersonalGoal ? Res.selectedGoalsDetails : Res.unselectedGoalDetails,
                                height:24,
                              ),
                              SizedBox(width:16),
                              Text(
                                'No',
                                style:TextStyle(
                                    color:HexColor('#54C9AF'),
                                    fontFamily:AppConstant.kPoppins,
                                    fontWeight:FontWeight.normal,
                                    fontSize:16
                                ),
                              )
                            ],
                          ),
                          onPressed:(){
                            setState(() {
                              isDidYouAchieveYour_Work_PersonalGoal = !isDidYouAchieveYour_Work_PersonalGoal;
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(height:30,),
                    Text(
                      'What Could I Do Better Tomorrow?',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    SizedBox(height:20),
                    TextFormField(
                      controller:textWhatCouldIDoBetterTomorrow,
                      textAlign: TextAlign.left,
                      keyboardAppearance:Brightness.light,
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w400
                      ),
                      decoration: InputDecoration(
                        hintText: '',
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

                    SizedBox(height:50),
                    FlatButton(
                      textColor:Colors.white,
                      child:Container(
                        height:54,
                        width:double.infinity,
                        margin:EdgeInsets.only(left:10,right:10),
//                    padding:EdgeInsets.only(left:20,right:20),
                        decoration:kButtonThemeGradientColor(),
                        alignment:Alignment.center,
                        child:Text(
                          'Submit',
                          style:TextStyle(
                              fontSize:18,
                              fontFamily:AppConstant.kPoppins,
                              color:Colors.white,
                              fontWeight:FontWeight.normal
                          ),
                        ),
                      ),
                      onPressed:() {
                        updateGoalDescription();
                      },
                    ),
                    SizedBox(height:30),
                  ],
                ),)
              ],
            ),
          ),
        )
    );
  }
}
