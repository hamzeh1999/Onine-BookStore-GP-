import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/DialogBox/loadingDialog.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/Store/MyBook.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/loadingWidget.dart';
import 'package:gradproject/Widgets/myDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../Store/Home.dart';

class profilePage extends StatefulWidget {
  final DataUser user;
  profilePage({this.user});



  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {

  final TextEditingController _nametextEditingController = TextEditingController();
  final TextEditingController _phoneNumberTextEditingController = TextEditingController();
  final TextEditingController _emailtextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();





  File file;
  String userImageUrl = "";

  @override
  Widget build(BuildContext context) {
    // width = MediaQuery.of(context).size.width;
    //height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: (){Navigator.pop(context);},
      child: Scaffold(
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
          child: MyDrawer(),
        ),
        appBar: AppBar(
          title: Text("الصفحه الشخصيه"),
          centerTitle: true,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(50),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.book,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyBook(dataUser:widget.user)),
              ),
            ),
            // InkWell(
            //     child: CircleAvatar(
            //       radius: 27,
            //       backgroundColor: Colors.white,
            //       child: CircleAvatar(
            //       radius: 25.7,
            //       backgroundImage: NetworkImage(EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl)),
            //   ),
            //     ),
            //   onTap: (){
            //     Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>profilePage()));
            //   },
            // ),


          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[




            SizedBox(
              height:height*0.02,
            ),
            Stack(
              overflow: Overflow.visible,
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  height: height*0.29,
                ),
                Center(
                  child: CircleAvatar(
                    radius: width * 0.292,
                    backgroundColor: Colors.lightBlueAccent,
                    child: CircleAvatar(
                      radius: width * 0.9,
                      backgroundImage: NetworkImage(widget.user.url),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -5.0,
                  child: IconButton(
                    iconSize: 50.0,
                    highlightColor: Colors.lightBlueAccent,
                    color: Colors.lightBlueAccent,
                    icon: Icon(Icons.linked_camera),
                    onPressed: () => takeImage(context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.09,
            ),
            Row(
              children: [
                SizedBox(width: width*0.05,),
                Text("Your Name : ",style: TextStyle(fontSize: 20,color: Colors.black),),
                SizedBox(width: width*0.02,),
                Text(widget.user.Name,style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,

                ),),
              ],
            ),
            CustomTextField(
              data: Icons.drive_file_rename_outline,
              hintText: "write your new name",
              specifer: 1,
              isObsecure: false,
              controller:_nametextEditingController,
            ),
            SizedBox(
              height: height * 0.09,
            ),

            Row(
              children: [
                SizedBox(width: width*0.05,),
                Text(
                  "Your phoneNumber : ",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Text(
                  widget.user.phoneNumber,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            CustomTextField(
              data: Icons.phone,
              hintText: "write new phone",
              specifer: 0,
              isObsecure: false,
              controller: _phoneNumberTextEditingController,
            ),

            SizedBox(
              height: height * 0.09,
            ),
            Row(
              children: [
                SizedBox(width: width*0.05,),
                Text("Your Email : ",style: TextStyle(fontSize: 20,color: Colors.black),),
                SizedBox(width: width*0.02,),
                Text(widget.user.Email,style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,

                ),),
              ],
            ),
            CustomTextField(
              data: Icons.email_outlined,
              hintText: "write new Email",
              specifer: 1,
              isObsecure: false,
              controller:_emailtextEditingController,
            ),
            SizedBox(
              height: height * 0.09,
            ),

            Row(
              children: [
                SizedBox(width: width*0.05,),
                Text("Your Password : ",style: TextStyle(fontSize: 20,color: Colors.black),),
                SizedBox(width: width*0.02,),
                Text(widget.user.password,style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,

                ),),
              ],
            ),
            CustomTextField(
              data: Icons.lock_outline,
              hintText: "write new password",
              specifer: 1,
              isObsecure: false,
              controller:_passwordTextEditingController,
            ),






            SizedBox(height: height*0.02,),
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




          ]
          ),
        ),
      ),
    );
  }

  takeImage(mContext) {
    setState(() {});
    return showDialog(
      context: mContext,
      builder: (con) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.lightGreen, width: 4),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Book Image",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              child: Text("Capture With Camera",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: caputrePhotoWithCamera,
            ),
            SimpleDialogOption(
              child: Text("Select From Gallery",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: pickPhotoFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancel",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  caputrePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      file = imageFile;
    });
    updatePhotoToFirebase();
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = imageFile;
    });
    updatePhotoToFirebase();
  }

  updatePhotoToFirebase() async {
    if (file != null) {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingAlertDialog(
              message: "Upload Photo ....",
            );
          });

      String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();

      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(imageFileName);

      StorageUploadTask storageUploadTask = storageReference.putFile(file);

      StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

      await taskSnapshot.ref.getDownloadURL().then((urlImage) {
        userImageUrl = urlImage;
      });

//print("EcommerceApp.forProfile.uidEcommerceApp.forProfile.uid ..................");
      Firestore.instance
          .collection("users")
          .document(
              BookStore.sharedPreferences.getString(BookStore.userUID))
          .updateData({'url': userImageUrl})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      //print("done");
      Navigator.pop(context);
    } else
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "Please Select An Image File .",
          );
        },
      );
  }


  updateDataToFirebase() async {

    if(_nametextEditingController.text.isNotEmpty ||
        _phoneNumberTextEditingController.text.isNotEmpty ||
        _emailtextEditingController.text.isNotEmpty ||
        _passwordTextEditingController.text.isNotEmpty) {
      if (_nametextEditingController.text.isNotEmpty) {
        await Firestore.instance
            .collection("users")
            .document(
            BookStore.sharedPreferences.getString(BookStore.userUID))
            .updateData({
          'name': _nametextEditingController.text
        })
            .then((value) => print("User Updated in fireStore"))
            .catchError((error) {
          print("Failed to update user in firestore: $error");
          showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "Please write your Name ",);
            },);
        });

        Fluttertoast.showToast(
          msg: "it\'s Done .......",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          //timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _nametextEditingController.clear();
      }


      if (_phoneNumberTextEditingController.text.isNotEmpty) {
        await Firestore.instance
            .collection("users")
            .document(
            BookStore.sharedPreferences.getString(BookStore.userUID))
            .updateData({'phoneNumber': _phoneNumberTextEditingController.text})
            .then((value) => print("User Updated in fireStore"))
            .catchError(
                (error) {
              print("Failed to update user in firestore: $error");
              showDialog(
                context: context,
                builder: (c) {
                  return ErrorAlertDialog(
                    message: "Please write your phone ",
                  );
                },
              );
            });

        Fluttertoast.showToast(
          msg: "it\'s Done",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          //timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _phoneNumberTextEditingController.clear();
      }


      if (_emailtextEditingController.text.isNotEmpty) {
        FirebaseUser firebaseUser = await BookStore.auth.currentUser();
        await firebaseUser
            .updateEmail(_emailtextEditingController.text.trim())
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
              'email': _emailtextEditingController.text})
                .then((value) => print("User Updated in fireStore"))
                .catchError((error) =>
                print("Failed to update user in firestore: $error"));

            _emailtextEditingController.clear();
          },
        )
            .catchError((onError) {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorAlertDialog(
                message: "write your Email correctly .",);
            },);
        });
      }

      if (_passwordTextEditingController.text.isNotEmpty) {
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
    }
    else
      showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: "fill one of them at least ",);
        },);


  }










}
