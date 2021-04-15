import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/SciencePage.dart';
import 'package:gradproject/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nametextEditingController =
      TextEditingController();
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  final TextEditingController _cpasswordtextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _fromkey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screeHight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 8.0,
            ),
            InkWell(
              onTap: _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _fromkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nametextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailtextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordtextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _cpasswordtextEditingController,
                    data: Icons.lock,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              color: Colors.pink,
              child: Text(
                "Sign Up ",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() {
    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "Please Select An Image File .",
          );
        },
      );
    } else {
      _passwordtextEditingController.text == _cpasswordtextEditingController.text
          ? _emailtextEditingController.text.isNotEmpty &&
                  _passwordtextEditingController.text.isNotEmpty &&
                  _cpasswordtextEditingController.text.isNotEmpty &&
                  _nametextEditingController.text.isNotEmpty
              ? uploadToStorge()
              : displayDialog("Please fill up the registration form ..")
          : displayDialog("Password Do Not Match..");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorge() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "'Registering , Please wait.....'",
          );
        });
    String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailtextEditingController.text.trim(),
      password: _passwordtextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if(firebaseUser !=null)
      {
        saveUserInfoToFireStore(firebaseUser).then((value) {
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c)=> Home() );
          Navigator.pushReplacement(context, route);

        });
      }
  }
  Future saveUserInfoToFireStore(FirebaseUser fuser) async
  {
   Firestore.instance.collection("users").document(fuser.uid).setData({
     "uid": fuser.uid,
     "email": fuser.email,
     "name": _nametextEditingController.text.trim(),
     "url": userImageUrl,



   });
   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userUID, fuser.uid);
   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fuser.email);
   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nametextEditingController.text);
   await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);





  }
}
