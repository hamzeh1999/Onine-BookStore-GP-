import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:gradproject/Config/config.dart';
import 'Store/SciencePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BookStore.auth = FirebaseAuth.instance;
  BookStore.sharedPreferences = await  SharedPreferences.getInstance();
  BookStore.firestore = Firestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BookStore',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   primaryColor: Colors.green,
        // ),
        home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DisplaySpalsh();
  }

  DisplaySpalsh() {
    Timer(Duration(seconds: 5), () async {
      if (await BookStore.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (_) => Home());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.cyanAccent
        ),
        child: Center(child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/welcome.png"),
              SizedBox(height: 20.0,),
              Text("BookStore",
              style: TextStyle(color: Colors.white),),

            ],
          ),
        ),
        ),
      ),
    );
  }
}
