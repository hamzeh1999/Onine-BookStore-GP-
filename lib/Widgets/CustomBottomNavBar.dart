import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Authentication/authenication.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/ProfilePage/profilePage.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/Search.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/upload/uploadBook.dart';

enum MenuState { Home, Upload, Profile, Logout }

class CustomBottomNavBar extends StatelessWidget {
 // DataUser user;


  const CustomBottomNavBar({ Key key, @required this.selectedMenu,}) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xff122636),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(


            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [




              IconButton(
                  icon: Icon(Icons.house_outlined,
                    color: MenuState.Home == selectedMenu
                        ? Colors.black
                        : inActiveIconColor,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>Home()));
                  }),
              IconButton(
                icon: Icon(Icons.upload_outlined,
                  color: MenuState.Upload == selectedMenu
                    ? Colors.black
                    : inActiveIconColor,),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c)=> UploadPage() );
                  Navigator.push(context, route);
                },
              ),
              IconButton(
                icon:Icon(Icons.search_outlined,color: MenuState.Profile == selectedMenu
                    ? Colors.black
                    : inActiveIconColor,),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c)=> SearchProduct() );
                  Navigator.push(context, route);
                },
              ),
              IconButton(
                icon: Icon(Icons.logout,color: MenuState.Logout == selectedMenu
                    ? Colors.black
                    : inActiveIconColor,),
                onPressed: () {
                  BookStore.auth.signOut().then((c) {
                    Route route = MaterialPageRoute(builder: (c)=> AuthenticScreen() );
                    Navigator.pushReplacement(context, route);
                  });
                },
              ),

              // StreamBuilder<QuerySnapshot>(
              //   stream:Firestore.instance
              //       .collection("users")
              //       .where("uid",isEqualTo: EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
              //       .snapshots(),
              //   builder: (context,dataSnapShot){
              //     if(!dataSnapShot.hasData)
              //     {
              //       return CircularProgressIndicator();
              //     }
              //     DataUser user = DataUser.fromJson(dataSnapShot.data.documents[0].data);
              //     return smallPicture(user, context);
              //
              //   },
              // ),




            ],
          )),
    );
  }


}