// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:gradproject/Config/config.dart';
// import 'package:gradproject/Models/Book.dart';
// import 'package:gradproject/Store/Home.dart';
// import 'file:///D:/GradProject/lib/ProfilePage/profilePage.dart';
// import 'package:gradproject/Widgets/customTextField.dart';
// import 'package:gradproject/Widgets/myDrawer.dart';
//
// import '../Widgets/customAppBar.dart';
//
// class SearchProduct extends StatefulWidget {
//   @override
//   _SearchProductState createState() => new _SearchProductState();
// }
//
// class _SearchProductState extends State<SearchProduct> {
//   Future<QuerySnapshot> documnetList;
//   Future initSearch(String query)async{
//     String capitalizedValue = query.toUpperCase();
//
//     documnetList =  Firestore.instance
//         .collection('Books')
//         .where('caseSearch',arrayContains: capitalizedValue)
//         .getDocuments();
//     // print('documents: ${(await documnetList).documents[0].data['title']}');
//     setState(() {
//
//     });
//   }
//   Widget searchWidget(){
//     return ClipRRect(
//       borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30),bottomRight: Radius.circular(30)),
//       child: Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           height: 70.0,
//           color: Colors.lightBlueAccent,
//           child: Row(
//             children: [
//               IconButton(icon: Icon(Icons.arrow_back,),
//                 onPressed:()=> Navigator
//                     .pushReplacement(context, MaterialPageRoute(builder:(context)=>Home())),),
//
//               Container(
//                 width: MediaQuery.of(context).size.width - 120,
//                 height: 45.0,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(50.0),
//                 ),
//                 child: Row(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(6.0),
//                       child: Icon(
//                         Icons.search,
//                         color: Colors.lightBlueAccent,
//                       ),
//                     ),
//                     Flexible(
//                       child: Padding(
//                         padding: const EdgeInsets.all(0),
//                         child: TextField(
//                           onChanged: (val) {
//                             //initiateSearch(val);
//                             initSearch(val);
//                           },
//                           decoration: InputDecoration.collapsed(hintText:'Search here : ',
//                               hintStyle:TextStyle(color: Colors.blueAccent),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(width: width*0.03,),
//               InkWell(
//                 child: CircleAvatar(
//                   radius: 27,
//                   backgroundColor: Colors.white,
//                   child: CircleAvatar(
//                     radius: 25.7,
//                     backgroundImage: NetworkImage(EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl)),
//                   ),
//                 ),
//                 onTap: (){
//                   Navigator.push(context,MaterialPageRoute(builder: (context)=>profilePage()));
//                 },
//               ),
//
//             ],
//           )),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop:(){Navigator.pop(context);},
//         child: new Scaffold(
//             drawer: ClipRRect(
//               borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
//               child: MyDrawer(),),
//             appBar:AppBar(
//               actions: [
//                 // Container(
//                 //   color:Colors.red,
//                 //   child: TextField(
//                 //     style:TextStyle(color: Colors.red),
//                 //     onChanged: (val) {
//                 //       //initiateSearch(val);
//                 //       initSearch(val);
//                 //     },
//                 //     decoration: InputDecoration.collapsed(hintText:'Search here : '),
//                 //   ),
//                 // ),
//
//                 searchWidget(),
//                 ],
//               backgroundColor: Colors.orange[400],
//               elevation: 6,
//               shape:RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(50),
//         ),
//     ),
//             ),
//             body: Container(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       child:FutureBuilder<QuerySnapshot>(
//                               future: documnetList,
//                               builder: (context, snapshot) {
//
//                                 return snapshot.hasData?ListView.builder (
//                                     itemCount: snapshot.data.documents.length,
//                                     itemBuilder: (context,index){
//                                       ItemModel model = ItemModel.fromJson(snapshot.data.documents[index].data);
//                                       return sourceInfo(model,context);
//                                     })
//                                     :Center(
//                                       child: Text(
//                                   'No books for you',
//                                   style:TextStyle(
//                                         fontSize: 25,
//                                         color: Colors.blueAccent
//                                   ),
//                                 ),
//                                     );
//                               }
//                           ),
//
//                       ),
//                   ),
//                 ],
//               ),
//             ),
//       ),
//       )
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/ProfilePage/DataUser.dart';
import 'package:gradproject/ProfilePage/profilePage.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Widgets/CustomBottomNavBar.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:provider/provider.dart';
import 'package:gradproject/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Models/Book.dart';

//double width;
//double height;

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {

  String city = "";
  String category = "";
  String selectedCity = "choice city :";
  String selectedCategory = "choice category :";



  Stream<QuerySnapshot> documnetList;


  Future initSearch(String query)async{
     String capitalizedValue = query.toUpperCase();





     if(category.isNotEmpty && category!="choice category :" && city.isNotEmpty && city!="choice city :" )
     {
       print("........................................................... just city and category");

       documnetList=Firestore.instance
           .collection('Books')
           .where('caseSearch',arrayContains: capitalizedValue)
           .where("city",isEqualTo:city)
           .where("category",isEqualTo:category)
           .snapshots();



     }
    else if(city.isNotEmpty && city!="choice city :")
     {
print("........................................................... just city");

       documnetList=Firestore.instance
           .collection('Books')
           .where('caseSearch',arrayContains: capitalizedValue).where("city",isEqualTo:city)
           .snapshots();

     }
     else if(category.isNotEmpty && category!="choice category :")
       {
         print("........................................................... just category");

         documnetList=Firestore.instance
             .collection('Books')
             .where('caseSearch',arrayContains: capitalizedValue).where("category",isEqualTo:category)
             .snapshots();
     }

     else if(category.isEmpty || category=="choice category :" || city.isEmpty || city!="choice city :") {
       print("........................................................... nothing");
       documnetList = Firestore.instance
           .collection('Books')
           .where('caseSearch', arrayContains: capitalizedValue)
           .snapshots();
     }
     setState(() {

     });
   }
  @override
  Widget build(BuildContext context) {
    //  width = MediaQuery.of(context).size.width;
    // height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: WillPopScope(
        onWillPop:(){Navigator.pop(context);},
        child: Scaffold(
         // backgroundColor: Colors.white,
          appBar:AppBar(
            title: Text("Search Page"),
              centerTitle: true,
              actions: [
                Container(
                  width:width*0.15,
                  height: height*0.01,
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



                SizedBox(width: width*0.07,),

                ],
              backgroundColor: Colors.blue[400],
              elevation: 6,
              shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
        ),
    ),
          ),
          // drawer: ClipRRect(
          //   borderRadius: BorderRadius.only(
          //       topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
          //   child: MyDrawer(),),
          body: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height: height*0.01,),
                Container(
                  decoration:BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.all((Radius.circular(30.0)),
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border:InputBorder.none,
                      prefixIcon: Icon(Icons.search_outlined,color: Colors.blue,),
                      hintText:"Search here by title  :",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0,style: BorderStyle.solid),
                      ),
                    ),
                    onChanged: (value){
                      //capitalizedValue=value.toUpperCase();
                      initSearch(value);
                    },

                  ),
                ),
                SizedBox(height: height*0.01,),
                Container(
                  color: Colors.white,
                  width: width * 0.92,
                  height: height * 0.1,
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: Colors.blue,
                    ),

                    title: Container(
                      width: 250.0,
                      child: DropdownButton(
                        value: this.selectedCity,
                        hint: Text("City : ",
                          style: TextStyle(color: Colors.pink),),
                        items: [

                          DropdownMenuItem(
                            child: Row(
                              children: [
                                SizedBox(width: 2.0,),
                                Text("Irbid"),
                              ],
                            ),
                            value: "Irbid",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Amman"),
                              ],
                            ),
                            value: "Amman",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Zarga"),
                              ],
                            ),
                            value: "Zarga",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Jarash"),
                              ],
                            ),
                            value: "Jarash",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Salt"),
                              ],
                            ),
                            value: "Salt",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Ajloun"),
                              ],
                            ),
                            value: "Ajloun",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Aqaba"),
                              ],
                            ),
                            value: "Aqaba",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Madaba"),
                              ],
                            ),
                            value: "Madaba",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Mafraq"),
                              ],
                            ),
                            value: "Mafraq",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                // Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Karak"),
                              ],
                            ),
                            value: "Karak",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Ma`an"),
                              ],
                            ),
                            value: "Ma`an",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Tafila"),
                              ],
                            ),
                            value: "Tafila",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                SizedBox(width: 2.0,),
                                Text("choice city :"),
                              ],
                            ),
                            value: "choice city :",
                          ),
                        ],
                        onChanged: (String value) {
                          city = value;
                          setState(() {
                            this.selectedCity = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height*0.01,),

                Container(
                  color: Colors.white70,
                  width: width * 0.92,
                  height: height * 0.1,
                  child: ListTile(
                    leading: Icon(
                      Icons.category,
                      color: Colors.blue,
                    ),
                    title: Container(
                      width: 250.0,
                      child: DropdownButton(
                        value: this.selectedCategory,
                        hint: Text("Category : ",
                          style: TextStyle(color: Colors.pink),),
                        items: [
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                //Icon(Icons.logout),
                                SizedBox(width: 2.0,),
                                Text("Science"),
                              ],
                            ),
                            value: "Science",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Tawjihi"),
                              ],
                            ),
                            value: "Tawjihi",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                //Icon(Icons.favorite_border_outlined,color:Colors.red),
                                SizedBox(width: 2.0,),
                                Text("Novels"),
                              ],
                            ),
                            value: "Novels",
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                SizedBox(width: 2.0,),
                                Text("choice category :"),
                              ],
                            ),
                            value: "choice category :",
                          ),
                        ],
                        onChanged: (String value) {
                          category = value;
                          setState(() {
                            this.selectedCategory = value;
                          });
                        },


                      ),

                    ),
                  ),
                ),




                SizedBox(height: height*0.01,),

                SizedBox(height:height*0.001),
                Container(
                  width: width*4.0,
                  height:height*0.66,
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    slivers: [
                     StreamBuilder<QuerySnapshot>(
                        stream:documnetList,
                        builder: (context, dataSnapShot) {
                          return !dataSnapShot.hasData
                              ? SliverToBoxAdapter(
                            child:Center(child:
                            Text("There are no books",
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
          bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.Profile),

        ),
      ),
    );
  }
}