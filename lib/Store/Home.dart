import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:gradproject/Models/section_title.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/Store/MyBook.dart';
import 'package:gradproject/Store/NovelPage.dart';
import 'package:gradproject/Store/TawjihiPage.dart';
import 'package:gradproject/Store/product_page.dart';
import 'package:gradproject/Store/SciencePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradproject/Widgets/CustomBottomNavBar.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:intl/intl.dart';
import 'package:gradproject/Config/config.dart';
import '../Widgets/loadingWidget.dart';


double width;
double height;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
   height= MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        // drawer: ClipRRect(
        //   borderRadius: BorderRadius.only(
        //       topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
        //   child: MyDrawer(),),

        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height*0.01,),
              Container(
                width:width,
                height: height*0.14,
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  slivers: [
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("users")
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
                          DataUser user = DataUser.fromJson(
                                dataSnapShot.data.documents[index].data);
                            return DisplayForUser(user, context);
                          },
                          itemCount:dataSnapShot.data.documents.length,
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.all(20.0),
              //   padding: EdgeInsets.symmetric(
              //     horizontal:10.0 ,
              //     vertical: 10.0,
              //   ),
              //   decoration: BoxDecoration(
              //     color: Colors.cyan,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Text.rich(
              //     TextSpan(
              //       style: TextStyle(color: Colors.white),
              //       children: [
              //         TextSpan(text: "Book Store\n"),
              //         TextSpan(
              //           text: "Welcome To Our Book Store",
              //           style: TextStyle(
              //             fontSize: 30,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //SizedBox(height: (5)),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: (20)),
                    child: SectionTitle(
                     color: Colors.blue,
                      title: "Special for you",
                      press: () {},
                    ),
                  ),
                  SizedBox(height: (5)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SpecialOfferCard(
                          image: "images/Image Banner 3.png",
                          category: "Science",
                          press: () {
                            Route route = MaterialPageRoute(builder:(context)=>SciencePage());
                            Navigator.push(context, route);},
                        ),
                        SpecialOfferCard(
                          image: "images/Image Banner 2.jpg",
                          category: "Novels",
                          press: () {
                            Route route = MaterialPageRoute(builder:(context)=>NovelsPage());
                          Navigator.push(context, route);},
                        ),
                        SpecialOfferCard(
                          image: "images/Image Banner 4.PNG",
                          category: "Tawijehi",
                          press: () { Route route = MaterialPageRoute(builder:(context)=>TawjihiPage());
                          Navigator.push(context, route);},
                        ),SpecialOfferCard(
                          image: "images/Image Banner 5.png",
                          category: "PDF",
                          press: () {
                            print("height: $height ................. width :$width");},
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              SizedBox(height: (15)),
              Column(children: [
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: (20)),
                  child: SectionTitle(title: "Recent Books", color: Colors.blue,press: () {}),
                ),
                SizedBox(height:5,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: (5)),
                  child: Container(
                    width:width,
                    height:height*0.45,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      slivers: [
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("Books")
                              .limit(6)
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
                                Book model = Book.fromJson(
                                    dataSnapShot.data.documents[index].data);
                                return sourceInfo(model, context);
                              },
                              itemCount:dataSnapShot.data.documents.length,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              ],

              ),

            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.Home),


      ),
    );
  }

}


Widget DisplayForUser(DataUser dataUser,BuildContext context)
{

return InkWell(

  onTap:(){
    return Navigator.push(context, MaterialPageRoute(builder:(context)=>MyBook(dataUser:dataUser)));
    },
  child:   Column(
    children: <Widget>[
      CircleAvatar(
        radius: 31.5,
        backgroundColor: Colors.blue,
        child: CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(dataUser.url),
          backgroundColor: Colors.transparent,
        ),
      ),
      Text(dataUser.Name),
    ],
  ),
);
}

Widget sourceInfo(Book model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (c)=> ProductPage(BookModel : model) );
      Navigator.push(context, route);
    },
    splashColor: Colors.purpleAccent,
    child: Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Color(0xff122636),
        ),
       // height: height*0.349,
       // width: width,
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Row(
            children: [
              CircleAvatar(
            radius: 70.0,
            backgroundImage:
            NetworkImage( model.thumbnailUrl[0]),
            backgroundColor: Colors.transparent,

              ),
              SizedBox(
                width: width*0.01,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                              "Name :",
                              style:
                              TextStyle(color: Colors.black54, fontSize: 14.0, fontWeight: FontWeight.normal,)
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                              model.newTitle,
                              style:
                              TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold,)
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height:5.0,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Price : JD ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    (model.price.toString()),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                     // decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    "City : ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    (model.city ).toString(),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                   // decoration: TextDecoration.lineThrough,

                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    ("purpose : "),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              (model.purpose),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Text(
                                    (DateFormat("d/M/y :").add_jm().format(model.publishedDate.toDate()).toString()),
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ],
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

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key key,
    @required this.category,
    @required this.image,
    @required this.press,
  }) : super(key: key);

  final String category, image;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: (20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: (242),
          height: (100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,

                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (15.0),
                    vertical: (10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: (18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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

