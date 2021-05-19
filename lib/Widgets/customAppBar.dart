import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/ProfilePage/profilePage.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/SciencePage.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Store/Search.dart';
import 'package:gradproject/Widgets/loadingWidget.dart';
import 'package:provider/provider.dart';

import 'customTextField.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget {




  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom,});



  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;


    return AppBar(
      backgroundColor: Color(0xff122636),
      shape:RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
    bottom: Radius.circular(30),
    ),
    ),

     // centerTitle: true,
     /* title: Text(
        "Book Store",
        style: TextStyle(
          fontSize: 55.0,
          color: Colors.white,
          fontFamily: "Signatra",
        ),
      ),*/
      bottom: bottom,
      actions: [
        // IconButton(icon: Icon(Icons.search_outlined),
        //     onPressed:()=> Navigator.push(context,
        //       MaterialPageRoute(builder:(context)=>SearchProduct()
        //       ),
        //     ),
        // ),
           Container(
                alignment: Alignment.center,
                width: width-140,
                height: height-200,
               // color: Colors.blueGrey,
                child:InkWell(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchProduct()));
                    },
                    child: Container(
                      width: width*0.5,
                      height: height*0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.search,
                              color: Color(0xFFB6B6B6),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("Search here",style: TextStyle(color:Color(0xFFB6B6B6)),),
                          )
                        ],
                       ),
                     )
                )
           ),
        SizedBox(width: width*0.009,),


        Container(
          width:width*0.1499,
          height: height*0.001,
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
              DataUser user = DataUser.fromJson(dataSnapShot.data.documents[0].data);
              return smallPicture(user, context);

            },
          ),
        ),



        SizedBox(width: width*0.059,),
      ],


    );

  }
  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}


Widget smallPicture(DataUser dataUser,BuildContext context)
{  Size screenSize = MediaQuery.of(context).size;

return Material(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(90.0)),
     elevation: 8.0,
    child: Container(
      height: screenSize.height*0.01,
      width: screenSize.width*0.01,
      child: InkWell(
        child: CircleAvatar(
          radius: 27,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 26, // NetworkImage(EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl))==null? Icon(Icons.person_outline,color: Colors.red,):null,
            child: NetworkImage(dataUser.url)==null?Icon(Icons.person,color: Color(0xff122636),):null,
            backgroundImage: NetworkImage(dataUser.url),
            backgroundColor: Colors.white,

          ),
        ),
        onTap: (){

          Navigator.push(context,MaterialPageRoute(builder: (context)=>profilePage(user: dataUser)));

        },
      ),
    ),
  );
}
