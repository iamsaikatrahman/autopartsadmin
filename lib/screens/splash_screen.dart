import 'dart:async';

import 'package:autopartsadmin/screens/login_screen.dart';
import 'package:autopartsadmin/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth =  FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () async {
      if (await auth.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => MainScreen());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => LoginScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //-------------------logo & title-----------------------//
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Color(0xFFF8991D),
                    radius: 65.0,
                    child: Image(
                      image: AssetImage('assets/splash/autoparts.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Auto",
                      style: TextStyle(
                        shadows: [
                          BoxShadow(
                            color: Colors.deepPurple,
                            blurRadius: 2,
                          ),
                        ],
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Parts",
                          style: TextStyle(
                            shadows: [
                              BoxShadow(
                                color: Colors.deepPurple,
                                blurRadius: 2,
                              ),
                            ],
                            color: Colors.deepOrange,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //------------------------short msg----------------------------//
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitThreeBounce(
                  color: Colors.deepOrangeAccent,
                  size: 25.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Text(
                  'Save your Time \nBuy your Auto Parts',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
