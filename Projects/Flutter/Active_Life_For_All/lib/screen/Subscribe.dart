
import 'package:alfa/utils/Constents.dart';
import 'package:flutter/material.dart';


class Subscribe extends StatefulWidget {
  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.white,
        appBar:AppBar(
            title:Text(
              'Subscribe Now',
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
        body:Container(
          margin:EdgeInsets.only(left:20,right:20),
          child:SingleChildScrollView(
            physics:BouncingScrollPhysics(),
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height:30,),
//                name
                Text(
                  'Name',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:14),
                TextFormField(
                  keyboardAppearance:Brightness.light,
                  textAlign: TextAlign.left,
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w400
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
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
                ),
//                Credit/Debit Card
                SizedBox(height:20),
                Text(
                  'Credit/Debit Card',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:14),
                TextFormField(
                  keyboardAppearance:Brightness.light,
                  textAlign: TextAlign.left,
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w400
                  ),
                  decoration: InputDecoration(
                    hintText: 'Credit/Debit Card',
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
                ),
//                Expiry
                SizedBox(height:20),
                Text(
                  'Expiry',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:14),
                TextFormField(
                  keyboardAppearance:Brightness.light,
                  textAlign: TextAlign.left,
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w400
                  ),
                  decoration: InputDecoration(
                    hintText: 'MM/YY',
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
                ),
//                Security Code
                SizedBox(height:20),
                Text(
                  'Security Code',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:14),
                TextFormField(
                  keyboardAppearance:Brightness.light,
                  textAlign: TextAlign.left,
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w400
                  ),
                  decoration: InputDecoration(
                    hintText: 'Security Code',
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
                ),

                SizedBox(height:70),
                FlatButton(
                  textColor:Colors.white,
                  child:Container(
                    height:56,
                    width:double.infinity,
                    decoration:kButtonThemeGradientColor(),
                    alignment:Alignment.center,
                    child:Text(
                      'Start Free Trial',
                      style:TextStyle(
                          fontSize:18,
                          fontFamily:AppConstant.kPoppins,
                          color:Colors.white,
                          fontWeight:FontWeight.normal
                      ),
                    ),
                  ),
                  onPressed:() {
                    print('share');
                  },
                )
              ],
            ),
          ),
        )
    );
  }
}
