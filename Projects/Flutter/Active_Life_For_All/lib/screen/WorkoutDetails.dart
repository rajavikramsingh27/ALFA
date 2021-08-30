import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alfa/utils/Constents.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';


String kVideoURL = '';


class WorkoutDetails extends StatefulWidget {

  @override
  _WorkoutDetailsState createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  int duration = 901;

  bool isPlay = false;
  bool isMoreVideos = false;
  bool isPrevious = false;
  bool isNext = false;
  bool isLandscape = true;

  int forNextPrevious = 0;
  var arrString = List<String>();

  String videoId;
  YoutubePlayerController _controller;




  @override
  void initState() {
    // TODO: implement initState

    print(kVideoURL);
    arrString = kVideoURL
        .split('~~')                       // split the text into an array
        .map((text) => (text)) // put the text inside a widget
        .toList();
     print(arrString);

     if (arrString.length > 1) {
       isMoreVideos = true;
       isPrevious = false;
       isNext = true;
     } else {
       isMoreVideos = false;
       isPrevious = false;
       isNext = false;
     }

    youTubePlayer(arrString[0]);

    super.initState();
  }



  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  youTubePlayer(String videoURL) {
    _controller = YoutubePlayerController(
      initialVideoId:YoutubePlayer.convertUrlToId(videoURL),
      flags: YoutubePlayerFlags(
        autoPlay: true,
//        mute: true,
      ),
    );
  }

  funcForNextPrevious() {

    if (forNextPrevious > 0) {
      isPrevious = true;
    } else {
      isPrevious = false;
    }

    if (forNextPrevious == arrString.length-1) {
      isNext = false;
    } else {
      isNext = true;
    }

    _controller.load( YoutubePlayer.convertUrlToId(arrString[forNextPrevious]),startAt:0);
    _controller.play();

    setState(() {

    });

  }

  youtubeHierarchy() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fill,
          child: YoutubePlayer(
            controller: _controller,
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: OrientationBuilder(builder:
          (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Scaffold(
            body:youtubeHierarchy(),
          );
        } else {
          return Scaffold(
            appBar:AppBar(
                title:Text(
                  '',
//            'Upper Body Workouts',
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
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                    })
            ),
            body:youtubeHierarchy(),
          );
        }
      }),
    );
  }

}





