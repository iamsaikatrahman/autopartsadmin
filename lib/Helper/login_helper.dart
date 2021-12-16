import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginHelper {
  Widget loginLog() {
    return Image.asset(
      "assets/authenticaiton/logo.png",
      width: 150,
    );
  }

  Widget welcomeText() {
    return Text(
      "Welcome Admin!",
      style: TextStyle(
        fontSize: 30,
        fontFamily: 'Brand-Bold',
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget subtitleText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        "Log in to your existant account of AutoParts",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Brand-Regular',
          letterSpacing: 1,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget orText() {
    return Text(
      'OR',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget divider(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: 2.0,
        width: size.width / 2 - 30,
        color: Colors.black45,
      ),
    );
  }
}
