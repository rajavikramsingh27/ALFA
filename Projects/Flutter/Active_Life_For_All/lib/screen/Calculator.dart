import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter/rendering.dart';
import '../res.dart';
import 'package:toast/toast.dart';


class Calculator extends StatefulWidget {

  const Calculator({
    Key key,
  }) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var isUsUnits = false;
  var isMale = true;
  var isFemale = false;

  var isHeight = false;
  var isWeight = false;
  var isResult = false;

  var strCalPerDay = 0.0;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();

  TextEditingController textAge = TextEditingController();
  TextEditingController textHeightFeet = TextEditingController();
  TextEditingController textHeightInches = TextEditingController();
  TextEditingController textHeightCm = TextEditingController();
  TextEditingController textWeight = TextEditingController();


  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
//      keyboardSeparatorColor:AppConstant.color_blue_dark,
      keyboardActionsPlatform:KeyboardActionsPlatform.ALL,
      keyboardBarColor:HexColor('54C9AF'),
      nextFocus:false,

      actions:[
        KeyboardActionsItem(
          focusNode:_nodeText1,
        ),
        KeyboardActionsItem(
          focusNode:_nodeText2,
        ),
        KeyboardActionsItem(
          focusNode:_nodeText3,
        ),
        KeyboardActionsItem(
          focusNode:_nodeText4,
        ),
        KeyboardActionsItem(
          focusNode:_nodeText5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.white,
        appBar:AppBar(
            title:Text(
              'BMR Calculator',
              style:TextStyle(
                  fontSize:18,
                  fontFamily:AppConstant.kPoppins,
                  color:AppConstant.color_blue_dark,
                  fontWeight:FontWeight.bold
              ),
            ),
            textTheme:TextTheme(
                title:TextStyle(
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
                }),
          actions: [
            IconButton(
              icon:Image.asset(Res.reload),
              onPressed:() {
                textAge.text = '';
                textHeightFeet.text = '';
                textHeightInches.text = '';
                textHeightCm.text = '';
                textWeight.text = '';
                isResult = false;

                setState(() {

                });
              },
            ),
            SizedBox(width:10)
          ],
        ),
        body:KeyboardActions(
          config:_buildConfig(context),
          child:Container(
            margin:EdgeInsets.only(left:20,right:20),
            child:SingleChildScrollView(
              physics:BouncingScrollPhysics(),
              child:Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height:30,),
                  Text(
                    'Age',
                    style:TextStyle(
                        fontSize:16,
                        fontFamily:AppConstant.kPoppins,
                        color:AppConstant.color_blue_dark,
                        fontWeight:FontWeight.w600
                    ),
                  ),
                  SizedBox(height:14),
                  TextFormField(
                    focusNode:_nodeText1,
                    controller:textAge,
                    keyboardType:TextInputType.number,
                    keyboardAppearance:Brightness.light,
                    textAlign: TextAlign.left,
                    style:TextStyle(
                        fontSize:16,
                        fontFamily:AppConstant.kPoppins,
                        color:AppConstant.color_blue_dark,
                        fontWeight:FontWeight.w400
                    ),
                    decoration: InputDecoration(
                      hintText: 'Age 15 - 80',
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
                  SizedBox(height:20),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    alignment:Alignment.centerLeft,
                    child:Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Gender',
                          style:TextStyle(
                              fontSize:16,
                              fontFamily:AppConstant.kPoppins,
                              color:AppConstant.color_blue_dark,
                              fontWeight:FontWeight.w600
                          ),
                        ),
                        SizedBox(height:10),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              padding:EdgeInsets.only(left: 0),
                              textColor:Colors.white,
                              child:Row(
                                children: <Widget>[
                                  Image.asset(
                                    isMale ? Res.ic_male : Res.maleUnselectet,
                                    height:40,
                                  ),
                                  SizedBox(width:16),
                                  Text(
                                    'Male',
                                    style:TextStyle(
                                        color:HexColor('#000000'),
                                        fontFamily:AppConstant.kPoppins,
                                        fontWeight:FontWeight.normal,
                                        fontSize:16
                                    ),
                                  )
                                ],
                              ),
                              onPressed:(){
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isMale = true;
                                  isFemale = false;
                                });
                              },
                            ),
                            FlatButton(
                              textColor:Colors.white,
                              child:Row(
                                children: <Widget>[
                                  Image.asset(
                                    isFemale ? Res.ic_female : Res.femaleUnselected,
//                                Res.femaleUnselected,
                                    height:40,
                                  ),
                                  SizedBox(width:16),
                                  Text(
                                    'Female',
                                    style:TextStyle(
                                        color:HexColor('#000000'),
                                        fontFamily:AppConstant.kPoppins,
                                        fontWeight:FontWeight.normal,
                                        fontSize:16
                                    ),
                                  )
                                ],
                              ),
                              onPressed:() {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isMale = false;
                                  isFemale = true;
                                });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height:20),
                  Text(
                    'Height',
                    style:TextStyle(
                        fontSize:16,
                        fontFamily:AppConstant.kPoppins,
                        color:AppConstant.color_blue_dark,
                        fontWeight:FontWeight.w600
                    ),
                  ),
                  SizedBox(height:14),
                  Visibility(
                    visible:!isUsUnits ? true : false,
                    child:TextFormField(
                      focusNode:_nodeText2,
                      controller:textHeightCm,
                      keyboardType:TextInputType.number,
                      keyboardAppearance:Brightness.light,
                      textAlign:TextAlign.left,
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w400
                      ),
                      decoration: InputDecoration(
                        hintText: 'cm',
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
                  ),
                  Visibility(
                      visible:isUsUnits ? true : false,
                    child:Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:(MediaQuery.of(context).size.width-50)/2,
                          height:50,
                          child:TextFormField(
                            focusNode:_nodeText4,
                            controller:textHeightFeet,
                            keyboardType:TextInputType.number,
                            keyboardAppearance:Brightness.light,
                            textAlign:TextAlign.left,
                            style:TextStyle(
                                fontSize:16,
                                fontFamily:AppConstant.kPoppins,
                                color:AppConstant.color_blue_dark,
                                fontWeight:FontWeight.w400
                            ),
                            decoration: InputDecoration(
                              hintText: 'Feet',
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
                        ),
                        Container(
                          width:(MediaQuery.of(context).size.width-50)/2,
                          height:50,
                          child:TextFormField(
                            focusNode:_nodeText5,
                            controller:textHeightInches,
                            keyboardType:TextInputType.number,
                            keyboardAppearance:Brightness.light,
                            textAlign:TextAlign.left,
                            style:TextStyle(
                                fontSize:16,
                                fontFamily:AppConstant.kPoppins,
                                color:AppConstant.color_blue_dark,
                                fontWeight:FontWeight.w400
                            ),
                            decoration: InputDecoration(
                              hintText: 'Inches',
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
                        )
                      ],
                    )
                  ),
//                Weight
                  SizedBox(height:20),
                  Text(
                    'Weight',
                    style:TextStyle(
                        fontSize:16,
                        fontFamily:AppConstant.kPoppins,
                        color:AppConstant.color_blue_dark,
                        fontWeight:FontWeight.w600
                    ),
                  ),
                  SizedBox(height:14),
                  TextFormField(
                    focusNode:_nodeText3,
                    keyboardType:TextInputType.number,
                    controller:textWeight,
                    keyboardAppearance:Brightness.light,
                    textAlign: TextAlign.left,
                    style:TextStyle(
                        fontSize:16,
                        fontFamily:AppConstant.kPoppins,
                        color:AppConstant.color_blue_dark,
                        fontWeight:FontWeight.w400
                    ),
                    decoration: InputDecoration(
                      hintText: isUsUnits ? 'Pounds' : 'Kg',
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
                  SizedBox(height:30),
                  FlatButton(
                    textColor:Colors.white,
                    child:Container(
                      height:56,
                      width:double.infinity,
                      decoration:kButtonThemeGradientColor(),
                      alignment:Alignment.center,
                      child:Text(
                        'Calculator',
                        style:TextStyle(
                            fontSize:18,
                            fontFamily:AppConstant.kPoppins,
                            color:Colors.white,
                            fontWeight:FontWeight.normal
                        ),
                      ),
                    ),
                    onPressed:() {
                       FocusScope.of(context).unfocus();
                      if (textAge.text.isEmpty) {
                        Toast.show(
                            'Enter an age',
                            context,
                            backgroundColor:HexColor(redColor)
                        );
                      } else if (int.parse(textAge.text) < 15 || int.parse(textAge.text) > 80 ) {
                        Toast.show(
                            'Age should be 15 - 80',
                            context,
                            backgroundColor:HexColor(redColor)
                        );
                      } else if (isUsUnits && textHeightFeet.text.isEmpty) {
                        Toast.show(
                            'Enter an height',
                            context,
                            backgroundColor:HexColor(redColor)
                        );
                      } else if (!isUsUnits && textHeightCm.text.isEmpty) {
                        Toast.show(
                            'Enter an height',
                            context,
                            backgroundColor:HexColor(redColor)
                        );
                      } else if (textWeight.text.isEmpty) {
                        Toast.show(
                            'Enter an weight',
                            context,
                            backgroundColor:HexColor(redColor)
                        );
                      } else {
                        var weight = 0.0;
                        var Height = 0.0;
                        var age = int.parse(textAge.text);

                        if (isUsUnits) {

                          if (textHeightInches.text.isEmpty) {
                            print('sssss');
                            Height = double.parse(textHeightFeet.text)*12;
                          } else {
                            print('sssss33333');
                            Height = (double.parse(textHeightFeet.text)*12)+(double.parse(textHeightInches.text)*12);
                          }
                          weight = 2.20462262185*double.parse(textWeight.text);
                        } else {
                          print('sssss44444');
                          Height = double.parse(textHeightCm.text);
                          weight = double.parse(textWeight.text);
                        }

                        if (isMale) {
                          strCalPerDay = 10*weight +
                              6.25*Height - 5*age
                              + 5;
                        } else {
                          strCalPerDay = 10*weight +
                              6.25*Height - 5*age
                              - 161;
                        }
                        strCalPerDay = double.parse(strCalPerDay.toStringAsFixed(2));

                        isResult = true;
                        setState(() {

                        });
                      }
                    },
                  ),
                  SizedBox(height:60),
                  Visibility(
                    visible:isResult,
                    child:Container(
                        width:double.infinity,
                        decoration:kGoalButtonThemeGradientColor(),
                        padding:EdgeInsets.all(16),
                        alignment:Alignment.centerLeft,
                        child:Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Result',
                              style:TextStyle(
                                  fontSize:22,
                                  fontFamily:AppConstant.kPoppins,
                                  color:Colors.white,
                                  fontWeight:FontWeight.w500
                              ),
                            ),
                            SizedBox(height:6),
                            Text(
                              'BMR = ${strCalPerDay.toStringAsFixed(0)} Calories / day',
                              style:TextStyle(
                                  fontSize:20,
                                  fontFamily:AppConstant.kPoppins,
                                  color:Colors.white,
                                  fontWeight:FontWeight.normal
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                  SizedBox(height:30,),
                  Container(
                    width:MediaQuery.of(context).size.width-40,
                    child:Column(
                      children:[
                        Visibility(
                          visible:isResult,
                          child:Column(
                            children:[
                              Text(
                                'Total recommended calorie intake to maintain current weight:',
                                style:TextStyle(
                                    fontSize:18,
                                    fontFamily:AppConstant.kPoppins,
                                    color:Colors.black,
                                    fontWeight:FontWeight.w600
                                ),
                              ),
                              SizedBox(
                                height:14,
                              ),
                              Container(
                                  width:double.infinity,
                                  decoration:kGoalButtonThemeGradientColor(),
                                  alignment:Alignment.centerLeft,
                                  child:Column(
                                    children: [
                                      Container(
                                        padding:EdgeInsets.only(left:10,right:10,top:16,bottom:16),
                                        child:Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:Text(
                                                'Activity Level',
                                                style:TextStyle(
                                                    fontSize:16,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.w500
                                                ),
                                              ),
                                              width:(MediaQuery.of(context).size.width-80)/3,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                'Description',
                                                style:TextStyle(
                                                    fontSize:16,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.w500
                                                ),
                                              ),
                                              width:(MediaQuery.of(context).size.width-80)/3,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                'Calories Burned / Day',
                                                style:TextStyle(
                                                    fontSize:15,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.w500
                                                ),
                                              ),
                                              width:(MediaQuery.of(context).size.width-80)/3,
//                                        color:Colors.red,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:MediaQuery.of(context).size.width-10,
                                        height:1,
                                        color:Colors.white,
                                      ),
                                      Container(
                                        padding:EdgeInsets.only(left:10,right:10,top:10,bottom:0),
                                        child:Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:Text(
                                                'Low',
                                                style:TextStyle(
                                                    fontSize:14,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:70,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                'You get little to no exercise.',
                                                textAlign:TextAlign.center,
                                                style:TextStyle(
                                                    fontSize:12,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:MediaQuery.of(context).size.width
                                                  -((MediaQuery.of(context).size.width-80)/3)-130,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                '${(strCalPerDay*1.2).toStringAsFixed(0)} Calories \n/ Day',
                                                textAlign:TextAlign.right,
                                                style:TextStyle(
                                                    fontSize:13,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:(MediaQuery.of(context).size.width-80)/3,
//                                        color:Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:EdgeInsets.only(left:10,right:10,top:20,bottom:0),
                                        child:Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:Text(
                                                'Light',
                                                style:TextStyle(
                                                    fontSize:14,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:70,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                'You exercise lightly \n(1-3 days per week)',
                                                textAlign:TextAlign.center,
                                                style:TextStyle(
                                                    fontSize:12,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:MediaQuery.of(context).size.width
                                                  -((MediaQuery.of(context).size.width-80)/3)-130,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                '${(strCalPerDay*1.3).toStringAsFixed(0)} Calories \n/ Day',
                                                textAlign:TextAlign.right,
                                                style:TextStyle(
                                                    fontSize:13,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:(MediaQuery.of(context).size.width-80)/3,
//                                        color:Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:EdgeInsets.only(left:10,right:10,top:20,bottom:0),
                                        child:Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:Text(
                                                'Moderate',
                                                style:TextStyle(
                                                    fontSize:14,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:70,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                'You exercise moderate \n(3-5 days per week)',
                                                textAlign:TextAlign.center,
                                                style:TextStyle(
                                                    fontSize:12,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:MediaQuery.of(context).size.width
                                                  -((MediaQuery.of(context).size.width-80)/3)-130,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                '${(strCalPerDay*1.5).toStringAsFixed(0)} Calories \n/ Day',
                                                textAlign:TextAlign.right,
                                                style:TextStyle(
                                                    fontSize:13,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:(MediaQuery.of(context).size.width-80)/3,
//                                        color:Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:EdgeInsets.only(left:10,right:10,top:20,bottom:0),
                                        child:Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:Text(
                                                'High',
                                                style:TextStyle(
                                                    fontSize:14,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:70,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                'You exercise heavily \n(6-7 days per week)',
                                                textAlign:TextAlign.center,
                                                style:TextStyle(
                                                    fontSize:12,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:MediaQuery.of(context).size.width
                                                  -((MediaQuery.of(context).size.width-80)/3)-130,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                '${(strCalPerDay*1.7).toStringAsFixed(0)} Calories \n/ Day',
                                                textAlign:TextAlign.right,
                                                style:TextStyle(
                                                    fontSize:13,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:(MediaQuery.of(context).size.width-80)/3,
//                                        color:Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:EdgeInsets.only(left:10,right:10,top:20,bottom:20),
                                        child:Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:Text(
                                                'Very High',
                                                style:TextStyle(
                                                    fontSize:14,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:70,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                'You exercise very heavily \n(i.e. 2x days per day extra heavy workouts.)',
                                                textAlign:TextAlign.center,
                                                style:TextStyle(
                                                    fontSize:12,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:MediaQuery.of(context).size.width
                                                  -((MediaQuery.of(context).size.width-80)/3)-130,
//                                        color:Colors.red,
                                            ),
                                            Container(
                                              child:Text(
                                                '${(strCalPerDay*1.9).toStringAsFixed(0)} Calories \n/ Day',
                                                textAlign:TextAlign.right,
                                                style:TextStyle(
                                                    fontSize:13,
                                                    fontFamily:AppConstant.kPoppins,
                                                    color:Colors.white,
                                                    fontWeight:FontWeight.normal
                                                ),
                                              ),
                                              width:(MediaQuery.of(context).size.width-80)/3,
//                                        color:Colors.red,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(
                                height:30,
                              ),
                              Text(
                                'To lose 0.5kg per week you should reduce your total recommended daily calorie intake by 500cals.',
                                style:TextStyle(
                                    fontSize:19,
                                    fontFamily:AppConstant.kPoppins,
                                    color:Colors.black,
                                    fontWeight:FontWeight.w600
                                ),
                              ),
                            ],
                          )
                        ),
                      ],
                    )
                  ),
                  SizedBox(height:30,),
                ],
              ),
            ),
          ),
        )
    );
  }
}


