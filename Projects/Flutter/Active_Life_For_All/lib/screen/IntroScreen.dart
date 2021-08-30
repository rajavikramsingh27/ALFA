import 'package:alfa/res.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:toast/toast.dart';
import 'dart:io' show Platform;




Map<String, dynamic> dictSocialProfile = {'picture':'','first_name':'','last_name':''};

class IntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String your_client_id = "299358884622796";
  String your_redirect_url = "https://www.facebook.com/connect/login_success.html";

  @override
  void initState() {
    Future.delayed(Duration(milliseconds:1),() {
      FirebaseAuth.instance.currentUser().then((value) {
        Firestore.instance.collection(tblUserDetails).document(value.email+kFireBaseConnect+value.uid).updateData({
          kDeviceToken:deviceToken
        }).catchError((error) {
          print(error.message.toString());
        }).then((value) {
          Navigator.pushNamed(context, '/TabbarScreen');
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }


   signInWithGoogle() async {
//    showLoading(context);
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

//    dismissLoading(context);

    showLoading(context);
    await _auth.signInWithCredential(credential).then((value) {
      dismissLoading(context);
      String userName = value.user.displayName;
      var arrNames = value.user.displayName.split(" ");
//      print(dictSocialProfile);
      dictSocialProfile['picture'] = value.user.photoUrl;
      dictSocialProfile['first_name'] = arrNames.first;
      dictSocialProfile['last_name'] = arrNames.last;
//      print(dictSocialProfile);

      socialLogin(value.user,'G-Mail');
    }).catchError((error) {
      dismissLoading(context);
      Toast.show(
          error.message.toString(),
          context,
          backgroundColor:HexColor(redColor)
      );
    });

//    final FirebaseUser user = authResult.user;
//    print(user.displayName);
//    print(user.photoUrl);
  }

  socialLogin(FirebaseUser user,String socialType) {
    showLoading(context);
   var pathUser = Firestore.instance.collection(tblUserDetails).document(user.email+kFireBaseConnect+user.uid).get().then((value) {
     dismissLoading(context);

     print(value.data);
     if (value.data != null) {
       showLoading(context);

       Firestore.instance.collection(tblUserDetails).document(user.email+kFireBaseConnect+user.uid).updateData({
         kDeviceToken:deviceToken,
         kDeviceType: Platform.isIOS ? 'iOS' : 'Android',
       }).then((value) {
         dismissLoading(context);
         Navigator.pushNamed(context,'/TabbarScreen');
       }).catchError((error) {
         dismissLoading(context);
         Toast.show(
             error.message.toString(),
             context,
             backgroundColor:HexColor(redColor)
         );
       });
     } else {
       showLoading(context);
       Firestore.instance
           .collection(tblUserDetails)
           .document(user.email+kFireBaseConnect+user.uid)
           .setData({
         kUserID:user.uid,
         kEmail:user.email,
         kPassword:socialType,
         kDeviceType:Platform.isIOS ? 'iOS' : 'Android',
         kDeviceToken:deviceToken,
         kProfilePicture: '',
         kFirstName:'',
         kLastName:'',
         kLocation:'',
         kDateOfBirth:'',
         kGender:'',
         kFitnessGoal: '',
         kActiveDailyLife: '',
       }).then((value) {
         dismissLoading(context);
         Navigator.pushNamed(context, '/profile');
       }).catchError((error) {
         dismissLoading(context);
         Toast.show(
             error.message.toString(), context,
             backgroundColor: HexColor(redColor));
       });
     }
   });
  }

  loginWithFacebook() async {
    final FacebookLogin facebookSignIn = new FacebookLogin();

    String _message = 'Log in/out by pressing the buttons below.';

    final FacebookLoginResult result =
    await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:

        showLoading(context);
        final FacebookAccessToken accessToken = result.accessToken;
        print(accessToken.token);

        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture,gender,birthday&access_token=${accessToken.token}'
        );

        dictSocialProfile = json.decode(graphResponse.body);
//        print(profile);
        Map<String, dynamic> dictPicture = dictSocialProfile['picture'];
        Map<String, dynamic> dictData = dictPicture['data'];
        dictSocialProfile['picture'] = dictData['url'];
        print(dictSocialProfile);
        dismissLoading(context);

        showLoading(context);
        FacebookAccessToken myToken = result.accessToken;
        AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: myToken.token);
        await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          dismissLoading(context);
          socialLogin(value.user,'FaceBook');
        }).catchError((error) {
          dismissLoading(context);
          Toast.show(
              error.message.toString(), context,
              backgroundColor: HexColor(redColor));
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        Toast.show('Login cancelled by the user.', context,
            backgroundColor: HexColor(redColor));
        break;
      case FacebookLoginStatus.error:
        Toast.show('${result.errorMessage}', context,
            backgroundColor: HexColor(redColor));
        break;
    }

  }


  @override
  Widget build(BuildContext context) {
    var sizeScreen = MediaQuery.of(context).size;
    return WillPopScope(child:Scaffold(
      backgroundColor:Colors.white,
      body:StretchyHeader.singleChild(
        headerData:HeaderData(
          headerHeight:400,
          backgroundColor:Colors.white,
          blurColor:Colors.yellow,
          header:Container(
            width:double.infinity,
            height:430,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft:Radius.circular(30),
                    bottomRight:Radius.circular(30))),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32)
              ),
              child: Image.asset(Res.ic_intro, fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        child:Column(
          mainAxisSize:MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              height:42,
              child:Text("Welcome to ALFA",
                style:TextStyle(fontSize:30,
                    fontFamily:AppConstant.kPoppins,
                    fontWeight:FontWeight.bold,
                    color:AppConstant.color_blue_dark),
              ),
            ),
            SizedBox(
              height:0,
            ),
            Text('ACTIVE LIFE FOR ALL',
              style: TextStyle(
                  fontSize:16,
                  fontFamily:AppConstant.kPoppins,
                  color: Color(0xff54C9AF)
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:30),
              width:sizeScreen.width-60,
              height:50,
              decoration:kButtonThemeGradientColor(),
              child:FlatButton(
                  textColor:Colors.white,
                  onPressed:() {
                    Navigator.pushNamed(context, '/login');
                  }, child:Text(
                  'Login',
                  style:TextStyle(
                      fontFamily:AppConstant.kPoppins,
                      color:Colors.white,
                      fontWeight:FontWeight.normal,
                      fontSize:16
                  )
              )
              ),
            ),
            // SizedBox(
            //   height:20,
            // ),
            // Text(
            //     "or Continue with",
            //     style:TextStyle(
            //         fontFamily:AppConstant.kPoppins,
            //         color:Colors.black,
            //         fontWeight:FontWeight.normal,
            //         fontSize:13
            //     )
            // ),
//             SizedBox(
//               height:20,
//             ),
//             Row(
//               mainAxisAlignment:MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 FlatButton(
//                   textColor:Colors.white,
//                   padding:EdgeInsets.all(0),
//                   child:Container(
//                     height:46,
//                     width:(sizeScreen.width-75)/2,
//                     margin:EdgeInsets.only(left:30),
//                     decoration:BoxDecoration(
//                       color:Colors.white,
//                       borderRadius:BorderRadius.circular(15),
//                       border:Border.all(color: Color(0xffC1C1C1)),
//
//                     ),
//                     child:Row(
//                       children: <Widget>[
//                         Container(
//                           height:22,
//                           width:22,
//                           margin:EdgeInsets.only(left:14),
//                           child:Image.asset(Res.ic_google),
//                         ),
//                         Container(
//                           padding:EdgeInsets.only(left:12),
//                           child:Text("Google",
//                               style:TextStyle(
//                                   fontFamily:AppConstant.kPoppins,
//                                   color:Colors.black,
//                                   fontWeight:FontWeight.normal,
//                                   fontSize:14
//                               )
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   onPressed:() {
//                     signInWithGoogle();
//                   },
//                 ),
// //        keytool -exportcert -list -v \ -alias Manisha hothla -keystore %USERPROFILE%\.android\debug.keystore
// //      keytool -list -v -keystore C:\Users\Manisha hothla\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
// //                C:\Program Files\Java\jre6\bin\keytool.exe debug.keystore
//
//
//                 FlatButton(
//                   textColor:Colors.white,
//                   padding:EdgeInsets.all(0),
//                   child:Container(
//                     height:46,
//                     width:(sizeScreen.width-75)/2,
//                     margin:EdgeInsets.only(right:30),
//                     decoration:BoxDecoration(
//                       color:Colors.white,
//                       borderRadius: BorderRadius.circular(15),
//                       border:Border.all(color: Color(0xffC1C1C1)),
//                     ),
//                     child:Row(
//                       children: <Widget>[
//                         Container(
//                           height:22,
//                           width:22,
//                           margin:EdgeInsets.only(left:14),
//                           child:Image.asset(Res.ic_facebook),
//                         ),
//                         Container(
//                           padding:EdgeInsets.only(left:12),
//                           child:Text(
//                             'Facebook',
//                             style:TextStyle(
//                                 fontFamily:AppConstant.kPoppins,
//                                 color:Colors.black,
//                                 fontWeight:FontWeight.normal,
//                                 fontSize:14
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   onPressed:() {
//                     loginWithFacebook();
//                   },
//                 )
//               ],
//             ),
            SizedBox(
              height:40,
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/signUp');
              },
              child:RichText(
                text: TextSpan(
                    text:"New App?  ",
                    style:TextStyle(
                        fontFamily:AppConstant.kPoppins,
                        color:HexColor('#232F45'),
                        fontWeight:FontWeight.normal,
                        fontSize:14
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Sign Up",
                        style:TextStyle(
                            fontFamily:AppConstant.kPoppins,
                            color:HexColor('#232F45'),
                            fontWeight:FontWeight.w600,
                            fontSize:14
                        ),
                      )
                    ]),
              ),
            ),
            SizedBox(
              height:40,
            ),
          ],
        ),
      ),
    ), onWillPop:() {
      return;
    });
  }
}

