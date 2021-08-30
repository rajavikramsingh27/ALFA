import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:alfa/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';

import 'dart:ui';
import '../res.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';



class WeeklyProgressTracker extends StatefulWidget {
  @override
  _WeeklyProgressTrackerState createState() => _WeeklyProgressTrackerState();
}



class _WeeklyProgressTrackerState extends State<WeeklyProgressTracker> {
  bool isDidYouAchieveYour_Health_FitnessGoal = false;
  bool isDidYouAchieveYour_Work_PersonalGoal = false;

  var textWeight = TextEditingController();
  var textWaist = TextEditingController();
  var textHips = TextEditingController();
  var textChest = TextEditingController();
  var textThigh = TextEditingController();
  var textWhatIsYour_Health_FitnessGoal_NextWeek = TextEditingController();
  var textWhatIsYour_Work_PersonalLife_Goal_NextWeek = TextEditingController();

  File _image;
  String strImage = '';

  final picker = ImagePicker();
  String formattedDate = '';

  @override
  void initState() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy_MMM_dd');
    formattedDate = formatter.format(now);

    Future.delayed(Duration(milliseconds:5),() {
      FirebaseAuth.instance.currentUser().then((value) {
        Firestore.instance.collection(tblGoals).document(value.email+kFireBaseConnect+value.uid).collection(formattedDate).document(formattedDate)
            .get().then((value) {
          var dictWeeklyGoalsTracker = Map<String,dynamic>.from(value.data[kWeeklyGoalsTracker]);

          setState(() {
            if (dictWeeklyGoalsTracker != null) {
              textWeight.text = dictWeeklyGoalsTracker[kWeight];
              textWaist.text = dictWeeklyGoalsTracker[kWaist];
              textHips.text = dictWeeklyGoalsTracker[kHips];
              textChest.text = dictWeeklyGoalsTracker[kChest];
              textThigh.text = dictWeeklyGoalsTracker[kThigh];
              textWhatIsYour_Health_FitnessGoal_NextWeek.text = dictWeeklyGoalsTracker[kWhatIsYour_Health_Fitness_Goal_Next_Week];
              textWhatIsYour_Work_PersonalLife_Goal_NextWeek.text = dictWeeklyGoalsTracker[kWhatIsYour_Work_Personal_Life_Goal_Next_Week];
              isDidYouAchieveYour_Health_FitnessGoal = dictWeeklyGoalsTracker[kDidYouAchieveYour_Health_FitnessGoal_Next_Week];
              isDidYouAchieveYour_Work_PersonalGoal = dictWeeklyGoalsTracker[kDidYouAchieveYour_Work_PersonalGoal_Next_Week];
              strImage  = dictWeeklyGoalsTracker[kUploadProgressImage];
            }
          });
        }).catchError((error) {
          Toast.show(
              error.message.toString(),
              context,
              backgroundColor:HexColor(redColor)
          );
        });
      }).then((value) {

      }).catchError((error) {
        Toast.show(
            error.message.toString(),
            context,
            backgroundColor:HexColor(redColor)
        );
      });
    });

    // TODO: implement initState
    super.initState();
  }

  Future<void> updateGoalDescription() async {
    showLoading(context);

    var dictWeeklyGoalsTracker = {
      kWeight:textWeight.text,
      kWaist:textWaist.text,
      kHips:textHips.text,
      kChest:textChest.text,
      kThigh:textThigh.text,
      kWhatIsYour_Health_Fitness_Goal_Next_Week:textWhatIsYour_Health_FitnessGoal_NextWeek.text,
      kWhatIsYour_Work_Personal_Life_Goal_Next_Week:textWhatIsYour_Work_PersonalLife_Goal_NextWeek.text,
      kDidYouAchieveYour_Health_FitnessGoal_Next_Week:isDidYouAchieveYour_Health_FitnessGoal,
      kDidYouAchieveYour_Work_PersonalGoal_Next_Week:isDidYouAchieveYour_Work_PersonalGoal,
      kUploadProgressImage:((_image == null) && (strImage.isEmpty)) ? '' : strImage
    };

    print(dictWeeklyGoalsTracker);

    FirebaseAuth.instance.currentUser().then((value) async {
      Firestore.instance.collection(tblGoals).document(value.email+kFireBaseConnect+value.uid).collection(formattedDate).document(formattedDate)
          .updateData({
        kWeeklyGoalsTracker:dictWeeklyGoalsTracker
      }).then((value) {
        dismissLoading(context);
        Toast.show(
            'Weekly Goals are updated.',
            context,
            backgroundColor: HexColor(greenColor)
        );
      }).catchError((error) {
        Toast.show(
            error.message.toString(), context,
            backgroundColor: HexColor(redColor));
      });
    }).catchError((error) {
      Toast.show(
          error.message.toString(), context,
          backgroundColor: HexColor(redColor));
    });
  }

  Future openCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
      _uploadFile();
    });
  }
  Future openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      _uploadFile();
    });
  }

  _settingModalBottomSheet(context,) {
    showModalBottomSheet(
        backgroundColor:Colors.transparent,
        context: context,
        builder:(BuildContext bc) {
          return Container(
              height:280,
              decoration:BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.only(
                    topRight:Radius.circular(20),
                    topLeft:Radius.circular(20)
                ),
//              border: Border.all(width:3,color: Colors.green,style: BorderStyle.solid)
              ),
              child:Center(
                child:Column(
                  children:<Widget>[
                    SizedBox(height:30),
                    Text(
                      'Please select an option',
                      style:TextStyle(
                          fontSize:18,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.bold
                      ),
                    ),
                    SizedBox(height:10),
                    FlatButton(
                      child:Text(
                        'Camera',
                        style:TextStyle(
                            fontSize:16,
                            fontFamily:AppConstant.kPoppins,
                            color:AppConstant.color_blue_dark,
                            fontWeight:FontWeight.normal
                        ),
                      ),
                      onPressed:() {
                        Navigator.pop(context);
                        openCamera();
                      },
                    ),
                    FlatButton(
                      child:Text(
                        'Gallery',
                        style:TextStyle(
                            fontSize:16,
                            fontFamily:AppConstant.kPoppins,
                            color:AppConstant.color_blue_dark,
                            fontWeight:FontWeight.normal
                        ),
                      ),
                      onPressed:() {
                        Navigator.pop(context);
                        openGallery();
                      },
                    ),
                    SizedBox(height:30,),
                    FlatButton(
                      child:Text(
                        'Cancel',
                        style:TextStyle(
                            fontSize:18,
                            fontFamily:AppConstant.kPoppins,
                            color:Colors.red,
                            fontWeight:FontWeight.normal
                        ),
                      ),
                      onPressed:() {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              )
          );
        }
    );
  }

  imagePreview(context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds:300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child:Container(
            height:MediaQuery.of(context).size.height-240,
            width:MediaQuery.of(context).size.width-60,
            decoration:BoxDecoration(
              borderRadius:BorderRadius.circular(6),
            ),
              child:_image == null
                  ? ClipRRect(
                borderRadius:BorderRadius.circular(6),
                child:FadeInImage(
                  fit:BoxFit.cover,
                  image:NetworkImage(strImage),
                  placeholder:AssetImage(Res.add_Image),
                ),
              )
                  : Container(
                  height:46,
                  width:56,
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(6),
                  ),
                  child:ClipRRect(
                    borderRadius:BorderRadius.circular(6),
                    child:Image.file(
                        _image,
                        fit:BoxFit.cover
                    ),
                  )
              )
          )
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }



  Future<void> _uploadFile() async {
    showLoading(context);
    FirebaseAuth.instance.currentUser().then((value) async {
      var ref = FirebaseStorage.instance.ref().child(kWeeklyGoalPhoto).child(value.email+kFireBaseConnect+value.uid);
      var uploadTask = ref.putFile(_image);
      var storageTaskSnapshot = await uploadTask.onComplete;
      var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      strImage = downloadUrl;
      dismissLoading(context);

      updateGoalDescription();

    }).catchError((error) {
      Toast.show(
          error.message.toString(), context,
          backgroundColor: HexColor(redColor));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.white,
        appBar:AppBar(
            title:Text(
              'Weekly Progress Tracker',
              style:TextStyle(
                  fontSize:20,
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
            elevation:0.7,
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
            padding:EdgeInsets.only(left:20,right:20),
//            physics:BouncingScrollPhysics(),
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height:30,),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Weight',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    Container(
                        width:170,
                        height:44,
                        padding:EdgeInsets.all(0),
                        child:TextField(
                          controller:textWeight,
                          textAlign:TextAlign.right,
                          keyboardAppearance:Brightness.light,
                          style:TextStyle(
                              fontSize:14,
                              fontFamily:AppConstant.kPoppins,
                              color:AppConstant.color_blue_dark,
                              fontWeight:FontWeight.w400
                          ),
                          decoration: InputDecoration(
                            hintText:'Kg/lbs',
                            contentPadding:EdgeInsets.only(left:16,right:16),
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(10),
                            ),
                            focusedBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                            disabledBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                          ),
                        )
                    )
                  ],
                ),
                SizedBox(height:20),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Waist',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    Container(
                        width:170,
                        height:44,
                        padding:EdgeInsets.all(0),
                        child:TextField(
                          controller:textWaist,
                          textAlign:TextAlign.right,
                          keyboardAppearance:Brightness.light,
                          style:TextStyle(
                              fontSize:14,
                              fontFamily:AppConstant.kPoppins,
                              color:AppConstant.color_blue_dark,
                              fontWeight:FontWeight.w400
                          ),
                          decoration: InputDecoration(
                            hintText: 'cm/inches',
                            contentPadding:EdgeInsets.only(left:16,right:16),
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(10),
                            ),
                            focusedBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                            disabledBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                          ),
                        )
                    )
                  ],
                ),

                SizedBox(height:20),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Hips',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    Container(
                        width:170,
                        height:44,
                        padding:EdgeInsets.all(0),
                        child:TextField(
                          controller:textHips,
                          textAlign:TextAlign.right,
                          keyboardAppearance:Brightness.light,
                          style:TextStyle(
                              fontSize:14,
                              fontFamily:AppConstant.kPoppins,
                              color:AppConstant.color_blue_dark,
                              fontWeight:FontWeight.w400
                          ),
                          decoration: InputDecoration(
                            hintText: 'cm/inches',
                            contentPadding:EdgeInsets.only(left:16,right:16),
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(10),
                            ),
                            focusedBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                            disabledBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                          ),
                        )
                    )
                  ],
                ),

                SizedBox(height:20),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Chest',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    Container(
                        width:170,
                        height:44,
                        padding:EdgeInsets.all(0),
                        child:TextField(
                          controller:textChest,
                          textAlign:TextAlign.right,
                          keyboardAppearance:Brightness.light,
                          style:TextStyle(
                              fontSize:14,
                              fontFamily:AppConstant.kPoppins,
                              color:AppConstant.color_blue_dark,
                              fontWeight:FontWeight.w400
                          ),
                          decoration: InputDecoration(
                            hintText: 'cm/inches',
                            contentPadding:EdgeInsets.only(left:16,right:16),
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(10),
                            ),
                            focusedBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                            disabledBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                          ),
                        )
                    )
                  ],
                ),

                SizedBox(height:20),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Thigh',
                      style:TextStyle(
                          fontSize:16,
                          fontFamily:AppConstant.kPoppins,
                          color:AppConstant.color_blue_dark,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                    Container(
                        width:170,
                        height:44,
                        padding:EdgeInsets.all(0),
                        child:TextField(
                          controller:textThigh,
                          textAlign:TextAlign.right,
                          keyboardAppearance:Brightness.light,
                          style:TextStyle(
                              fontSize:14,
                              fontFamily:AppConstant.kPoppins,
                              color:AppConstant.color_blue_dark,
                              fontWeight:FontWeight.w400
                          ),
                          decoration: InputDecoration(
                            hintText: 'cm/inches',
                            contentPadding:EdgeInsets.only(left:16,right:16),
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(10),
                            ),
                            focusedBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                            disabledBorder:OutlineInputBorder(
                                borderRadius:BorderRadius.circular(10),
                                borderSide:BorderSide(color:HexColor('#CECECE'))
                            ),
                          ),
                        )
                    )
                  ],
                ),
                SizedBox(height:30,),
                FlatButton(
                  padding:EdgeInsets.all(0),
                  textColor:Colors.white,
                  child:Row(
                    mainAxisAlignment:MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height:46,
                        width:56,
                          child:ClipRRect(
                              borderRadius:BorderRadius.circular(5),
                              child:_image == null
                                  ? FadeInImage(
                                fit:BoxFit.fill,
                                image:NetworkImage(strImage),
                                placeholder:AssetImage(Res.add_Image),
                              ) : Container(
                                  height:46,
                                  width:56,
                                  child:Image.file(
                                      _image,
                                      fit:BoxFit.fill
                                  )
                              )
                          ),
                      ),
                      SizedBox(width:20),
                      Column(
                        mainAxisAlignment:MainAxisAlignment.start,
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload Progress Image',
                            style:TextStyle(
                                fontSize:16,
                                fontFamily:AppConstant.kPoppins,
                                color:AppConstant.color_blue_dark,
                                fontWeight:FontWeight.w600
                            ),
                          ),
                          Visibility(
                            visible:((_image == null) && (strImage.isEmpty)) ? false : true,
                            child:Text(
                              'Long press for full image preview..',
                              style:TextStyle(
                                  fontSize:10,
                                  fontFamily:AppConstant.kPoppins,
                                  color:Colors.grey,
                                  fontWeight:FontWeight.normal
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  onLongPress:() {
                    imagePreview(context);
                  },
                  onPressed:() {
                    _settingModalBottomSheet(context);
                  },
                ),
                SizedBox(height:30,),
                Text(
                  'Did You Achieve Your Health And Fitness Goal this Week?',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:20),
                Row(
                  children: <Widget>[
                    FlatButton(
                      padding:EdgeInsets.only(left: 0),
                      textColor:Colors.white,
                      child:Row(
                        children: <Widget>[
                          Image.asset(
                            isDidYouAchieveYour_Health_FitnessGoal ? Res.selectedGoalsDetails : Res.unselectedGoalDetails,
                            height:24,
                          ),
                          SizedBox(width:16),
                          Text(
                            'Yes',
                            style:TextStyle(
                                color:HexColor('54C9AF'),
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16
                            ),
                          )
                        ],
                      ),
                      onPressed:(){
                        setState(() {
                          isDidYouAchieveYour_Health_FitnessGoal = !isDidYouAchieveYour_Health_FitnessGoal;
                        });
                      },
                    ),
                    SizedBox(width:50,),
                    FlatButton(
                      textColor:Colors.white,
                      child:Row(
                        children: <Widget>[
                          Image.asset(
                            !isDidYouAchieveYour_Health_FitnessGoal ? Res.selectedGoalsDetails : Res.unselectedGoalDetails,
                            height:24,
                          ),
                          SizedBox(width:16),
                          Text(
                            'No',
                            style:TextStyle(
                                color:HexColor('#54C9AF'),
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16
                            ),
                          )
                        ],
                      ),
                      onPressed:(){
                        setState(() {
                          isDidYouAchieveYour_Health_FitnessGoal = !isDidYouAchieveYour_Health_FitnessGoal;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height:30,),
                Text(
                  'Did You Achieve Your Work/ Personal Life Goal this Week?',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:20),
                Row(
                  children: <Widget>[
                    FlatButton(
                      padding:EdgeInsets.only(left: 0),
                      textColor:Colors.white,
                      child:Row(
                        children: <Widget>[
                          Image.asset(
                            isDidYouAchieveYour_Work_PersonalGoal ? Res.selectedGoalsDetails : Res.unselectedGoalDetails,
                            height:24,
                          ),
                          SizedBox(width:16),
                          Text(
                            'Yes',
                            style:TextStyle(
                                color:HexColor('54C9AF'),
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16
                            ),
                          )
                        ],
                      ),
                      onPressed:(){
                        setState(() {
                          isDidYouAchieveYour_Work_PersonalGoal = !isDidYouAchieveYour_Work_PersonalGoal;
                        });
                      },
                    ),
                    SizedBox(width:50,),
                    FlatButton(
                      textColor:Colors.white,
                      child:Row(
                        children: <Widget>[
                          Image.asset(
                            !isDidYouAchieveYour_Work_PersonalGoal ? Res.selectedGoalsDetails : Res.unselectedGoalDetails,
                            height:24,
                          ),
                          SizedBox(width:16),
                          Text(
                            'No',
                            style:TextStyle(
                                color:HexColor('#54C9AF'),
                                fontFamily:AppConstant.kPoppins,
                                fontWeight:FontWeight.normal,
                                fontSize:16
                            ),
                          )
                        ],
                      ),
                      onPressed:(){
                        setState(() {
                          isDidYouAchieveYour_Work_PersonalGoal = !isDidYouAchieveYour_Work_PersonalGoal;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height:30,),
                Text(
                  'What Is Your Health And Fitness Goal Next Week?',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:20),
                TextFormField(
                  controller:textWhatIsYour_Health_FitnessGoal_NextWeek,
                  textAlign: TextAlign.left,
                  keyboardAppearance:Brightness.light,
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w400
                  ),
                  decoration: InputDecoration(
                    hintText: '',
                    contentPadding:EdgeInsets.only(left:16,right:16),
                    border:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(10),
                    ),
                    focusedBorder:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10),
                        borderSide:BorderSide(color:HexColor('#CECECE'))
                    ),
                    disabledBorder:OutlineInputBorder(
                        borderRadius:BorderRadius.circular(10),
                        borderSide:BorderSide(color:HexColor('#CECECE'))
                    ),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Text is empty';
                    }
                    return null;
                  },
                ),

                SizedBox(height:30,),
                Text(
                  'What Is Your Work/ Personal Life \nGoal Next Week?',
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w600
                  ),
                ),
                SizedBox(height:20),
                TextFormField(
                  controller:textWhatIsYour_Work_PersonalLife_Goal_NextWeek,
                  textAlign: TextAlign.left,
                  keyboardAppearance:Brightness.light,
                  style:TextStyle(
                      fontSize:16,
                      fontFamily:AppConstant.kPoppins,
                      color:AppConstant.color_blue_dark,
                      fontWeight:FontWeight.w400
                  ),
                  decoration: InputDecoration(
                    hintText: '',
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
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Text is empty';
                    }
                    return null;
                  },
                ),

                SizedBox(height:50),
                FlatButton(
                  textColor:Colors.white,
                  child:Container(
                    height:54,
                    width:double.infinity,
                    margin:EdgeInsets.only(left:10,right:10),
//                    padding:EdgeInsets.only(left:20,right:20),
                    decoration:kButtonThemeGradientColor(),
                    alignment:Alignment.center,
                    child:Text(
                      'Submit',
                      style:TextStyle(
                          fontSize:18,
                          fontFamily:AppConstant.kPoppins,
                          color:Colors.white,
                          fontWeight:FontWeight.normal
                      ),
                    ),
                  ),
                  onPressed:() {
                    updateGoalDescription();
                  },
                ),
                SizedBox(height:30+MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
    );
  }
}


