import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Store/Home.dart';
import 'file:///D:/GradProject/lib/Book_Details/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:provider/provider.dart';
import 'package:gradproject/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Models/Book.dart';

//double width;
//double height;

class SciencePage extends StatefulWidget {
  @override
  _SciencePageState createState() => _SciencePageState();
}

class _SciencePageState extends State<SciencePage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    //  width = MediaQuery.of(context).size.width;
   // height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: WillPopScope(
        // ignore: missing_return
        onWillPop:(){Navigator.pop(context);},
        child: Scaffold(
          backgroundColor: Colors.white,
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
                          text: "Welcome To Science Book",
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
                  width: screenSize.width*4.0,
                  height:screenSize.height*0.66,
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: [
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Books").where("category",isEqualTo: "Science" )
                            .orderBy("publishedDate", descending: true)
                            .snapshots(),
                        builder: (context, dataSnapShot) {
                          return !dataSnapShot.hasData
                              ? SliverToBoxAdapter(
                                child:Center(child:
                                Text("There are no Science books",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.blue),)),
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




