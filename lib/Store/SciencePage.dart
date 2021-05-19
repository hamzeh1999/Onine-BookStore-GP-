import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/product_page.dart';
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
                SizedBox(height:height*0.001),
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
                  width: width*4.0,
                  height:height*0.66,
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
// Widget sourceInfo(ItemModel model, BuildContext context,
//     {Color background}) {
//   return InkWell(
//     onTap: (){
//       Route route = MaterialPageRoute(builder: (c)=> ProductPage(itemModel : model) );
//       Navigator.pushReplacement(context, route);
//     },
//     splashColor: Colors.pink,
//     child: Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),
//         //color: Colors.blue,
//         gradient: new LinearGradient(
//           colors: [Colors.lightGreenAccent, Colors.pinkAccent],
//           begin: const FractionalOffset(0.0, 1),
//           end: const FractionalOffset(1.0, 0.0),
//           stops: [0.0, 1.0],
//           tileMode: TileMode.clamp,
//         ),
//       ),
//      // height: height*0.31,
//       width: double.infinity,
//       margin: EdgeInsets.all(5.0),
//       padding: EdgeInsets.symmetric(
//         horizontal:10.0 ,
//         vertical: 10.0,
//       ),
//       child: Row(
//         children: [
//           Image.network(
//             model.thumbnailUrl,
//             width: 140.0,
//             height: 140.0,
//
//           ),
//
//
//           SizedBox(
//             width: 1.0,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 50.0,
//                 ),
//                 Container(
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Expanded(
//                         child: Text(
//                           model.title,
//                           style:
//                           TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Row(
//                   children: [
//
//                     SizedBox(
//                       width: 10.0,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(top: 3.0),
//                           child: Row(
//                             children: [
//                               Text(
//                                 r"Price :$",
//                                 style: TextStyle(
//                                   fontSize: 14.0,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               Text(
//                                 (model.price ).toString(),
//                                 style: TextStyle(
//                                   fontSize: 15.0,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ],
//                 ),
//                // Flexible(child: Container()),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }



