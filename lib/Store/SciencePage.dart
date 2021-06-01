import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import '../Widgets/myDrawer.dart';
import '../Models/Book.dart';

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
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: MyAppBar(),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(44),
                bottomRight: Radius.circular(44)),
            child: MyDrawer(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.025),
                ClayContainer(
                  color: Color(0xFFDC5F1C),
                  height: 95,
                  width: 390,
                  customBorderRadius: BorderRadius.only(
                    topRight: Radius.elliptical(150, 150),
                    bottomLeft: Radius.circular(50),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: ClayText(
                        "Welcome To Science Books",
                        emboss: false,
                        size: 25,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.025),
                Container(
                  width: screenSize.width * 4.0,
                  height: screenSize.height * 0.66,
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: [
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("Books")
                            .where("category", isEqualTo: "Science")
                            .orderBy("publishedDate", descending: true)
                            .snapshots(),
                        builder: (context, dataSnapShot) {
                          return !dataSnapShot.hasData
                              ? SliverToBoxAdapter(
                                  child: Center(
                                      child: Text(
                                    "There are no Science books",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.blue),
                                  )),
                                )
                              : SliverStaggeredGrid.countBuilder(
                                  crossAxisCount: 1,
                                  staggeredTileBuilder: (c) =>
                                      StaggeredTile.fit(1),
                                  itemBuilder: (context, index) {
                                    Book model = Book.fromJson(dataSnapShot
                                        .data.documents[index].data);
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
