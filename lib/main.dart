import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer';


void main() {
  runApp(
      new MaterialApp(
        home: View1(),
      )
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: View1()
//       );
//
//   }
// }




class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * 3.1415926535897932;
    canvas.drawArc(Offset.zero & size, 3.1415926535897932 * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

class View1 extends StatefulWidget {
  const View1({Key? key}) : super(key: key);

  @override
  State<View1> createState() => _View1State();
}

class _View1State extends State<View1> with TickerProviderStateMixin {
  late AnimationController controller;
  final player = AudioPlayer();
  int stage = 0;



  playAudio() async {

     await player.play(AssetSource("audio/countdown_tick.mp3"));
    // if (result == 1) {
    //   // success
    //   print('Audio played successfully');
    // } else {
    //   print('Error playing audio');
    // }
  }



  String get timerString {
    Duration duration = controller.duration! * controller.value;

    if(duration.inSeconds  <= 5){
      playAudio();
    }
    
    if(duration.inSeconds == 2) {
      Future.delayed(Duration(seconds: 4), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const View2()),
        );
      });
    }


    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    stage=0;
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF1B1626),
      appBar :AppBar(
          backgroundColor: const Color(0xFF1B1626),
          title: Text('Mindful Meal Timer')
      ),
      body:
      AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[

                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     color: Colors.amber,
                //     height:
                //     controller.value * MediaQuery.of(context).size.height,
                //   ),
                // ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 160.0 , top: 20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: ShapeDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: OvalBorder(),
                            ),
                          ),
                          SizedBox(width: 2.0,),
                          Container(
                            width: 15,
                            height: 15,
                            decoration: ShapeDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: OvalBorder(),
                            ),
                          ),
                          SizedBox(width: 2.0,),
                          Container(
                            width: 15,
                            height: 15,
                            decoration: ShapeDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: OvalBorder(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left:110.0 , top: 25.0)
                      ,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Text("Nom Nom :)",style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white),
                              ),

                            ],),

                        ],
                      ),),
                    SizedBox(height: 20.0),
                    Padding(padding: EdgeInsets.only(left: 12.0) ,child: Row(children: [
                      Text("You have 10 minutes before the pause,focus on eating slowly ",style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white),
                      ),
                    ],),)
                  ],
                ),


                Padding(

                  padding: EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[


                      SizedBox(
                        height: 120.0,
                      ),
                      Container(
                        decoration :BoxDecoration(
                            shape: BoxShape.circle, // Set the shape to circle
                            border: Border.all(
                              color: const Color(0xFFA09FA4), // Set the border color
                              width: 50.0, // Set the border width
                            )
                        ),
                        child: Expanded(
                          child: Align(
                            alignment: FractionalOffset.center,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CustomPaint(
                                        painter: CustomTimerPainter(
                                          animation: controller,
                                          backgroundColor: Colors.white,
                                          color: Colors.green,
                                        )),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          timerString,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "minutes remaining",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),

                      GestureDetector(
                        onTap: () {
                          if (controller.isAnimating)
                            controller.stop();
                          else {
                            controller.reverse(
                                from: controller.value == 0.0
                                    ? 1.0
                                    : controller.value);
                          }
                        } ,
                        child:  Container(

                          child: Center(
                            child: Text(
                              controller.isAnimating ? "PAUSE" : "START",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          width: 298,
                          height: 76,
                          decoration: ShapeDecoration(
                            color: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                          ),
                        ),
                      ),


                      SizedBox(height: 15.0,),
                      controller.isAnimating ?
                      GestureDetector(
                        onTap: () {
                          if (controller.isAnimating)
                            controller.stop();
                          else {
                            controller.reverse(
                                from: controller.value == 0.0
                                    ? 1.0
                                    : controller.value);
                          }
                        } ,
                        child:  Container(

                          child: Center(
                            child: Text(
                              "LET'S STOP I'M FULL NOW",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          width: 298,
                          height: 76,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, //                   <--- border color
                              width: 1.0,
                            ),
                            color: const Color(0xFF1B1626),

                          ),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class View2 extends StatefulWidget {
  const View2({Key? key}) : super(key: key);

  @override
  State<View2> createState() => _View2State();
}

class _View2State extends State<View2> with TickerProviderStateMixin {
  late AnimationController controller;
  final player = AudioPlayer();



  playAudio() async {

    await player.play(AssetSource("audio/countdown_tick.mp3"));
    // if (result == 1) {
    //   // success
    //   print('Audio played successfully');
    // } else {
    //   print('Error playing audio');
    // }
  }



  String get timerString {
    Duration duration = controller.duration! * controller.value;

    if(duration.inSeconds  <= 5){
      playAudio();
    }

    if(duration.inSeconds == 2) {
      Future.delayed(Duration(seconds: 4), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => View3()),
        );
      });
    }

    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1B1626),
        appBar :AppBar(
            backgroundColor: const Color(0xFF1B1626),
            title: Text('Mindful Meal Timer')
        ),
        body:
        AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Stack(
                children: <Widget>[

                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Container(
                  //     color: Colors.amber,
                  //     height:
                  //     controller.value * MediaQuery.of(context).size.height,
                  //   ),
                  // ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 160.0 , top: 20.0),
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: OvalBorder(),
                              ),
                            ),
                            SizedBox(width: 2.0,),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: OvalBorder(),
                              ),
                            ),
                            SizedBox(width: 2.0,),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: OvalBorder(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left:90.0 , top: 25.0)
                        ,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Text("Break Time",style: TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white),
                                ),
                              ],),

                          ],
                        ),),
                      SizedBox(height: 20.0),
                      Padding(padding: EdgeInsets.only(left: 12.0) ,child: Row(children: [
                        Text("Take 5 minutes break to check in on your fullness ",style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white),
                        ),
                      ],),)
                    ],
                  ),


                  Padding(

                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[


                        SizedBox(
                          height: 120.0,
                        ),
                        Container(
                          decoration :BoxDecoration(
                              shape: BoxShape.circle, // Set the shape to circle
                              border: Border.all(
                                color: const Color(0xFFA09FA4), // Set the border color
                                width: 50.0, // Set the border width
                              )
                          ),
                          child: Expanded(
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: CustomPaint(
                                          painter: CustomTimerPainter(
                                            animation: controller,
                                            backgroundColor: Colors.white,
                                            color: Colors.green,
                                          )),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            timerString,
                                            style: TextStyle(
                                                fontSize: 50.0,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "minutes remaining",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),

                        GestureDetector(
                          onTap: () {
                            if (controller.isAnimating)
                              controller.stop();
                            else {
                              controller.reverse(
                                  from: controller.value == 0.0
                                      ? 1.0
                                      : controller.value);
                            }
                          } ,
                          child:  Container(

                            child: Center(
                              child: Text(
                                controller.isAnimating ? "PAUSE" : "START",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            width: 298,
                            height: 76,
                            decoration: ShapeDecoration(
                              color: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19),
                              ),
                            ),
                          ),
                        ),


                        SizedBox(height: 15.0,),
                        controller.isAnimating ?
                        GestureDetector(
                          onTap: () {
                            if (controller.isAnimating)
                              controller.stop();
                            else {
                              controller.reverse(
                                  from: controller.value == 0.0
                                      ? 1.0
                                      : controller.value);
                            }
                          } ,
                          child:  Container(

                            child: Center(
                              child: Text(
                                "LET'S STOP I'M FULL NOW",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            width: 298,
                            height: 76,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white, //                   <--- border color
                                width: 1.0,
                              ),
                              color: const Color(0xFF1B1626),

                            ),
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}



class View3 extends StatefulWidget {
  const View3({Key? key}) : super(key: key);

  @override
  State<View3> createState() => _View3State();
}

class _View3State extends State<View3> with TickerProviderStateMixin {
  late AnimationController controller;
  final player = AudioPlayer();



  playAudio() async {

    await player.play(AssetSource("audio/countdown_tick.mp3"));
    // if (result == 1) {
    //   // success
    //   print('Audio played successfully');
    // } else {
    //   print('Error playing audio');
    // }
  }



  String get timerString {
    Duration duration = controller.duration! * controller.value;

    if(duration.inSeconds  <= 5){
      playAudio();
    }

    if(duration.inSeconds == 2) {
      Future.delayed(Duration(seconds: 4), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => View1()),
        );
      });
    }

    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1B1626),
        appBar :AppBar(
            backgroundColor: const Color(0xFF1B1626),
            title: Text('Mindful Meal Timer')
        ),
        body:
        AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Stack(
                children: <Widget>[

                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Container(
                  //     color: Colors.amber,
                  //     height:
                  //     controller.value * MediaQuery.of(context).size.height,
                  //   ),
                  // ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 160.0 , top: 20.0),
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: OvalBorder(),
                              ),
                            ),
                            SizedBox(width: 2.0,),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: OvalBorder(),
                              ),
                            ),
                            SizedBox(width: 2.0,),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: OvalBorder(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left:90.0 , top: 25.0)
                        ,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Text("Meal Time",style: TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white),
                                ),
                              ],),

                          ],
                        ),),
                      SizedBox(height: 20.0),
                      Padding(padding: EdgeInsets.only(left: 12.0) ,child: Row(children: [
                        Text("You can eat until you feel full ",style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white),
                        ),
                      ],),)
                    ],
                  ),


                  Padding(

                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[


                        SizedBox(
                          height: 120.0,
                        ),
                        Container(
                          decoration :BoxDecoration(
                              shape: BoxShape.circle, // Set the shape to circle
                              border: Border.all(
                                color: const Color(0xFFA09FA4), // Set the border color
                                width: 50.0, // Set the border width
                              )
                          ),
                          child: Expanded(
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: CustomPaint(
                                          painter: CustomTimerPainter(
                                            animation: controller,
                                            backgroundColor: Colors.white,
                                            color: Colors.green,
                                          )),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            timerString,
                                            style: TextStyle(
                                                fontSize: 50.0,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            "minutes remaining",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),

                        GestureDetector(
                          onTap: () {
                            if (controller.isAnimating)
                              controller.stop();
                            else {
                              controller.reverse(
                                  from: controller.value == 0.0
                                      ? 1.0
                                      : controller.value);
                            }
                          } ,
                          child:  Container(

                            child: Center(
                              child: Text(
                                controller.isAnimating ? "PAUSE" : "START",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            width: 298,
                            height: 76,
                            decoration: ShapeDecoration(
                              color: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19),
                              ),
                            ),
                          ),
                        ),


                        SizedBox(height: 15.0,),
                        controller.isAnimating ?
                        GestureDetector(
                          onTap: () {
                            if (controller.isAnimating)
                              controller.stop();
                            else {
                              controller.reverse(
                                  from: controller.value == 0.0
                                      ? 1.0
                                      : controller.value);
                            }
                          } ,
                          child:  Container(

                            child: Center(
                              child: Text(
                                "LET'S STOP I'M FULL NOW",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            width: 298,
                            height: 76,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white, //                   <--- border color
                                width: 1.0,
                              ),
                              color: const Color(0xFF1B1626),
                              // shape: RoundedRectangleBorder(
                              //
                              //   borderRadius: BorderRadius.circular(19),
                              // ),
                            ),
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}