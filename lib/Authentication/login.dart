import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Admin/adminLogin.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/SciencePage.dart';
import 'package:gradproject/Config/config.dart';


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
                  ),
                  CustomTextField(
                    controller: _passwordtextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
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
            FlatButton.icon(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminSignInPage()));

              },
              icon: Icon(Icons.nature_people ,color: Colors.pink,),
              label: Text("I`m Admin",style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),),
            ),

          ],
        ),
      ),
    );
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
 void loginUser() async {
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
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userUID, dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapshot.data[EcommerceApp.userAvatarUrl]);
      List  <String> cartList = dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,cartList);


    } );


  }
}
