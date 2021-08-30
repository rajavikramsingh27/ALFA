import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Faq extends StatefulWidget {
  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  List<bool> arrSelectedDesc = [];
  List<Map<String, dynamic>> arrFeedbacks = [];


  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration(milliseconds:1),() async {
      showLoading(context);
      QuerySnapshot querySnapshot = await Firestore.instance.collection(tblFeedback).getDocuments();
      arrFeedbacks = querySnapshot.documents.map((DocumentSnapshot doc) {
        return doc.data;
      }).toList();
      dismissLoading(context);
      print(arrFeedbacks);
      for (var i=0;i<arrFeedbacks.length;i++) {
        arrSelectedDesc.add(false);
      }

      setState(() {

      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar:AppBar(
          title:Text(
            "FAQ's",
            style:TextStyle(
                fontSize:18,
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
          elevation:0.5,
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
      body:ListView.builder(
        padding:EdgeInsets.only(top:30),
        scrollDirection:Axis.vertical,
        itemCount:arrFeedbacks.length,
        itemBuilder:(context, index) {
          return GestureDetector(
            child:Container(
//              height:60,
              margin:EdgeInsets.only(left:30,right:30),
              width:MediaQuery.of(context).size.width-90,
              child:Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: <Widget>[
                     Container(
                       width:MediaQuery.of(context).size.width-90,
                       child: Text(
                         arrFeedbacks[index][kFeedbackTitle],
                         style:TextStyle(
                             fontSize:16,
                             fontFamily:AppConstant.kPoppins,
                             color:AppConstant.color_blue_dark,
                             fontWeight:FontWeight.w600
                         ),
                       ),
                     ),
                      SizedBox(height:14),
                      Visibility(
                        visible:arrSelectedDesc[index],
                        child:Container(
                          width:MediaQuery.of(context).size.width-90,
                          child:Text(
                            arrFeedbacks[index][kFeedbackDescription],
                            maxLines:100,
                            style:TextStyle(
                                fontSize:16,
                                fontFamily:AppConstant.kPoppins,
                                color:HexColor('#84828F'),
                                fontWeight:FontWeight.normal
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:14),
                    ],
                  ),
                  Icon(
                    arrSelectedDesc[index]
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size:30,
                    color:AppConstant.color_blue_dark,
                  )
                ],
              ),
            ),
            onTap:() {
              for (var i=0;i<10;i++) {
                if (i==index) {
                  if (arrSelectedDesc[i]) {
                    arrSelectedDesc[i] = false;
                  } else {
                    arrSelectedDesc[i] = true;
                  }
                }
              }

              setState(() {

              });
            },
          );
        },
      ),
    );
  }
}


