import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:gradproject/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.pinkAccent, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,

          appBar: AppBar(
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
            title: Text(
              "Book Store",
              style: TextStyle(
                fontSize: 55.0,
                color: Colors.white,
                fontFamily: "Signatra",
              ),
            ),
            centerTitle: true,
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(builder: (c) => Home());
                      Navigator.pushReplacement(context, route);
                    },
                  ),

                ],
              ),
            ],

          ),
          drawer: MyDrawer(),
          body: Column(
            children: [

              SizedBox(height: (30)),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.symmetric(
                  horizontal:20.0 ,
                  vertical: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF4A3298),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(text: "Book Store\n"),
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
                width: 400,
                height: 400,
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  slivers: [
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("items")
                          .limit(15)
                          .orderBy("publishedDate", descending: true)
                          .snapshots(),
                      builder: (context, dataSnapShot) {
                        return !dataSnapShot.hasData
                            ? SliverToBoxAdapter(
                                child: Center(
                                  child: circularProgress(),
                                ),
                              )
                            : SliverStaggeredGrid.countBuilder(
                                crossAxisCount: 1,
                                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                                itemBuilder: (context, index) {
                                  ItemModel model = ItemModel.fromJson(
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
    );
  }
}
Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (c)=> ProductPage(itemModel : model) );
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.blue,
          gradient: new LinearGradient(
            colors: [Colors.lightGreenAccent, Colors.pinkAccent],
            begin: const FractionalOffset(0.0, 1),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        height: 190,
        width: width,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Image.network(
                model.thumbnailUrl,
                width: 140.0,
                height: 140.0,

              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [


                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                              model.title,
                              style:
                              TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height:10.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                              model.shortInfo,
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [

                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    r"Price : $ ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    (model.price ).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                    Flexible(child: Container()),
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

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}

