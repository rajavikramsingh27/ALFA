
import 'package:alfa/utils/Constents.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';
import '../res.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ForgotPasswordState ();
}
class ForgotPasswordState extends State<ForgotPassword> {
  final textPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
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
      body:Container(
          color:Colors.white,
          child:Stack(
            children: <Widget>[
              SingleChildScrollView(
                physics:NeverScrollableScrollPhysics(),
                child:Container(
                  color:Colors.white,
                  height:MediaQuery.of(context).size.height-70,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height:25,
                      ),
                      Container(
                        alignment:Alignment.center,
                        child:Image.asset(Res.ic_logo,width:190,height:80,),
                      ),
                      SizedBox(
                        height:35,
                      ),
                      Text(
                        'Forgot Pasword',
                        style:TextStyle(
                            fontSize:30,
                            fontFamily:AppConstant.kPoppins,
                            color:AppConstant.color_blue_dark,
                            fontWeight:FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height:40,
                      ),
                      Container(
                        margin:EdgeInsets.only(left:30,right: 30),
                        child:Padding(
                          padding:EdgeInsets.only(left: 1),
                          child:TextField(
                              controller:textPassword,
                              keyboardType:TextInputType.emailAddress,
                              keyboardAppearance:Brightness.light,
                              cursorColor: Color(0xff84828F),
                              onChanged:(text) {
//                                Navigator.pushNamed(context, '/emailsent');
                              },
                              style:TextStyle(
                                  fontFamily:AppConstant.kPoppins,
                                  fontWeight:FontWeight.normal,
                                  fontSize:12
                              ),
                              decoration: InputDecoration(
                                  labelText:'Email Address',
                                  hintStyle:TextStyle(color: AppConstant.color_blue_dark),
                                  /*border: InputBorder.none,*/
                                  fillColor: Color(0xff84828F))),
                        ),
                      ),
                      SizedBox(
                        height:120,
                      ),
                      SafeArea(
                        child:Container(
                          margin:EdgeInsets.only(left:30,right:30,),
                          width:MediaQuery.of(context).size.width-60,
                          height:50,
                          decoration:textPassword.text.isEmpty ?
                          BoxDecoration(
                            color:HexColor('#C1C1C1'),
                            borderRadius:BorderRadius.circular(16),
                          ) : kButtonThemeGradientColor(),
                          child:FlatButton(
                              textColor:Colors.white,
                              onPressed:() async {
                                bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(textPassword.text);
                                if (textPassword.text.isEmpty) {
                                  Toast.show('Enter Email-ID', context,
                                      duration: 2,
                                      gravity: Toast.BOTTOM,
                                      backgroundColor: HexColor(redColor));
                                } else if (!emailValid) {
                                  Toast.show('Enter a valid email ID', context,
                                      duration: 2,
                                      gravity: Toast.BOTTOM,
                                      backgroundColor: HexColor(redColor));
                                } else {
                                  showLoading(context);
                                  await FirebaseAuth.instance.sendPasswordResetEmail(email:textPassword.text)
                                      .then((value) {
                                    dismissLoading(context);
                                  Navigator.pushNamed(context, '/EmailSent');
                                  }).catchError((error) {
                                    dismissLoading(context);
                                    Toast.show(
                                        error.message.toString(),
                                        context,
                                        duration:2,
                                        gravity:Toast.BOTTOM,
                                        backgroundColor: HexColor(redColor)
                                    );
                                  });
                                }
                              },
                              child:Text(
                                'Forgot Password',
                                style:TextStyle(
                                    color:Colors.white,
                                    fontFamily:AppConstant.kPoppins,
                                    fontWeight:FontWeight.normal,
                                    fontSize:16
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ],
          )
      ),
    );
  }
}