import 'package:autopartsadmin/config/config.dart';
import 'package:autopartsadmin/screens/main_screen.dart';
import 'package:autopartsadmin/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AutoParts.auth = FirebaseAuth.instance;
  AutoParts.sharedPreferences = await SharedPreferences.getInstance();
  AutoParts.firestore = FirebaseFirestore.instance;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoParts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrangeAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "/mainscreen": (_) => MainScreen(),
      },
      home: SplashScreen(),
    );
  }
}
