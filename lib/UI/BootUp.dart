import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_distribution/BackEnd/Firebase.dart';
import 'WarriorDashboard.dart';

import 'LoginScreen.dart';

class BootUp extends StatefulWidget {
  @override
  _BootUpState createState() => _BootUpState();
}

class _BootUpState extends State<BootUp> with SingleTickerProviderStateMixin {
  AnimationController colorAnimCtrl;
  Animation colorAnim;
  double ht, wd, conHt, notificationBarHeight;


  void initFirebase() async {

    try {
      await Firebase.initializeApp().then((value) {

        FirebaseCustoms.logOut();
        Timer(Duration(seconds: 1), () {
          colorAnimCtrl.forward().then((value) async {
            setState(() {
              conHt = ht * 0.15;
            });
            Timer(Duration(milliseconds: 500), (){
              User currentUser = FirebaseCustoms.initAuth();
              if(currentUser == null)
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              else
                print('DashBoard');
              //  ToDo: Navigate to DashBoard.
            });
          });
        });
      });
    } catch (error) {
      print(error);
    }
  }
  @override
  void didChangeDependencies() {
    Size size = MediaQuery.of(context).size;
    ht = size.height;
    conHt = ht * 0.85;
    wd = size.width;
    notificationBarHeight = MediaQuery.of(context).padding.top;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    colorAnimCtrl = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    colorAnim = ColorTween(begin: Colors.black, end: Colors.white)
        .animate(CurvedAnimation(
      parent: colorAnimCtrl,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeIn,
    ))
          ..addListener(() {
            setState(() {});
          });

    initFirebase();

    super.initState();
  }

  @override
  void dispose() {
    colorAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAnim.value,
      body: Stack(
        children: [
          Positioned(
            top: ht * 0.125,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutSine,
              height: conHt,
              width: wd,
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: "Agus",
                      fontSize: wd * 0.15,
                      color: Colors.lightBlueAccent,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: "Warr"),
                      TextSpan(
                        text: "10",
                        style: TextStyle(color: Colors.deepOrangeAccent),
                      ),
                      TextSpan(text: "R"),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
