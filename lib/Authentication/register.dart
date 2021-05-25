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
  final TextEditingController _nametextEditingController = TextEditingController();
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  final TextEditingController _numberTextEditingController=TextEditingController();
  final TextEditingController _cpasswordtextEditingController = TextEditingController();
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
          children: <Widget>[
             SizedBox(
               height: 8.0,
             ),
            InkWell(
              onTap:()=>_showPicker(context),
              child: CircleAvatar(
                radius: _screenWidth * 0.18,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile == null?null:FileImage(_imageFile),
                 child: _imageFile == null ? Icon(Icons.add_a_photo_outlined,
                         size: _screenWidth * 0.18,
                         color: Colors.blueAccent,
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
                    specifer:1,
                    controller: _nametextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    specifer:1,
                    controller: _emailtextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    specifer:0,
                    controller: _numberTextEditingController,
                    data: Icons.phone,
                    hintText: "Phone Number : ",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    specifer:1,
                    controller: _passwordtextEditingController,
                    data: Icons.lock,
                    hintText: "Password : ",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    specifer:1,
                    controller: _cpasswordtextEditingController,
                    data: Icons.lock,
                    hintText: "Confirm Password : ",
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

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _imageFile = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _imageFile = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Take a profile photo from Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Take a profile photo from Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
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
                    _numberTextEditingController.text.isNotEmpty &&
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
     // EcommerceApp.forProfile=auth.user;
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
     "phoneNumber":_numberTextEditingController.text.trim(),
     "password":_passwordtextEditingController.text.trim(),
     "caseSearch": setSearchParam(_nametextEditingController.text.toUpperCase()),



   });
   await BookStore.sharedPreferences.setString(BookStore.userUID, fuser.uid);
   await BookStore.sharedPreferences.setString(BookStore.userEmail,_emailtextEditingController.text);
   await BookStore.sharedPreferences.setString(BookStore.userPassword, _passwordtextEditingController.text);
   await BookStore.sharedPreferences.setString(BookStore.userName, _nametextEditingController.text);
   await BookStore.sharedPreferences.setString(BookStore.userAvatarUrl, userImageUrl);
   await BookStore.sharedPreferences.setString(BookStore.phoneNumber, _numberTextEditingController.text);

  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }




}
