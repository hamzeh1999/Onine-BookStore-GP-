import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Authentication/authenication.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/ProfilePage/profilePage.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/Search.dart';
import 'package:gradproject/Store/SciencePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradproject/upload/uploadBook.dart';

class MyDrawer extends StatelessWidget {
  DataUser user;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
             color: Colors.cyan,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream:Firestore.instance
                  .collection("users")
                  .where("uid",isEqualTo: BookStore.sharedPreferences.getString(BookStore.userUID))
                  .snapshots(),
              builder: (context,dataSnapShot){
                if(!dataSnapShot.hasData)
                {
                  return CircularProgressIndicator();
                }
                 user = DataUser.fromJson(dataSnapShot.data.documents[0].data);
                return smallPicture(user, context);

              },
            ),
          ),
          SizedBox (
            height: 2.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: new BoxDecoration(
              color: Colors.cyan
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person , color: Colors.white ,),
                  title: Text("My profile ", style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> profilePage(user: user,) );
                    Navigator.push(context, route);
                  },
                ),
                Divider(height: 5.0, color: Colors.white, thickness: 2.0,) ,
                ListTile(
                  leading: Icon(Icons.home , color: Colors.white ,),
                  title: Text("Home ", style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> Home() );
                    Navigator.push(context, route);
                  },
                ),
                Divider(height: 5.0, color: Colors.white, thickness: 2.0,) ,
                ListTile(
                  leading: Icon(Icons.upload_outlined , color: Colors.white ,),
                  title: Text("UPLOAD ", style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> UploadPage() );
                    Navigator.push(context, route);
                  },
                ),
                Divider(height: 5.0, color: Colors.white, thickness: 2.0,) ,
                ListTile(
                  leading: Icon(Icons.search , color: Colors.white ,),
                  title: Text("Search ", style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Route route = MaterialPageRoute(builder: (c)=> SearchProduct() );
                    Navigator.push(context, route);
                  },
                ),
                Divider(height: 5.0, color: Colors.white, thickness: 2.0,) ,
                ListTile(
                  leading: Icon(Icons.exit_to_app , color: Colors.white ,),
                  title: Text("Log Out ", style: TextStyle(color: Colors.white),),
                  onTap: (){
                    BookStore.auth.signOut().then((c) {
                      Route route = MaterialPageRoute(builder: (c)=> AuthenticScreen() );
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(height: 5.0, color: Colors.white, thickness: 2.0,) ,


              ],
            ),

          )
        ],
      ),
    );
  }






  Widget smallPicture(DataUser dataUser,BuildContext context)
  {
    return Column(
      children: [
        Material(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(90.0)),
          elevation: 8.0,
          child: Container(
            height: height*0.28,
            width: width*0.5,
            child: InkWell(
              child: CircleAvatar(
                //radius: 90,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 87.7, // NetworkImage(EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl))==null? Icon(Icons.person_outline,color: Colors.red,):null,
                  backgroundImage: NetworkImage(dataUser.url),

                ),
              ),
              onTap: (){

                Navigator.push(context,MaterialPageRoute(builder: (context)=>profilePage(user: dataUser)));

              },
            ),
          ),
        ),

        SizedBox(
          height: 10.0,
        ),
        Text(
          dataUser.Name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 35.0,
            fontFamily: "Signatra",
          ),
        ),
      ],
    );
  }



}
