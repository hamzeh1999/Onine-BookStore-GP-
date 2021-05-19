
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

import 'DataUser.dart';
class MyPassword extends StatefulWidget {
  final DataUser user;
  MyPassword(this.user);
  @override
  _MyPasswordState createState() => _MyPasswordState();
}

class _MyPasswordState extends State<MyPassword> {
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cpasswordtextEditingController = TextEditingController();



  @override
    Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
        child:Scaffold(
          appBar: MyAppBar(),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
            child: MyDrawer(),),
          body:  SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(
                  height: screenSize.height * 0.09,
                ),


                Row(
                  children: [
                    SizedBox(width: screenSize.width*0.05,),
                    Text("Your Password : ",style: TextStyle(fontSize: 20,color: Colors.black),),
                    SizedBox(width: screenSize.width*0.02,),
                    Flexible(
                      child: Text(widget.user.password,style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,

                      ),),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.04,
                ),
                CustomTextField(
                  data: Icons.lock_outline,
                  hintText: "write your new password",
                  specifer: 1,
                  isObsecure: false,
                  controller:_passwordTextEditingController,
                ),
                SizedBox(
                  height: screenSize.height * 0.04,
                ),
                CustomTextField(
                  data: Icons.lock_outline,
                  hintText: "write your new password",
                  specifer: 1,
                  isObsecure: false,
                  controller:_cpasswordtextEditingController,
                ),
                SizedBox(
                  height: screenSize.height * 0.09,
                ),
                ElevatedButton(
                  onPressed: () {
                    updateDataToFirebase();
                  },
                  style: OutlinedButton.styleFrom(
                    elevation: 9,
                    backgroundColor: Colors.lightBlueAccent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Change',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
      );
    }

  updateDataToFirebase() async {
    if (_passwordTextEditingController.text.isNotEmpty) {
      if (_passwordTextEditingController.text == _cpasswordtextEditingController.text)
      {
          FirebaseUser firebaseUser = await BookStore.auth.currentUser();
          await firebaseUser
              .updatePassword(_passwordTextEditingController.text)
              .then(
                (value) async {
              Fluttertoast.showToast(
                msg: "it\'s Done",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                //timeInSecForIosWeb: 1,
                backgroundColor: Colors.lightBlueAccent,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              await Firestore.instance
                  .collection("users")
                  .document(
                  BookStore.sharedPreferences.getString(BookStore.userUID))
                  .updateData({
                'password': _passwordTextEditingController.text})
                  .then((value) => print("User Updated in fireStore"))
                  .catchError((error) =>
                  print("Failed to update user in firestore: $error"));

              _passwordTextEditingController.clear();
            },
          )
              .catchError((onError) {
            showDialog(
              context: context,
              builder: (c) {
                return ErrorAlertDialog(
                  message: "Your password should be more than 6 characters .",);
              },);
          });
        }
      else
      {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: " passwords don\'t match ",);
          },);
      }


    }
    else
      {
    showDialog(
    context: context,
    builder: (c) {
    return ErrorAlertDialog(
    message: "fill your password ",);
    },);
    }

  }












}
