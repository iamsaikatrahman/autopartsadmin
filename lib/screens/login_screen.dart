import 'dart:async';

import 'package:autopartsadmin/Helper/login_helper.dart';
import 'package:autopartsadmin/screens/main_screen.dart';
import 'package:autopartsadmin/widgets/customTextField.dart';
import 'package:autopartsadmin/widgets/progressDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _adminIdTextEditingController = TextEditingController();
  final _adminPasswordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
              Image.asset(
                "assets/authenticaiton/logo.png",
                width: 150,
              ),
              LoginHelper().welcomeText(),
              SizedBox(height: 10),
              LoginHelper().subtitleText(),
              SizedBox(height: 20),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _adminIdTextEditingController,
                      textInputType: TextInputType.emailAddress,
                      data: Icons.person_outline_outlined,
                      hintText: "ID",
                      labelText: "ID",
                      isObsecure: false,
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      controller: _adminPasswordTextEditingController,
                      textInputType: TextInputType.text,
                      data: Icons.lock_outline,
                      hintText: "Password",
                      labelText: "Password",
                      isObsecure: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    //-------------Internet Connectivity--------------------//

                    var connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi) {
                      showSnackBar("No internet connectivity");
                      return;
                    }
                    //----------------checking textfield--------------------//

                    loginAdmin();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }

  loginAdmin() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: "Login, Please wait....",
      ),
    );
    FirebaseFirestore.instance.collection("admins").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()["id"] != _adminIdTextEditingController.text.trim()) {
          showSnackBar("Your id is not correct.");
        } else if (result.data()["password"] !=
            _adminPasswordTextEditingController.text.trim()) {
          showSnackBar("Your password is not correct.");
        } else {
          showSnackBar("Welcome Dear Admin, " + result.data()["name"]);
          setState(() {
            _adminIdTextEditingController.text = "";
            _adminPasswordTextEditingController.text = "";
          });
          Timer(
            Duration(seconds: 2),
            () {
              setState(() {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/mainscreen", (_) => false);
              });
            },
          );
        }
      });
    });
  }
}
