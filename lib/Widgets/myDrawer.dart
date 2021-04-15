import 'package:gradproject/Admin/uploadItems.dart';
import 'package:gradproject/Authentication/authenication.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/Search.dart';
import 'package:gradproject/Store/SciencePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(EcommerceApp
                          .sharedPreferences
                          .getString(EcommerceApp.userAvatarUrl)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userName),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontFamily: "Signatra",
                  ),
                ),
              ],
            ),
          ),
          SizedBox (
            height: 12.0,
          ),
           Container(
             padding: EdgeInsets.only(top: 1.0),
             decoration: new BoxDecoration(
               gradient: new LinearGradient(
                 colors: [Colors.pink, Colors.lightGreenAccent],
                 begin: const FractionalOffset(0.0, 0.0),
                 end: const FractionalOffset(1.0, 0.0),
                 stops: [0.0, 1.0],
                 tileMode: TileMode.clamp,
               ),
             ),
             child: Column(
               children: [
                 ListTile(
                   leading: Icon(Icons.home , color: Colors.white ,),
                   title: Text("Home ", style: TextStyle(color: Colors.white),),
                   onTap: (){
                     Route route = MaterialPageRoute(builder: (c)=> Home() );
                     Navigator.pushReplacement(context, route);
                   },
                 ),
                 Divider(height: 10.0, color: Colors.white, thickness: 6.0,) ,
                 ListTile(
                   leading: Icon(Icons.home , color: Colors.white ,),
                   title: Text("UPLOAD ", style: TextStyle(color: Colors.white),),
                   onTap: (){
                     Route route = MaterialPageRoute(builder: (c)=> UploadPage() );
                     Navigator.pushReplacement(context, route);
                   },
                 ),
                 Divider(height: 10.0, color: Colors.white, thickness: 6.0,) ,
                 ListTile(
                   leading: Icon(Icons.search , color: Colors.white ,),
                   title: Text("Search ", style: TextStyle(color: Colors.white),),
                   onTap: (){
                     Route route = MaterialPageRoute(builder: (c)=> SearchProduct() );
                     Navigator.pushReplacement(context, route);
                   },
                 ),
                 Divider(height: 10.0, color: Colors.white, thickness: 6.0,) ,
                 ListTile(
                   leading: Icon(Icons.exit_to_app , color: Colors.white ,),
                   title: Text("Log Out ", style: TextStyle(color: Colors.white),),
                   onTap: (){
                    EcommerceApp.auth.signOut().then((c) {
                      Route route = MaterialPageRoute(builder: (c)=> AuthenticScreen() );
                      Navigator.pushReplacement(context, route);
                    });
                   },
                 ),
                 Divider(height: 10.0, color: Colors.white, thickness: 6.0,) ,


               ],
             ),

           )
        ],
      ),
    );
  }
}
