import 'package:alfa/screen/Faq.dart';
import 'package:alfa/screen/FitnessGoalScreen.dart';
import 'package:alfa/screen/ForgotPassword.dart';
import 'package:alfa/screen/IntroScreen.dart';
import 'package:alfa/screen/LoginScreen.dart';
import 'package:alfa/screen/NotificationScreen.dart';
import 'package:alfa/screen/ProfileScreen.dart';
import 'package:alfa/screen/SettingScreen.dart';
import 'package:alfa/screen/SignupScreen.dart';
import 'package:alfa/screen/Subscribe.dart';
import 'package:alfa/screen/TermsCondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'screen/SplashScreen.dart';
import 'utils/Log.dart';
import 'screen/EmailSent.dart';
import 'screen/DailyLife.dart';
import 'screen/Calculator.dart';

import 'package:alfa/screen/TabbarScreens/TabbarScreen.dart';

import 'screen/WorkoutDetails.dart';
import 'screen/YourQuote.dart';
import 'screen/DailyGoalCheckIn.dart';
import 'screen/WeeklyProgressTracker.dart';
import 'screen/FitnessGoalScreenEdit.dart';
import 'screen/DailyLifeEdit.dart';
import 'screen/ProfileScreenEdit.dart';
import 'screen/PrivacyPolicy.dart';
import 'screen/FeedBack.dart';
import 'screen/MyCards.dart';
import 'screen/AddNewCard.dart';
import 'screen/CardDetails.dart';
import 'screen/AddFood.dart';
import 'screen/FoodHistory.dart';
import 'screen/TrackTab_Details.dart';

import 'dart:async';
import 'package:health/health.dart';
import 'screen/SetWorkouts.dart';


void main() {
  _initLog();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
        
//    runApp(MyApp());
//    runApp(MyApps());
    runApp(App());
  });
}

void _initLog() {
  Log.init();
  Log.setLevel(Level.ALL);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Fitness Tracker",
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => makeRoute(
                context: context,
                routeName: settings.name,
                arguments: settings.arguments),
            maintainState: true,
            fullscreenDialog: false,
          );
        });
  }

  Widget makeRoute(
      {@required BuildContext context,
      @required String routeName,
      Object arguments}) {
    final Widget child = _buildRoute(
        context: context, routeName: routeName, arguments: arguments);
    return child;
  }

  Widget _buildRoute({
    @required BuildContext context,
    @required String routeName,
    Object arguments,
  }) {
    switch (routeName) {
      case '/':
        return SplashScreen();
      case '/intro':
        return IntroScreen();
      case '/login':
        return LoginScreen();
      case '/signUp':
        return SignupScreen();
      case '/profile':
        return ProfileScreen();
      case '/terms':
        return TermsCondition();
      case '/fitnessgoal':
        return FitnessGoalScreen();
      case '/Subscribe':
        return Subscribe();
//      case '/quote':
//        return QuoteScreen();
      case '/forgotpassword':
        return ForgotPassword();
      case '/notification':
        return NotificationScreen();
      case '/setting':
        return SettingScreen();
      case '/faq':
        return Faq();
      case '/EmailSent':
        return EmailSent();
      case '/DailyLife':
        return DailyLife();
      case '/TabbarScreen':
        return TabbarScreen();
      case '/WorkoutDetails':
        return WorkoutDetails();
      case '/YourQuote':
        return YourQuote();
      case '/DailyGoalCheckIn':
        return DailyGoalCheckIn();
      case '/WeeklyProgressTracker':
        return WeeklyProgressTracker();
      case '/FitnessGoalScreenEdit':
        return FitnessGoalScreenEdit();
      case '/DailyLifeEdit':
        return DailyLifeEdit();
      case '/ProfileScreenEdit':
        return ProfileScreenEdit();
      case '/PrivacyPolicy':
        return PrivacyPolicy();
      case '/FeedBack':
        return FeedBack();
      case '/MyCards':
        return MyCards();
      case '/AddNewCard':
        return AddNewCard();
      case '/CardDetails':
        return CardDetails();
      case '/AddFood':
        return AddFood();
      case '/FoodHistory':
        return FoodHistory();
      case '/TrackTab_Details':
        return TrackTab_Details();
      case '/Calculator':
        return Calculator();
      case '/SetWorkouts':
        return SetWorkouts();

      default:
        throw 'Route $routeName is not defined';
    }
  }
}






/*

library g2x_week_calendar;
import 'package:flutter/material.dart';

import 'Util.dart';

typedef void DateCallback(DateTime val);

class G2xSimpleWeekCalendar extends StatefulWidget {
  G2xSimpleWeekCalendar(
      this.bodyHeight,
      this.currentDate,
      {
        this.strWeekDays = const ["Sun","Mon","Tues","Wed","Thurs","Fri","Sat"],
        this.format = "yyyy/MM/dd",this.dateCallback,
        this.defaultTextStyle =  const TextStyle(),
        this.selectedTextStyle = const TextStyle(color: Colors.red),
        this.selectedBackgroundDecoration = const BoxDecoration(),
        this.backgroundDecoration = const BoxDecoration(),
        this.typeCollapse = false,

        this.selectedDateTextStyle = const TextStyle(color: Colors.red),
        this.selectedDateBG_Color = Colors.red,
      }
      );

  final DateTime currentDate;
  final List<String> strWeekDays;
  final String format;
  final DateCallback dateCallback;
  //style
  final TextStyle defaultTextStyle;
  final TextStyle selectedTextStyle;
  final BoxDecoration selectedBackgroundDecoration;
  final BoxDecoration backgroundDecoration;
  final bool typeCollapse;
  final double bodyHeight;

  TextStyle selectedDateTextStyle;
  Color selectedDateBG_Color;

  @override
  _G2xSimpleWeekCalendarState createState() => _G2xSimpleWeekCalendarState();
}

class _G2xSimpleWeekCalendarState extends State<G2xSimpleWeekCalendar> with TickerProviderStateMixin{
  DateTime currentDate;
  var weekDays = <int>[];
  var selectedIndex = 0;
  var _close = false;

  //Collapse
  AnimationController _collapseController;
  Animation<double> _collpseAnimation;
  var _heightCollapse = 0.0;

  _setSelectedDate(int index){
    setState(() {
      selectedIndex = index;
      currentDate = MyDateTime.getFirstDateOfWeek(currentDate).add(new Duration(days: index));
      if(widget.dateCallback != null)
        widget.dateCallback(currentDate);
    });
  }

  _altertWeek(int days){
    setState(() {
      currentDate = currentDate.add(new Duration(days: days));
      if(widget.dateCallback != null)
        widget.dateCallback(currentDate);
    });
  }

  _collapse(){
    if(!widget.typeCollapse) return;
    if(_collapseController.status == AnimationStatus.completed && _close){
      _collapseController.reverse();
      _close = false;
    }
    else if(_collapseController.status == AnimationStatus.dismissed){
      _collapseController.forward();
      _close = true;
    }
  }

  @override
  void initState() {
    super.initState();
    currentDate = widget.currentDate;
    // if(widget.dateCallback != null)
    //   widget.dateCallback(currentDate);
    selectedIndex = currentDate.weekday == 7 ? 0 : currentDate.weekday;

    //Collapse
    _heightCollapse = widget.bodyHeight;
    _collapseController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 500));
    _collpseAnimation = new Tween<double>(begin: widget.bodyHeight, end: 0).animate(_collapseController);
    _collapseController.addListener((){
      setState(() {
        _heightCollapse = _collpseAnimation.value;
      });
      if(_collapseController.status == AnimationStatus.completed && !_close){
        _collapseController.reset();
        _close = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    weekDays = MyDateTime.getDaysOfWeek(currentDate);
    var size = MediaQuery.of(context).size;
    var sizePart = size.width/4-10;
    var rowWeeks = new Column(
      children: <Widget>[
        new Container(
            decoration: widget.backgroundDecoration,
            padding: new EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new InkWell(
                      onTap: ()=> _collapse(),
                      child: new Container(
                        width: sizePart,
                        child: new Text(""),
                      )
                  ),
                  new Container(
                      width: sizePart * 2,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new InkWell(
                            onTap: ()=> _altertWeek(-7),
                            child: new Icon(Icons.arrow_left, color: widget.defaultTextStyle.color),
                          ),
                          new Text(MyDateTime.formatDate(currentDate,format: widget.format),
                              style: widget.defaultTextStyle),
                          new InkWell(
                            onTap: ()=> _altertWeek(7),
                            child: new Icon(Icons.arrow_right, color: widget.defaultTextStyle.color),
                          )
                        ],
                      )
                  ),
                  new InkWell(
                    onTap: ()=> _collapse(),
                    child: new Container(
                      alignment: Alignment.centerRight,
                      width: sizePart,
                      child: widget.typeCollapse ? new Icon(_close ? Icons.arrow_drop_up : Icons.arrow_drop_down) : null,
                    ),
                  )
                ]
            )
        ),
        new Container(
            height: _heightCollapse,
            decoration: widget.backgroundDecoration,
            padding: new EdgeInsets.only(left:5, right:5), // changed
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widget.strWeekDays.map((i) {
                  return new InkWell(
                      onTap: ()=> _setSelectedDate(widget.strWeekDays.indexOf(i)),
                      child: new Container(
                        // padding: new EdgeInsets.all(5),
                        padding:EdgeInsets.only(left:6,right:6), // changed
                        decoration: selectedIndex == widget.strWeekDays.indexOf(i) ?
                        widget.selectedBackgroundDecoration : new BoxDecoration(),
                        child: new Column(
                          mainAxisAlignment:MainAxisAlignment.center,
                          crossAxisAlignment:CrossAxisAlignment.center,
                          children: <Widget>[
                            new Text(i,
                                style: selectedIndex == widget.strWeekDays.indexOf(i) ?
                                widget.selectedTextStyle : widget.defaultTextStyle),
                            // changed below
                            Container(
                              width:34,
                              height:34,
                              alignment:Alignment.center,// changed
                              padding:EdgeInsets.only(left:5,right:5), //
                              decoration:BoxDecoration(
                                borderRadius:BorderRadius.circular(17),
                                color:selectedIndex == widget.strWeekDays.indexOf(i)
                                    ? widget.selectedDateBG_Color
                                    : Colors.transparent,
                              ),
                              child:Text(
                                  weekDays[widget.strWeekDays.indexOf(i)].toString(),
                                  style:selectedIndex == widget.strWeekDays.indexOf(i)
                                      ? widget.selectedDateTextStyle
                                      : widget.defaultTextStyle
                              ),
                            ),
                          ],
                        ),
                      )
                  );
                }).toList()
            )
        )
      ],
    );
    return rowWeeks;
  }
}

 */