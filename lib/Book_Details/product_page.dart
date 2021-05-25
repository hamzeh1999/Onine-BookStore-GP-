import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/myDrawer.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gradproject/Book_Details/BookModificationPage.dart';
import 'package:gradproject/Book_Details/picturePage.dart';
import 'package:gradproject/Messager/chatScreen.dart';


class ProductPage extends StatefulWidget {
  final Book BookModel;
  ProductPage({this.BookModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // final ItemModel itemModel;
  //
  // _ProductPageState(this.itemModel);

 // int quantityOfItem = 1;
String s1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //s1=widget.itemModel.bookId.toString();
   // print("okhuyigutfdytrdsrtezarwarestrydfufgiuhiuhguiyftdyt"+s1);
    modification(widget.BookModel);


  }


  bool showNumber=false;

  bool showButton=false;
  @override

  Widget build(BuildContext context) {


    //  ItemModel userUID=widget.itemModel.userUID as ItemModel;
   // String s=userUID.toString();
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: (){Navigator.pop(context);},
        child: Scaffold(
          appBar: MyAppBar(),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
            child: MyDrawer(),),
          body: ListView(
            children: [
               ProductImages(book:widget.BookModel),
          SingleChildScrollView(
            child: Column(
              children: [


                Column(
                  children: [





                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal:  (20 / 375.0) *screenSize.width,),
                      child: Center(
                        child: Text(
                          widget.BookModel.newTitle,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),


                    ListTile(
                      subtitle: Text("description:"),

                      leading: Icon(
                        Icons.description,
                        color: Color(0xff122636),
                      ),

                      title: Text(widget.BookModel.description,maxLines: 4,),
                    ),
                    ListTile(


                      subtitle: Text("city:"),
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: Color(0xff122636),
                      ),

                      title: Text(widget.BookModel.city,),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.category,
                        color: Color(0xff122636),
                      ),
                      subtitle: Text("category:"),

                      title: Text(widget.BookModel.category,),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.high_quality_outlined,
                        color: Color(0xff122636),
                      ),
                      subtitle: Text("status:"),

                      title: Text(widget.BookModel.status,maxLines: 1,),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.attach_money_outlined,
                        color: Color(0xff122636),
                      ),
                      subtitle: Text("price:"),

                      title: Text(widget.BookModel.price.toString()+" JD",),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.description,
                        color:Color(0xff122636),
                      ),
                      subtitle: Text("purpose"),


                      title: Text(widget.BookModel.purpose,maxLines: 4,),
                    ),

                    StreamBuilder<QuerySnapshot>(
                        stream:Firestore.instance
                            .collection("users")
                            .where("uid",isEqualTo: widget.BookModel.userUID)
                            .snapshots(),
                        builder: (context,dataSnapShot){
                          if(!dataSnapShot.hasData)
                          {
                            return CircularProgressIndicator();
                          }
                          DataUser user = DataUser.fromJson(dataSnapShot.data.documents[0].data);
                          return userInfo(user,context);

                        },
                      ),

                    //
                    // Visibility(
                    //   visible: showNumber,
                    //   child: ListTile(
                    //     leading: Icon(
                    //       Icons.phone_outlined,
                    //       color:Color(0xff122636) ,
                    //     ),
                    //     title: Text(widget.BookModel.phoneNumber),
                    //   ),
                    // ),
                    //
                    // Visibility(
                    //   visible: showNumber,
                    //   child: InkWell(
                    //     onTap: (){
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => ChatScreen(hisName:widget.BookModel.userName,
                    //                 profilePicUrl:widget.BookModel.urlUser,
                    //                 hisUid:widget.BookModel.userUID,)));
                    //
                    //     },
                    //     child: ListTile(
                    //       title: Text(widget.BookModel.userName),
                    //       subtitle: Text("click me to talk "),
                    //       leading: Container(
                    //         width: 49,
                    //         height: 45,
                    //         child:Hero(
                    //           tag: widget.BookModel.userName,
                    //           child: CircleAvatar(
                    //             radius: 32,
                    //             foregroundColor:Color(0xff122636),
                    //             child: CircleAvatar(
                    //               radius: 30.0,
                    //               backgroundImage: NetworkImage(widget.BookModel.urlUser),
                    //               backgroundColor: Colors.transparent,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    ListTile(
                      leading: Icon(
                        Icons.watch_later_outlined,
                        color:Color(0xff122636) ,
                      ),

                      title: Text(
                        (DateFormat("d/M/y :")
                          .add_jm().format(widget.BookModel.publishedDate.toDate())
                          .toString()
                      ),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xff122636),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {setState(() {
                        showNumber=true;
                      });},
                      style: OutlinedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Color(0xff122636),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'show Reader',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),


                  ],
                ),


              ],
            ),
          ),
            ],
          ),

          floatingActionButton: Visibility(

            visible: showButton,
            child: FloatingActionButton(
backgroundColor: Color(0xff122636),
              onPressed:(){
                modification(widget.BookModel);
                Navigator.push(context,
                    MaterialPageRoute(builder:(context)=>BookModificationPage(itemModel:widget.BookModel),),);
              },
             // tooltip: 'Increment',
              child: Icon(Icons.settings),
            ),
          ),


        ),
      ),
    );
  }

modification(Book model){
    if(BookStore.sharedPreferences.getString(BookStore.userUID)==model.userUID)
      setState(() {
        showButton=true;
      });

}

Widget userInfo(DataUser user, BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;


  return Visibility(
    visible: showNumber,
    child: Container(
          height:screenSize.height*0.22,
          width:screenSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children:[


            Visibility(
              visible: showNumber,
              child: ListTile(
                leading: Icon(
                  Icons.phone_outlined,
                  color:Color(0xff122636) ,
                ),
                title: Text(user.phoneNumber),
              ),
            ),

            Visibility(
              visible: showNumber,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(hisName:user.Name,
                            profilePicUrl:user.url,
                            hisUid:user.uid,)));

                },
                child: ListTile(
                  title: Text(user.Name),
                  subtitle: Text("click me to talk "),
                  leading: Container(
                    width: 49,
                    height: 45,
                    child:Hero(
                      tag: user.Name,
                      child: CircleAvatar(
                        radius: 31,
                        backgroundColor:Colors.white,
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(user.url),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
              ]


          ),
        ),
  );


  }




}


