import 'package:gradproject/Counters/cartitemcounter.dart';
import 'package:gradproject/Store/SciencePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        "Book Store",
        style: TextStyle(
          fontSize: 55.0,
          color: Colors.white,
          fontFamily: "Signatra",
        ),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.pink,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => StoreHome());
                Navigator.pushReplacement(context, route);
              },
            ),

          ],
        ),
      ],


    );

  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
