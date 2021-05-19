import 'package:gradproject/Config/config.dart';
import 'package:gradproject/Store/BookModificationPage.dart';
import 'package:gradproject/Store/picturePage.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/myDrawer.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                    Visibility(
                      visible: showNumber,
                      child: ListTile(
                        leading: Icon(
                          Icons.phone,
                          color:Color(0xff122636) ,
                        ),

                        title: Container(
                          //width:100.0,
                          child: Text(widget.BookModel.phoneNumber),
                        ),
                      ),
                    ),
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
                        'Click to show Number',
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




}



const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const beforeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
const afterTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20,color: Colors.black);

