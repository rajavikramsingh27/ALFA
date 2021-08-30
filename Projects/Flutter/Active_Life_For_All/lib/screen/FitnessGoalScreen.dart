import 'package:alfa/utils/Constents.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

class FitnessGoalScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FitnessGoalScreenState ();
}



class FitnessGoalScreenState extends State<FitnessGoalScreen> {
  var indexSelected = -1;

  List<Map<String, dynamic>> arrFitnessGoal = [];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds:1),() async {
      showLoading(context);
      QuerySnapshot querySnapshot = await Firestore.instance.collection(tblFitnessGoal).getDocuments();
      arrFitnessGoal = querySnapshot.documents.map((DocumentSnapshot doc) {
        return doc.data;
      }).toList();
      print(arrFitnessGoal);
      dismissLoading(context);

      setState(() {

      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        bottom:false,
          child:Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment:Alignment.centerLeft,
                  padding:EdgeInsets.only(left:16,top:36,bottom:10),
                  decoration:BoxDecoration(
                      border:Border(
                        bottom: BorderSide(
                            width:0.4,
                            color:HexColor('#BEBEBE')
                        ),
                      )
                  ),
                  child:Text(
                    "What Is Your Fitness\nGoal?",
                    style:TextStyle(
                        fontSize:24,
                        fontFamily: AppConstant.kPoppins,
                        color: AppConstant.color_blue_dark,
                        fontWeight:FontWeight.w700
                    ),
                  )
              ),
              SafeArea(
               child:Container(
                 // margin:EdgeInsets.only(top:0),
                 height:MediaQuery.of(context).size.height-170
                     -MediaQuery.of(context).padding.bottom,
                 child:ListView.builder(
                   padding:EdgeInsets.only(bottom:20+MediaQuery.of(context).padding.bottom),
                   scrollDirection:Axis.vertical,
                   itemCount:arrFitnessGoal.length+1,
                   itemBuilder:(context, index) {
                     if (index == arrFitnessGoal.length) {
                       return Container(
                         height:54,
                         margin:EdgeInsets.only(top:35,left:35,right:35),
                         width:MediaQuery.of(context).size.width-90,
                         decoration:(indexSelected > -1)
                             ? kButtonThemeGradientColor()
                             : BoxDecoration(
                             color:HexColor('#C1C1C1'),
                             borderRadius:BorderRadius.circular(14)
                         ),
                         child:FlatButton(
                           padding:EdgeInsets.all(0),
                           child:Text(
                             'Next',
                             style:TextStyle(
                                 color:Colors.white,
                                 fontFamily:AppConstant.kPoppins,
                                 fontWeight:FontWeight.normal,
                                 fontSize:16
                             ),
                           ),
                           onPressed:() {
                             if (indexSelected > -1) {
                               showLoading(context);
                               FirebaseAuth.instance.currentUser().then((value) {
                                 Firestore.instance.collection(tblUserDetails).document(value.email+kFireBaseConnect+value.uid).updateData({
                                   kFitnessGoal:arrFitnessGoal[index-1][kTitle]
                                 }).then((value) {
                                   dismissLoading(context);
                                   Navigator.pushNamed(context, '/DailyLife');
                                 }).catchError((error) {
                                   dismissLoading(context);
                                      Toast.show(
                                          error.message.toString(),
                                          context,
                                          backgroundColor:HexColor(redColor)
                                      );
                                 });
                               });
                             }
                           },
                         ),
                       );
                     } else {
                       return GestureDetector(
                           child:Container(
                               height:80,
                               margin:EdgeInsets.only(left:16,right: 16,top:20),
                               padding:EdgeInsets.only(left:20,right:10,top:10),
                               width:double.infinity,
                               decoration:(index == indexSelected)
                                   ? kFitnessThemeGradientColor()
                                   : BoxDecoration(
                                   color:Colors.white,
                                   border: Border.all(color: Color(0xff54C9AF)),
                                   borderRadius: BorderRadius.circular(15)
                               ),
                               child:Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   Text(
                                     arrFitnessGoal[index][kTitle],
                                     style:TextStyle(
                                         fontSize:18,
                                         fontFamily: AppConstant.kPoppins,
                                         color: (index == indexSelected)
                                             ? Colors.white
                                             : AppConstant.color_blue_dark,
                                         fontWeight:FontWeight.w600
                                     ),
                                   ),
                                   SizedBox(height:4,),
                                   Text(
                                     arrFitnessGoal[index][kSubtitle],
                                     style:TextStyle(
                                         fontSize:12,
                                         fontFamily:AppConstant.kPoppins,
                                         color:(index == indexSelected)
                                             ? Colors.white
                                             : HexColor('#84828F'),
                                         fontWeight:FontWeight.normal
                                     ),
                                   ),
                                 ],
                               )
                           ),
                           onTap:() {
                             indexSelected = index;
                             setState(() {

                             });
                           }
                       );
                     }
                   },
                 ),
               ),
             )
            ],
          ),
      ),
    );
  }
}

