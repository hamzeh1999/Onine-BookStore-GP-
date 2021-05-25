import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradproject/Widgets/customAppBar.dart';


import '../Widgets/myDrawer.dart';
import '../Models/Book.dart';

class MyBook extends StatefulWidget {
  final DataUser dataUser;
  MyBook({this.dataUser});

  @override
  MyBookState createState() => MyBookState();
}

class MyBookState extends State<MyBook> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        decoration: new BoxDecoration(
         color: Colors.white
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: MyAppBar(),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
            child: MyDrawer(),),
          body: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height:screenSize.height*0.001),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(15.0),
                  padding: EdgeInsets.symmetric(
                    horizontal:10.0 ,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF4A3298),
                    borderRadius: BorderRadius.circular(30),
                  ),


                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        //    TextSpan(text: "Book Store\n"),
                        TextSpan(
                          text: "Welcome To ${widget.dataUser.Name}'s Books",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),


                ),
                Container(
                  width:screenSize.width*4.0,
                  height:screenSize.height*0.66,
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: [
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Books").where("uid",isEqualTo:widget.dataUser.uid)
                            .orderBy("publishedDate", descending: true)
                            .snapshots(),
                        builder: (context, dataSnapShot) {
                          return !dataSnapShot.hasData
                              ? SliverToBoxAdapter(
                            child: Center(
                              child:Text("There are no books",style: TextStyle(fontSize: 25,color: Colors.white),),
                            ),
                          )
                              : SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 1,
                            staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              Book model = Book.fromJson(
                                  dataSnapShot.data.documents[index].data);
                              return sourceInfo(model, context);
                            },
                            itemCount: dataSnapShot.data.documents.length,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


