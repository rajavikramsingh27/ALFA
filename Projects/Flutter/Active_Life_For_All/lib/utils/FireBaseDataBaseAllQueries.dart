import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class FireBaseDataBaseAllQueries extends StatefulWidget {
  @override
  _FireBaseDataBaseAllQueriesState createState() => _FireBaseDataBaseAllQueriesState();
}

class _FireBaseDataBaseAllQueriesState extends State<FireBaseDataBaseAllQueries> {
//  Always make gloabl Instance Variable
  final fireStore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SignUp
  createUserWithEmailAndPassword_FireBase() async {
    await _auth.createUserWithEmailAndPassword(
        email:'raja@gmail.com',
        password:'123456'
    ).catchError((error) {
      print(error.toString());
    }).then((value) {
      value.user.uid;
//      can set datahere
    });
  }

// LogIn
  signInWithEmailAndPassword_FireBase() async {
    await _auth.signInWithEmailAndPassword(
        email:'raja@gmail.com',
        password:'123456'
    ).catchError((error) {
      print(error.toString());
    }).then((value) async {
//      value.user.uid;
//      value.user.isEmailVerified;
      try {
        await value.user.sendEmailVerification();
      } catch (e) {
        print("An error occured while trying to send email verification");
        print(e.message);
      }
//      can set datahere
    });
  }

  signOut_FireBase() async {
    await _auth.signOut().then((value) {
//        show login screen
    });
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

//  GetCurrentUser
//  if face any issue about the update UI then please async/await
  currentUser_FireBase() {
    _auth.currentUser().then((value) {
      value.uid;
    }).catchError((error) {
      print(error.toString());
    });
  }

//  get like array, this will get data like a get api
  getDocuments_FireBaseFireStore() async {
    QuerySnapshot querySnapshot = await fireStore.collection('services').getDocuments();
    List<Map<String, dynamic>> arrServiceList = querySnapshot.documents.map((DocumentSnapshot doc) {
      return doc.data;
    }).toList();
    print(arrServiceList);
  }

//  setData/ add data into the DataBase
//  for document ID alwys use the currentUser.uid because
//  if we take dynamically then it will create always new id in the database
//  and we are suffering to get/ update /delete data into the firebase
//  if face any issue about the update UI then please async/await


//  getData
//  if face any issue about the update UI then please async/await
  getData_FireBaseFireStore() {
    _auth.currentUser().then((currentUser) {
      fireStore.collection('users').document(currentUser.uid).get().then((value) {
        print(value.data);
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  Future<String> getImage_FirebaseStorage(String icon) async {
    final ref = FirebaseStorage.instance.ref().child(icon);
    var url = await ref.getDownloadURL();

    return url.toString();
  }

  setDataFireBase_FireStore() {
    _auth.currentUser().then((currentUser){
      currentUser.uid;
      fireStore.collection('users').document(currentUser.uid).setData(
          {
            'userID':currentUser.uid,
            'namesss':'1234561234567876543',
            'password':'qwerty'
          }
      ).catchError((error) {
        print(error.toString());
      });
    });
  }

  //  getData
//  if face any issue about the update UI then please async/await
  updateData_FireBaseFireStore() {
    _auth.currentUser().then((currentUser) {
      fireStore.collection('users').document(currentUser.uid).updateData({
            'name':''
          }).catchError((error) {
        print(error.toString());
      });
    });
  }

//    getData
//  if face any issue about the update UI then please async/await
  deleteData_FireBaseFireStore() {
    _auth.currentUser().then((currentUser) {
      fireStore.collection('users').document(currentUser.uid).delete();
    });
  }

  Future<void> _uploadFile() async {
    File _image;
    var ref = FirebaseStorage.instance.ref().child('userProfilePicture/').child('1');
    var uploadTask = ref.putFile(_image);
    var storageTaskSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  }

  static Future<bool> sendFcmMessage(String title, String message) async {
    final String serverkey = 'AAAA2qI7Pq4:APA91bGxse8Whupb5vs0wYInlw-dXHLRODQs4MyXZb0DVYssacZpJH-lRHr-Fc6S2kvgIuWW3Ii30YH47ErKn4UrHORaUWxYUh2z-tXVsO23JCD0tNmUJdHz280JsyJPIR1toPC0d-U6';
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverkey',
        },
        body:jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': 'this is a body',
                'title': 'this is a title'
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              'to':'/topics/all'
//              'c-nNczck6X0:APA91bFQR4GFW-LPq6ul0k8VHkGUXo8EtLFmutVnux1v5qRwnbp_f_HW6XJQlY841hA0oFkvzdWv0-oXVgLFIjN2Nl_ePw0r28s60kdeATjf5YZAItXL4ybgbtFjLFPRmkE2FeS8WGw3',
            })
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}





