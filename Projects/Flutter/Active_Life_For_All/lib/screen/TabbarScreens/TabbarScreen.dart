import 'package:alfa/utils/Constents.dart';
import 'package:flutter/material.dart';
import 'package:alfa/screen/TabbarScreens/FoodDiaryTab.dart';
import 'package:alfa/screen/TabbarScreens/GoalsTab.dart';
import 'package:alfa/screen/TabbarScreens/ProfileTab.dart';
import 'package:alfa/screen/TabbarScreens/TrackTab.dart';
import 'package:alfa/screen/TabbarScreens/WorkoutsTab.dart';
import 'package:alfa/res.dart';



class TabbarScreen extends StatefulWidget {
  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> {
  int selectedIndex = 0;

  final tabs = [
    WorkoutsTab(),
    GoalsTab(),
    FoodDiaryTab(),
    TrackTab(),
    ProfileTab()
  ];

  Future<bool> onPressedBack() {

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:onPressedBack,
        child: Scaffold(
      body:tabs[selectedIndex],
      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex:selectedIndex,
        type:BottomNavigationBarType.fixed,
        backgroundColor:Colors.white,
        selectedItemColor:HexColor('#54C9AF'),
        unselectedItemColor:HexColor('##D5D5D5'),
//        iconSize:30,
        items:[
          BottomNavigationBarItem(
            icon:Image.asset(Res.workouts,height:22,),
            activeIcon:Image.asset(Res.selctedWorkouts,height:22,),
            title:Text(
              'Workouts',
              style:TextStyle(
                  fontSize:12,
                  fontFamily:AppConstant.kPoppins,
//                  color:AppConstant.color_blue_dark,
                  fontWeight:FontWeight.normal
              ),
            ),
            backgroundColor:Colors.white,
          ),
          BottomNavigationBarItem(
              icon:Image.asset(Res.goals,height:22,),
              activeIcon:Image.asset(Res.selectedGoals,height:22,),
              title:Text(
                'Goals',
                style:TextStyle(
                    fontSize:12,
                    fontFamily:AppConstant.kPoppins,
//                    color:AppConstant.color_blue_dark,
                    fontWeight:FontWeight.normal
                ),
              ),
              backgroundColor:Colors.white
          ),
          BottomNavigationBarItem(
              icon:Image.asset(Res.foodDiary,height:22,),
              activeIcon:Image.asset(Res.selectedFoodDiary,height:22,),
              title:Text(
                'Food Diary',
                style:TextStyle(
                    fontSize:12,
                    fontFamily:AppConstant.kPoppins,
//                    color:AppConstant.color_blue_dark,
                    fontWeight:FontWeight.normal
                ),
              ),
              backgroundColor:Colors.white
          ),
          BottomNavigationBarItem(
              icon:Image.asset(Res.track,height:22,),
              activeIcon:Image.asset(Res.selectedTrac,height:22,),
              title:Text(
                'Track',
                  style:TextStyle(
                    fontSize:12,
                    fontFamily:AppConstant.kPoppins,
//                    color:AppConstant.color_blue_dark,
                    fontWeight:FontWeight.normal
                ),
              ),
              backgroundColor:Colors.white
          ),
          BottomNavigationBarItem(
              icon:Image.asset(Res.profile,height:22,),
              activeIcon:Image.asset(Res.selectedProfile,height:22,),
              title:Text(
                'Profile',
                style:TextStyle(
                    fontSize:12,
                    fontFamily:AppConstant.kPoppins,
//                    color:AppConstant.color_blue_dark,
                    fontWeight:FontWeight.normal
                ),
              ),
              backgroundColor:Colors.white
          ),
        ],
        onTap:(index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    ),);
  }
}


