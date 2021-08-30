import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:alfa/res.dart';
import 'package:flutter/rendering.dart';
import '../res.dart';
import 'package:g2x_week_calendar/g2x_simple_week_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:dart_notification_center/dart_notification_center.dart';



class FoodHistory extends StatefulWidget {
  @override
  _FoodHistoryState createState() => _FoodHistoryState();
}

class _FoodHistoryState extends State<FoodHistory> {
  var arrFoodTitles = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  var indexSelected = 0;
  var selectedBreakfastFeel = 0;
  var selectedBreakfastEnergy = 0;
  var selectedTime = 'xx:xx';
  TimeOfDay selectedTimes = TimeOfDay.now();

  bool isSnack = false;

  String formattedDate = '';
  String foodType = '';

  String howDidYoufeelAfter = 'How did you feel after breakfast?';
  String howWasYourEnergyAfter = 'How was your energy after breakfast?';

  var textFoodName = TextEditingController();
  var textCalories = TextEditingController();
  var textOtherNotes = TextEditingController();
  var textBetterOption = TextEditingController();
  var textOtherReason = TextEditingController();

//  var strTime = '';
  var strHowDidYoufeelAfter = '';
  var strHowWasYourEnergyAfter = '';

  var kHow_Was_Your_Energy_After = '';
  var kHow_Did_You_Feel_After = '';

  var strForWhatReasonDidYouHaveThisSnack = '';
  var strWhatThisSnackNutritous = '';

  FocusNode textSecondFocusNode = new FocusNode();

  @override
  void initState() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy_MMM_dd');
    formattedDate = formatter.format(now);

    foodType = kBreakfast;
    howDidYoufeelAfter = 'How did you feel after breakfast?';
    howWasYourEnergyAfter = 'How was your energy after breakfast?';
    kHow_Was_Your_Energy_After = kHow_Was_Your_Energy_After_Breakfast;
    kHow_Did_You_Feel_After = kHow_Did_You_Feel_After_Breakfast;

    Future.delayed(Duration(milliseconds: 1), () {
      getFoodDetails();
    });
    // TODO: implement initState
    super.initState();
  }

  getFoodDetails() {
    selectedBreakfastFeel = 0;
    selectedBreakfastEnergy = 0;

    textFoodName.text = '';
    selectedTime = 'xx:xx';
    textCalories.text = '';
    strHowDidYoufeelAfter = '';
    strHowWasYourEnergyAfter = '';
    textOtherNotes.text = '';

    strForWhatReasonDidYouHaveThisSnack = '';
    strWhatThisSnackNutritous = '';
    textOtherNotes.text = '';
    textOtherReason.text = '';
    textBetterOption.text = '';

    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) {
      print(Firestore.instance
          .collection(tblFoodDetails)
          .document(value.email + kFireBaseConnect + value.uid)
          .collection(formattedDate)
          .document(foodType));

      Firestore.instance
          .collection(tblFoodDetails)
          .document(value.email + kFireBaseConnect + value.uid)
          .collection(formattedDate)
          .document(foodType)
          .get()
          .then((value) {
        dismissLoading(context);
//        print(value.data);

        if (value.data != null && value.data.isNotEmpty) {
          textFoodName.text = value.data[kFood];
          selectedTime = value.data[kFoodTime];
          textCalories.text = value.data[kCalories];

          strHowDidYoufeelAfter = (value.data[kHow_Did_You_Feel_After] == null)
              ? ''
              : value.data[kHow_Did_You_Feel_After];
          strHowWasYourEnergyAfter =
              (value.data[kHow_Was_Your_Energy_After] == null)
                  ? ''
                  : value.data[kHow_Was_Your_Energy_After];
          textOtherNotes.text = (value.data[
                      kAny_Other_Notes_About_How_You_Felf_During_Or_After_Eating] ==
                  null)
              ? ''
              : value.data[
                  kAny_Other_Notes_About_How_You_Felf_During_Or_After_Eating];
          strForWhatReasonDidYouHaveThisSnack =
              (value.data[kForWhatReasonDidYouHaveThisSnack] == null)
                  ? ''
                  : value.data[kForWhatReasonDidYouHaveThisSnack];
          strWhatThisSnackNutritous =
              (value.data[kWhatThisSnackNutritous] == null)
                  ? ''
                  : value.data[kWhatThisSnackNutritous];
          textOtherReason.text = (value.data[kOtherReason] == null)
              ? ''
              : value.data[kOtherReason];
          textBetterOption.text =
              (value.data[kWhatBetterOptionCouldYouHaveChosen] == null)
                  ? ''
                  : value.data[kWhatBetterOptionCouldYouHaveChosen];

          if (strHowDidYoufeelAfter == '100% Full' &&
              strHowDidYoufeelAfter != null) {
            selectedBreakfastFeel = 1;
          } else if (strHowDidYoufeelAfter == '80% Full' &&
              strHowDidYoufeelAfter != null) {
            selectedBreakfastFeel = 2;
          } else if (strHowDidYoufeelAfter == 'Very Hungry' &&
              strHowDidYoufeelAfter != null) {
            selectedBreakfastFeel = 3;
          } else if (strHowDidYoufeelAfter == 'Slightly Hungry' &&
              strHowDidYoufeelAfter != null) {
            selectedBreakfastFeel = 4;
          }

          if (value.data[kForWhatReasonDidYouHaveThisSnack] == 'Hunger') {
            selectedBreakfastFeel = 1;
          } else if (value.data[kForWhatReasonDidYouHaveThisSnack] ==
              'Boredom') {
            selectedBreakfastFeel = 2;
          } else if (value.data[kForWhatReasonDidYouHaveThisSnack] ==
              'Temptation') {
            selectedBreakfastFeel = 3;
          } else if (value.data[kForWhatReasonDidYouHaveThisSnack] == 'Other') {
            selectedBreakfastFeel = 4;
          }

          if (strHowWasYourEnergyAfter == 'Great') {
            selectedBreakfastEnergy = 1;
          } else if (strHowWasYourEnergyAfter == 'Good') {
            selectedBreakfastEnergy = 2;
          } else if (strHowWasYourEnergyAfter == 'Ok') {
            selectedBreakfastEnergy = 3;
          } else if (strHowWasYourEnergyAfter == 'Tired') {
            selectedBreakfastEnergy = 4;
          }

          if (value.data[kWhatThisSnackNutritous] == 'Yes') {
            selectedBreakfastEnergy = 1;
          } else if (value.data[kWhatThisSnackNutritous] == 'No') {
            selectedBreakfastEnergy = 2;
          }
        }

        setState(() {});
      });
    }).catchError((error) {
      dismissLoading(context);
    });
  }

  setFoodData() {
    if (selectedBreakfastFeel == 1) {
      strHowDidYoufeelAfter = "100% Full";
      strHowWasYourEnergyAfter = 'Great';
    } else if (selectedBreakfastFeel == 2) {
      strHowDidYoufeelAfter = '80% Full';
      strHowWasYourEnergyAfter = 'Good';
    } else if (selectedBreakfastFeel == 3) {
      strHowDidYoufeelAfter = 'Very Hungry';
      strHowWasYourEnergyAfter = 'Ok';
    } else if (selectedBreakfastFeel == 4) {
      strHowDidYoufeelAfter = 'Slightly Hungry';
      strHowWasYourEnergyAfter = 'Tired';
    }

//    var dictFood = {
//    kFood:textFoodName.text,
//    kFoodTime:selectedTime,
//    kCalories:textCalories.text,
//    kHow_Was_Your_Energy_After:strHowDidYoufeelAfter,
//    kHow_Did_You_Feel_After:strHowWasYourEnergyAfter,
//    kAny_Other_Notes_About_How_You_Felf_During_Or_After_Eating:textOtherNotes.text
//    };
//
//    print(dictFood);

    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) {
      Firestore.instance
          .collection(tblFoodDetails)
          .document(value.email + kFireBaseConnect + value.uid)
          .collection(formattedDate)
          .document(foodType)
          .setData({
        kFood: textFoodName.text,
        kFoodTime: selectedTime,
        kCalories: textCalories.text,
        kHow_Was_Your_Energy_After: strHowWasYourEnergyAfter,
        kHow_Did_You_Feel_After: strHowDidYoufeelAfter,
        kAny_Other_Notes_About_How_You_Felf_During_Or_After_Eating:
            textOtherNotes.text
      }).then((value) {
        dismissLoading(context);
        Toast.show('Track is added successfully.', context,
            backgroundColor: HexColor(greenColor));
      }).catchError((error) {
        dismissLoading(context);
        Toast.show(
            error.message.toString(), context,
            backgroundColor: HexColor(redColor));
      });
    }).catchError((error) {
      dismissLoading(context);
      Toast.show(
          error.message.toString(), context,
          backgroundColor: HexColor(redColor));
    });
  }

  setSnacks() {
    if (selectedBreakfastFeel == 1) {
      strForWhatReasonDidYouHaveThisSnack = "Hunger";
      strWhatThisSnackNutritous = 'Yes';
    } else if (selectedBreakfastFeel == 2) {
      strForWhatReasonDidYouHaveThisSnack = 'Boredom';
      strWhatThisSnackNutritous = 'No';
    } else if (selectedBreakfastFeel == 3) {
      strForWhatReasonDidYouHaveThisSnack = 'Temptation';
    } else if (selectedBreakfastFeel == 4) {
      strForWhatReasonDidYouHaveThisSnack = 'Other';
    }

//    var dictFood = {
//      kFood:textFoodName.text,
//      kFoodTime:selectedTime,
//      kCalories:textCalories.text,
//      kForWhatReasonDidYouHaveThisSnack:strForWhatReasonDidYouHaveThisSnack,
//      kWhatThisSnackNutritous:strWhatThisSnackNutritous,
//      kAny_Other_Notes_About_How_You_Felf_During_Or_After_Eating:textOtherNotes.text,
//      kOtherReason:textOtherReason.text,
//      kWhatBetterOptionCouldYouHaveChosen:textBetterOption.text
//    };
//
//    print(dictFood);

    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) {
      Firestore.instance
          .collection(tblFoodDetails)
          .document(value.email + kFireBaseConnect + value.uid)
          .collection(formattedDate)
          .document(foodType)
          .setData({
        kFood: textFoodName.text,
        kFoodTime: selectedTime,
        kCalories: textCalories.text,
        kForWhatReasonDidYouHaveThisSnack: strForWhatReasonDidYouHaveThisSnack,
        kWhatThisSnackNutritous: strWhatThisSnackNutritous,
        kAny_Other_Notes_About_How_You_Felf_During_Or_After_Eating:
            textOtherNotes.text,
        kOtherReason: textOtherReason.text,
        kWhatBetterOptionCouldYouHaveChosen: textBetterOption.text
      }).then((value) {
        dismissLoading(context);
        Toast.show('Track is added successfully.', context,
            backgroundColor: HexColor(greenColor));
      }).catchError((error) {
        dismissLoading(context);
        Toast.show(
            error.message.toString(), context,
            backgroundColor: HexColor(redColor));
      });
    }).catchError((error) {
      dismissLoading(context);
      Toast.show(
          error.message.toString(), context,
          backgroundColor: HexColor(redColor));
    });
  }

  Future<void> selectTime(BuildContext context) async {
    FocusScope.of(context).requestFocus(textSecondFocusNode);

    var timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF8CE7F1),
            accentColor: Color(0xFF8CE7F1),
            colorScheme: ColorScheme.light(primary: HexColor('54C9AF')),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    setState(() {
      final now = new DateTime.now();
      final dt = DateTime(
          now.year, now.month, now.day, timePicked.hour, timePicked.minute);
      final format = DateFormat.jm();
      print(format.format(dt));
      selectedTime = format.format(dt);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: DefaultTabController(
          length: 1,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                expandedHeight: 240.0,
                floating: true,
                pinned: true,
                snap: true,
                centerTitle: false,
                elevation: 0,
                title: Text(
                  'History',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: AppConstant.kPoppins,
                      color: AppConstant.color_blue_dark,
                      fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      DartNotificationCenter.post(
                        channel: tblFoodDetails,
                        options: '',
                      );
                    }),
                flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).padding.top +
                          AppBar().preferredSize.height,
                    ),
                    Container(
                      child: G2xSimpleWeekCalendar(
                        90.0, DateTime.now(),
                        dateCallback: (date) {
                          print(date);

                          var formatter = DateFormat('yyyy_MMM_dd');
                          formattedDate = formatter.format(date);
                          print(formattedDate);

                          getFoodDetails();
                        },

                        selectedDateTextStyle:TextStyle(
                            color:AppConstant.color_blue_dark,
                            fontFamily:AppConstant.kPoppins,
                            fontWeight:FontWeight.normal,
                            fontSize:16),
                        selectedDateBG_Color:Colors.white,

                        typeCollapse: false,
                        selectedTextStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: AppConstant.kPoppins,
                            fontWeight: FontWeight.normal,
                            fontSize: 16),
                        selectedBackgroundDecoration: BoxDecoration(
                            color: AppConstant.color_blue_dark,
                            borderRadius: BorderRadius.circular(30)),
                        strWeekDays: [
                          'Su',
                          'Mo',
                          'Tu',
                          'We',
                          'Th',
                          'Fr',
                          'Sa',
                        ],
                        defaultTextStyle: TextStyle(
                            color: AppConstant.color_blue_dark,
                            fontFamily: AppConstant.kPoppins,
                            fontWeight: FontWeight.normal,
                            fontSize: 16),
                      ),
                    ),
                  ],
                )),
                bottom: TabBar(
                  indicatorColor: Colors.transparent,
                  indicatorWeight: 0.1,
                  labelPadding: EdgeInsets.all(0),
                  unselectedLabelColor: Colors.transparent,
                  labelColor: Colors.transparent,
                  tabs: [
                    Tab(
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                          bottom: BorderSide(
                                              color: HexColor('#E0E0E0'),
                                              width: 2))),
                                ),
                              ),
                              Container(
                                height: 46,
                                color: Colors.white,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: arrFoodTitles.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 7, right: 7),
                                          height: 111,
                                          width: 111,
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                height: 111,
                                                width: 111,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  arrFoodTitles[index],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily:
                                                          AppConstant.kPoppins,
                                                      color: AppConstant
                                                          .color_blue_dark,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Visibility(
                                                    visible:
                                                        (indexSelected == index)
                                                            ? true
                                                            : false,
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 0,
                                                          right: 0,
                                                          bottom: 0),
                                                      color:
                                                          HexColor('#54C9AF'),
                                                      height: 2,
                                                    ),
                                                  ))
                                            ],
                                          )),
                                      onTap: () {
                                        indexSelected = index;
                                        if (index == arrFoodTitles.length - 1) {
                                          isSnack = true;
                                        } else {
                                          isSnack = false;
                                        }

                                        if (index == 0) {
                                          howDidYoufeelAfter =
                                              'How did you feel after breakfast?';
                                          howWasYourEnergyAfter =
                                              'How was your energy after breakfast?';
                                          foodType = kBreakfast;

                                          kHow_Was_Your_Energy_After =
                                              kHow_Was_Your_Energy_After_Breakfast;
                                          kHow_Did_You_Feel_After =
                                              kHow_Did_You_Feel_After_Breakfast;
                                        } else if (index == 1) {
                                          howDidYoufeelAfter =
                                              'How did you feel after lunch?';
                                          howWasYourEnergyAfter =
                                              'How was your energy after lunch?';
                                          foodType = kLunch;

                                          kHow_Was_Your_Energy_After =
                                              kHow_Did_You_Feel_After_Lunch;
                                          kHow_Did_You_Feel_After =
                                              kHow_Was_Your_Energy_After_Lunch;
                                        } else if (index == 2) {
                                          howDidYoufeelAfter =
                                              'How did you feel after dinner?';
                                          howWasYourEnergyAfter =
                                              'How was your energy after dinner?';
                                          foodType = kDinner;

                                          kHow_Was_Your_Energy_After =
                                              kHow_Did_You_Feel_After_Dinner;
                                          kHow_Did_You_Feel_After =
                                              kHow_Was_Your_Energy_After_Dinner;
                                        } else if (index == 3) {
                                          foodType = kSnacks;
                                        }

                                        getFoodDetails();
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ], // <-- total of 2 tabs
                ),
              ),
              SliverToBoxAdapter(
                  child: Column(
                children: <Widget>[
                  Visibility(
                    visible: !isSnack,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            'Food',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            enabled: false,
                            controller: textFoodName,
                            textAlign: TextAlign.left,
                            keyboardAppearance: Brightness.light,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                              hintText: 'Food name',
                              contentPadding:
                                  EdgeInsets.only(left: 16, right: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Time
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Time',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppConstant.kPoppins,
                                          color: AppConstant.color_blue_dark,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 20),
                                    FlatButton(
                                      padding: EdgeInsets.all(0),
                                      child: Container(
                                        height: 46,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: HexColor('#CECECE'))),
                                        alignment: Alignment.centerLeft,
                                        margin:
                                            EdgeInsets.only(left: 0, right: 0),
                                        padding:
                                            EdgeInsets.only(left: 16, right: 0),
                                        child: Text(
                                          selectedTime,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: AppConstant.kPoppins,
                                              color: (selectedTime == 'xx:xx')
                                                  ? Colors.grey
                                                  : Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
//                                          onPressed: () {
//                                            print('timing');
//                                            _pickTime(context);
//                                            selectTimeTTTTTTTT(context);
//                                            selectTime(context);
//                                          },
                                    )
                                  ],
                                ),
                              ),
                              // Calories
                              Container(
//                        color:Colors.greenAccent,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Calories',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppConstant.kPoppins,
                                          color: AppConstant.color_blue_dark,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      enabled: false,
                                      controller: textCalories,
                                      textAlign: TextAlign.left,
                                      keyboardAppearance: Brightness.light,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppConstant.kPoppins,
                                          color: AppConstant.color_blue_dark,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        hintText: 'Enter calories kcal',
                                        contentPadding: EdgeInsets.only(
                                            left: 16, right: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: HexColor('#CECECE'))),
                                      ),
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Text is empty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // How did you feel after breakfast?
                          Text(
                            howDidYoufeelAfter,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
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
                                        '100% Full',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastFeel = 1;
//                                        });
//                                      },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
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
                                        '80% Full',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastFeel = 2;
//                                        });
//                                      },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastFeel == 3)
                                            ? Res.selectedGoalsDetails
                                            : Res.unselectedGoalDetails,
                                        height: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Very Hungry',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastFeel = 3;
//                                        });
//                                      },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastFeel == 4)
                                            ? Res.selectedGoalsDetails
                                            : Res.unselectedGoalDetails,
                                        height: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Slightly Hungry',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastFeel = 4;
//                                        });
//                                      },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // How was your energy after breakfast?
                          Text(
                            howWasYourEnergyAfter,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastEnergy == 1)
                                            ? Res.selectedGoalsDetails
                                            : Res.unselectedGoalDetails,
                                        height: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Great',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastEnergy = 1;
//                                        });
//                                      },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastEnergy == 2)
                                            ? Res.selectedGoalsDetails
                                            : Res.unselectedGoalDetails,
                                        height: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Good',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastEnergy = 2;
//                                        });
//                                      },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastEnergy == 3)
                                            ? Res.selectedGoalsDetails
                                            : Res.unselectedGoalDetails,
                                        height: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Ok',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastEnergy = 3;
//                                        });
//                                      },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastEnergy == 4)
                                            ? Res.selectedGoalsDetails
                                            : Res.unselectedGoalDetails,
                                        height: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Tired',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastEnergy = 4;
//                                        });
//                                      },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Any other Notes about how you felt during or after eating?',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: textOtherNotes,
                            textAlign: TextAlign.left,
                            keyboardAppearance: Brightness.light,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                              hintText: '',
                              contentPadding: EdgeInsets.only(
                                  left: 16, right: 16, top: 16, bottom: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isSnack,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            'Food',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: textFoodName,
                            textAlign: TextAlign.left,
                            keyboardAppearance: Brightness.light,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                              hintText: 'Food name',
                              contentPadding:
                                  EdgeInsets.only(left: 16, right: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Time
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Time',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppConstant.kPoppins,
                                          color: AppConstant.color_blue_dark,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 20),
                                    FlatButton(
                                      padding: EdgeInsets.all(0),
                                      child: Container(
                                        height: 46,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: HexColor('#CECECE'))),
                                        alignment: Alignment.centerLeft,
                                        margin:
                                            EdgeInsets.only(left: 0, right: 0),
                                        padding:
                                            EdgeInsets.only(left: 16, right: 0),
                                        child: Text(
                                          selectedTime,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: AppConstant.kPoppins,
                                              color: (selectedTime == 'xx:xx')
                                                  ? Colors.grey
                                                  : Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        selectTime(context);
                                      },
                                    )
                                  ],
                                ),
                              ),
                              // Calories
                              Container(
//                        color:Colors.greenAccent,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Calories',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppConstant.kPoppins,
                                          color: AppConstant.color_blue_dark,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: textCalories,
                                      textAlign: TextAlign.left,
                                      keyboardAppearance: Brightness.light,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppConstant.kPoppins,
                                          color: AppConstant.color_blue_dark,
                                          fontWeight: FontWeight.normal),
                                      decoration: InputDecoration(
                                        hintText: 'Enter calories kcal',
                                        contentPadding: EdgeInsets.only(
                                            left: 16, right: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: HexColor('#CECECE'))),
                                      ),
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Text is empty';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // How did you feel after breakfast?
                          Text(
                            'For what reason did you have this snack?',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
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
                                        'Hunger',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastFeel = 1;
//                                        });
//                                      },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
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
                                        'Boredom',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastFeel = 2;
//                                        });
//                                      },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastFeel == 3)
                                            ? Res.selectedGoalsDetails
                                            : Res.unselectedGoalDetails,
                                        height: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Temptation',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastFeel = 3;
//                                        });
//                                      },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastFeel == 4)
                                            ? Res.selectedGoalsDetails
                                            : Res.unselectedGoalDetails,
                                        height: 24,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Other',
                                        style: TextStyle(
                                            color: HexColor('#54C9AF'),
                                            fontFamily: AppConstant.kPoppins,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastFeel = 4;
//                                        });
//                                      },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
//                    other
                          TextFormField(
                            controller: textOtherReason,
                            textAlign: TextAlign.left,
                            keyboardAppearance: Brightness.light,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                              hintText: 'Other',
                              contentPadding: EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          // How was your energy after breakfast?
                          Text(
                            'What this snack nutritious?',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastEnergy == 1)
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
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastEnergy = 1;
//                                        });
//                                      },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 26,
                                alignment: Alignment.centerLeft,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        (selectedBreakfastEnergy == 2)
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
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                      )
                                    ],
                                  ),
//                                      onPressed: () {
//                                        setState(() {
//                                          selectedBreakfastEnergy = 2;
//                                        });
//                                      },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'Any other Notes about how you felt during or after eating?',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: textOtherNotes,
                            textAlign: TextAlign.left,
                            keyboardAppearance: Brightness.light,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                              hintText: '',
                              contentPadding: EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            'What better options could you have chosen ?',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: AppConstant.color_blue_dark,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: textBetterOption,
                            textAlign: TextAlign.left,
                            keyboardAppearance: Brightness.light,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.kPoppins,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                              hintText: '',
                              contentPadding: EdgeInsets.only(
                                  left: 16, right: 16, top: 16, bottom: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
//                    enabledBorder: InputBorder.none,
//                    errorBorder: InputBorder.none,
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: HexColor('#CECECE'))),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Text is empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ));

  }
}
