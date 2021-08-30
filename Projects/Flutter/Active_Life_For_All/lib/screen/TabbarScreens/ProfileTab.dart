import 'package:alfa/res.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:share/share.dart';
import 'package:rate_in_store/rate_in_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';



class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  var arrProfileIcons = [Res.fitnessGoal,Res.editProfile,
    Res.settings,Res.referAFriend,Res.feedbacks,Res.rateUs,Res.logOut,Res.calculator,Res.worktOutSet];

  List<String> arrProfileTitles = List<String>.from(['Fitness Goal','Edit Profile','Settings',
    'Refer a Friend','FeedBack','Rate Us','Log Out','BMR Calculator',]);

  String strName = '';
  String strFitnessGoal = '';
  String strGendar = '';
  String strAge = '';
  String strProfilePicture = '';

  var dictUserDetails = Map<String,dynamic>();
  List<String> arrAdmin = List<String>();

  _settingModalBottomSheet(context,) {
    showModalBottomSheet(
        backgroundColor:Colors.transparent,
        context: context,
        builder:(BuildContext bc) {
          return Container(
              height:360,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius:BorderRadius.only(
                    topRight:Radius.circular(30),
                    topLeft:Radius.circular(30)
                ),
//              border: Border.all(width:3,color: Colors.green,style: BorderStyle.solid)
              ),
              child:Center(
                child:Column(
                  children:<Widget>[
                    SizedBox(height:40),
                    Text(
                      'Log Out',
                      style:TextStyle(
                          fontSize:22,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.bold
                      ),
                    ),
                    SizedBox(height:30),
                    Image.asset(
                      Res.logOutProfile,
                      height:66,
                      width:66,
                    ),
                    SizedBox(height:16),
                    Text(
                      'Are your sure! \nYour want to Log out?',
                      textAlign:TextAlign.center,
                      style:TextStyle(
                          fontSize:14,
                          fontFamily:AppConstant.kPoppins,
                          color:HexColor('#84828F'),
                          fontWeight:FontWeight.normal
                      ),
                    ),
                    SizedBox(height:25),
                    Container(
                      margin:EdgeInsets.only(left:25,right: 25),
                      child:Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            padding:EdgeInsets.all(0),
                            child:Container(
                              alignment:Alignment.center,
                              height:56,
                              width:MediaQuery.of(context).size.width/2-40,
                              child:Text(
                                'Cancel',
                                textAlign:TextAlign.center,
                                style:TextStyle(
                                    fontSize:16,
                                    fontFamily:AppConstant.kPoppins,
                                    color:Colors.white,
                                    fontWeight:FontWeight.bold
                                ),
                              ),
                              decoration:BoxDecoration(
                                  color:AppConstant.color_blue_dark,
                                  borderRadius:BorderRadius.circular(14)
                              ),
                            ),
                            onPressed:() {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            padding:EdgeInsets.all(0),
                            child:Container(
                              alignment:Alignment.center,
                              height:56,
                              width:MediaQuery.of(context).size.width/2-40,
                              child:Text(
                                'Yes',
                                textAlign:TextAlign.center,
                                style:TextStyle(
                                    fontSize:16,
                                    fontFamily:AppConstant.kPoppins,
                                    color:Colors.white,
                                    fontWeight:FontWeight.bold
                                ),
                              ),
                              decoration:BoxDecoration(
                                  color:HexColor('#54C9AF'),
                                  borderRadius:BorderRadius.circular(14)
                              ),
                            ),
                            onPressed:() {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/intro');
                              FirebaseAuth.instance.signOut();
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  checkAdmin() {
    for (int i = 0;i<arrAdmin.length;i++) {
      if (arrAdmin[i] == dictUserDetails[kEmail]) {
        print('this user is admin');
        arrProfileTitles = List<String>.from(['Fitness Goal','Edit Profile','Settings',
          'Refer a Friend','FeedBack','Rate Us','Log Out','BMR Calculator','Set Workouts']);

        kIsAdmin = true;
        break;
      } else {
        arrProfileTitles = List<String>.from(['Fitness Goal','Edit Profile','Settings',
          'Refer a Friend','FeedBack','Rate Us','Log Out','BMR Calculator',]);
      }

      setState(() {

      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(microseconds:2),() async {

      QuerySnapshot querySnapshotAdmin = await Firestore.instance.collection(tblAdmin).getDocuments();
      List<Map<String, dynamic>> arrAdminDetails = querySnapshotAdmin.documents.map((DocumentSnapshot doc) {
        return doc.data;
      }).toList();

      arrAdmin = List<String>.from(arrAdminDetails[0][kAdminNumber]);

      checkAdmin();

//      showLoading(context);
      FirebaseAuth.instance.currentUser().then((value) {
        Firestore.instance.collection(tblUserDetails).document(
            value.email + kFireBaseConnect + value.uid).get().then((value) {
//          dismissLoading(context);
          dictUserDetails = value.data;

          checkAdmin();

          setState(() {
            strName = dictUserDetails[kFirstName]+' '+dictUserDetails[kLastName];
            strFitnessGoal = dictUserDetails[kFitnessGoal];
            strGendar = dictUserDetails[kGender];

            DateTime birthday = DateFormat('yyyy MMM dd').parse( dictUserDetails[kDateOfBirth]);
            final date2 = DateTime.now();
            strAge = ((date2.difference(birthday).inDays)/365).toStringAsFixed(1)+' years';
            strProfilePicture = dictUserDetails[kProfilePicture];
            print(strProfilePicture);

            setState(() {
              
            });
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
    // TODO: implement initState
    super.initState();
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
      body:StretchyHeader.listViewBuilder(
        headerData:HeaderData(
          headerHeight:350,
          header:Container(
            child:Container(
                width:double.infinity,
                height:350,
                decoration:BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft:Radius.circular(40),
                        bottomRight:Radius.circular(40)),
                    gradient:LinearGradient(
                      colors:[
                        HexColor('2E4877'),
                        HexColor('29364E')
                      ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                    )
                ),
                child:SingleChildScrollView(
                  physics:NeverScrollableScrollPhysics(),
                  child:Column(
                    children: <Widget>[
                      SizedBox(height:80,),
                      ClipRRect(
                          borderRadius:BorderRadius.circular(83),
                          child:FadeInImage(
                            fit:BoxFit.fill,
                            height:90,
                            width:90,
                            image:NetworkImage(
                                strProfilePicture
                            ),
                            placeholder:AssetImage(Res.ic_profile),
                          )
                      ),
                      SizedBox(height:16),
                      Container(
                        margin:EdgeInsets.only(left:16,right:16),
                        child:Text(
                          strName,
                          textAlign:TextAlign.center,
                          style:TextStyle(
                              color:Colors.white,
                              fontFamily:AppConstant.kPoppins,
                              fontWeight:FontWeight.bold,
                              fontSize:24
                          ),
                        ),
                      ),
                      Text(
                       strFitnessGoal,
                        style:TextStyle(
                            color:Colors.white,
                            fontFamily:AppConstant.kPoppins,
                            fontWeight:FontWeight.w600,
                            fontSize:16
                        ),
                      ),
                      SizedBox(height:4),
                      Center(
                        child:Container(
                          height:30,
                          child:Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Image.asset(
                                    Res.maleWhite,
                                    height:24,
                                  ),
                                  SizedBox(width:10),
                                  Text(
                                    strGendar,
                                    style:TextStyle(
                                        color:Colors.white,
                                        fontFamily:AppConstant.kPoppins,
                                        fontWeight:FontWeight.w600,
                                        fontSize:16
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(width:10),
                              Container(
                                width:3,
                                height:20,
                                color:Colors.white,
                              ),
                              SizedBox(width:10),
                              Text(
                                strAge,
                                style:TextStyle(
                                    color:Colors.white,
                                    fontFamily:AppConstant.kPoppins,
                                    fontWeight:FontWeight.w600,
                                    fontSize:16
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ),
          )
        ),
        itemCount:arrProfileTitles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child:Container(
              height:50,
              margin:EdgeInsets.only(left:30,right:30,top:15,bottom:15),
              decoration:BoxDecoration(
                color:Colors.white,//black12,
              ),
              child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Image.asset(
                    arrProfileIcons[index],
                    height:50,
                  ),
                  Container(
                    margin:EdgeInsets.only(left:20),
                    width:MediaQuery.of(context).size.width-180,
                    child:Text(
                      arrProfileTitles[index],
                      textAlign:TextAlign.left,
                      style:TextStyle(
                          color:AppConstant.color_blue_dark,
                          fontFamily:AppConstant.kPoppins,
                          fontWeight:FontWeight.w600,
                          fontSize:16
                      ),
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    size:36,
                    color:AppConstant.color_blue_dark,
                  ),
                ],
              ),
            ),
            onTap:() {
              if (index == 0 ) {
                Navigator.pushNamed(context, '/FitnessGoalScreenEdit');
              }

//              else if (index == 1 ) {
//                Navigator.pushNamed(context, '/MyCards');
//              }

              else if (index == 1 ) {
                Navigator.pushNamed(context, '/ProfileScreenEdit');
              } else if (index == 2 ) {
                Navigator.pushNamed(context, '/setting');
              } else if (index == 3) {
                Share.share('check out my website https://example.com');
              } else if (index == 4) {
                Navigator.pushNamed(context, '/FeedBack');
              } else if (index == 5) {
                // https://apps.apple.com/in/app/alfa-active-life-for-all/id1541793700
                RateInStore.rate(iOSAppID: 'id1541793700', androidAppID: 'com.xxx.xxx');
              } else if (index == 6) {
                _settingModalBottomSheet(context);
              } else if (index == 7) {
                Navigator.pushNamed(context, '/Calculator');
              } else {
                Navigator.pushNamed(context, '/SetWorkouts');
              }
            },
          );
        },
      ),
    );
  }
}




