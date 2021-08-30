

import 'package:alfa/res.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:flutter/material.dart';


class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationScreenState ();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<bool> arrSelectedDesc = [];

  @override
  void initState() {
    // TODO: implement initState

    for (var i=0;i<10;i++) {
      arrSelectedDesc.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar:AppBar(
            title:Text(
              'Notifications',
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
        body:SafeArea(
          child:ListView.builder(
            padding:EdgeInsets.only(top:20),
            scrollDirection:Axis.vertical,
            itemCount:10,
            itemBuilder:(context, index) {
              return GestureDetector(
                child:Container(
                  height:arrSelectedDesc[index]
                      ? null : 130,
                  padding:EdgeInsets.only(
                      left:16,right:16,
                      top:20,bottom:20,
                  ),
                  decoration:BoxDecoration(
                    border:Border(
                      bottom:BorderSide(
                        color:Colors.grey.withOpacity(0.4),
                        width:1
                      )
                    )
                  ),
                  child:Row(
                    mainAxisAlignment:MainAxisAlignment.start,
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        Res.ic_notification,
                        height:60,
                      ),
                      Container(
                        margin:EdgeInsets.only(
                          left:16,right:0,
                        ),
                        width:MediaQuery.of(context).size.width-108,
                        child:SingleChildScrollView(
                          physics:NeverScrollableScrollPhysics(),
                          child:Column(
                            children: <Widget>[
                              Text(
                                'What is one thing you are grateful for today?',
                                style:TextStyle(
                                    fontSize:14,
                                    fontFamily:AppConstant.kPoppins,
                                    color:AppConstant.color_blue_dark,
                                    fontWeight:FontWeight.w500
                                ),
                              ),
                              SizedBox(height:10,),
                              Text(
                                'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata ',
                                style:TextStyle(
                                    fontSize:13,
                                    fontFamily:AppConstant.kPoppins,
                                    color:AppConstant.color_blue_dark,
                                    fontWeight:FontWeight.normal
                                ),
                              ),
                            ],
                          ),
                        )
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
      )
    );
  }
}

Widget getItemTrending(BuildContext context) {
  return GestureDetector(
    onTap: (){
      Navigator.pushNamed(context, '/detail');
    },
    child:Card(
      elevation: 5,
      child: Container(
        height: 100,
        margin: EdgeInsets.only(left: 12,right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16,top: 10),
                      child:
                      Image.asset(Res.ic_notification,width: 60,height: 80,),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16,top: 10),
                      child:  Text("Notification",style: TextStyle(fontFamily: AppConstant.fontBold,fontSize: 16),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16,top: 8),
                      child:  Text("Lorem ipsum doloar sit amet",style: TextStyle(fontFamily: AppConstant.fontBold,fontSize: 14,color: Colors.grey.shade300),),
                    )
                  ],

                )

              ],
            )


          ],
        ),
      ),
    )
  );
}