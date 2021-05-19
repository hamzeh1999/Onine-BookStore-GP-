import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/SciencePage.dart';
import 'package:gradproject/Config/config.dart';
import "dart:core";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login>
{

  final TextEditingController _emailtextEditingController =
  TextEditingController();
  final TextEditingController _passwordtextEditingController =
  TextEditingController();
  final GlobalKey<FormState> _fromkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screeHight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
        alignment: Alignment.bottomCenter,
              child: Image.asset('images/login.png',
              height: 240.0,
              width: 240.0,
             ) ,
            ),
            Padding(padding: EdgeInsets.all(8.0),
            child: Text("Log In To Your Account ." ,
            style: TextStyle(color: Colors.white),
            ),
            ),
            Form(
              key: _fromkey,
              child: Column(
                children: [

                  CustomTextField(
                    controller: _emailtextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                    specifer:1,
                  ),
                  CustomTextField(
                    controller: _passwordtextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                    specifer:1,
                  ),

                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                _emailtextEditingController.text.isNotEmpty && _passwordtextEditingController.text.isNotEmpty
                    ?loginUser()
                    : showDialog(
                  context: context,
                  builder: (c)
                    {
                      return ErrorAlertDialog(
                        message: "Please Fill Email And Password",
                      );
                    }
                );
              },
              color: Colors.pink,
              child: Text(
                "Log In  ",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 10.0,
            ),

          ],
        ),
      ),
    );
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
 void loginUser() async {
   // Timer(Duration(seconds: 20), ()=>print("20
   // seconds 20 seconds   20 seconds 20 seconds  20 seconds 20 seconds  20 seconds 20 seconds"),);

 showDialog(context: context, builder: (c){
      return LoadingAlertDialog(message: "Authenticating , Please Wait",);
    });


    FirebaseUser firebaseUser;
    await _auth.signInWithEmailAndPassword(
      email: _emailtextEditingController.text.trim() ,
      password:  _passwordtextEditingController.text.trim(),
    ).then((authUser) {
      firebaseUser =authUser.user;
      

    }).catchError((error)
        {  Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: error.message.toString(),
              );
            });

        }
    );
    if(firebaseUser!=null){
      readData (firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c)=> Home() );
        Navigator.pushReplacement(context, route);
      });
    }


  }
  Future readData(FirebaseUser fUser) async
  {







    Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot)
    async {
      await BookStore.sharedPreferences.setString(BookStore.phoneNumber, dataSnapshot.data[BookStore.phoneNumber]);
      await BookStore.sharedPreferences.setString(BookStore.userPassword, dataSnapshot.data[BookStore.userPassword]);
      await BookStore.sharedPreferences.setString(BookStore.userAvatarUrl, dataSnapshot.data[BookStore.userAvatarUrl]);
      await BookStore.sharedPreferences.setString(BookStore.userUID, dataSnapshot.data[BookStore.userUID]);
      await BookStore.sharedPreferences.setString(BookStore.userEmail,dataSnapshot.data[BookStore.userEmail]);
      await BookStore.sharedPreferences.setString(BookStore.userName, dataSnapshot.data[BookStore.userName]);

    } );


  }
}
