


import 'dart:convert';
import 'dart:convert';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/DialogBox/errorDialog.dart';
import 'package:gradproject/Models/Book.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/SciencePage.dart';
import 'package:gradproject/Widgets/CustomBottomNavBar.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/loadingWidget.dart';
import 'package:gradproject/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as ImD;
import 'package:intl/intl.dart';











class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}



class _UploadPageState extends State<UploadPage> //with AutomaticKeepAliveClientMixin<UploadPage>
{

  var downloadUrl=new List(5);
  int imageSelector;
 // bool get wantKeepAlive => true;
  File file;
  File file1;
  File file2;
  File file3;
  File file4;
  TextEditingController _descriptiontextEditingController = TextEditingController();
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _statustextEditingController = TextEditingController();

  String city ="";
  String purpose="";
  String category="";
  String selectedCity="choice city :";
  String selectedCategory="choice category :";
  String selectedPurpose="choice purpose :";


  String bookId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return file == null ? displayUserHomeScreen() : displayUserUploadScreen(screenSize);
  }

  displayUserHomeScreen() {
    return WillPopScope(
      onWillPop: (){Navigator.pop(context);},
      child: Scaffold(
      appBar: MyAppBar(),//AppBar(
        //   flexibleSpace: Container(
        //     decoration: new BoxDecoration(
        //       color: Colors.white,
        //     ),
        //   ),
        //   leading: IconButton(
        //       icon: Icon(
        //         Icons.arrow_back,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         Route route = MaterialPageRoute(builder: (c) => Home());
        //         Navigator.pushReplacement(context, route);
        //       }),
        // ),
        body: getUserHomeScreenBody(),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.Upload),

      ),
    );
  }

  getUserHomeScreenBody() {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              color: Color(0xff122636),
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                child: Text(
                  "Upload New Book",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Color(0xff122636),
                onPressed: () {
                  imageSelector=0;
                  return takeImage(context,imageSelector);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext,int imageSelector) {
    return showDialog(
      context: mContext,
      builder: (con) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xff122636), width: 4),
            borderRadius: BorderRadius.circular(150),
          ),
          title: Center(
            child: Text(
              "item Image :",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          children: [
            SimpleDialogOption(
              child: Center(
                child: Text("Capture With Camera",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              onPressed:()=> capturePhotoWithCamera(imageSelector),
            ),
            SimpleDialogOption(
              child: Center(
                child: Text("Select From Gallery",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              onPressed: ()=>pickPhotoFromGallery(imageSelector),
            ),
            SimpleDialogOption(
              child: Center(
                child: Text("Cancel",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  capturePhotoWithCamera(int imageSelector) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      switch(imageSelector)
      {
        case 0:
          file = imageFile;
          break;

        case 1:
          file1 = imageFile;
          break;

        case 2:
          file2 = imageFile;
          break;

        case 3:
          file3 = imageFile;
          break;

        case 4:
          file4 = imageFile;
          break;
      }
    });
  }

  pickPhotoFromGallery(int imageSelector) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
     switch(imageSelector)
     {
       case 0:
       file = imageFile;
       break;

       case 1:
         file1 = imageFile;
         break;

         case 2:
          file2 = imageFile;
          break;

          case 3:
          file3 = imageFile;
          break;

            case 4:
            file4 = imageFile;
            break;
     }
    });
  }

  displayUserUploadScreen(Size screenSize) {
    return WillPopScope(
      onWillPop: (){Navigator.pop(context);},
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
             color: Color(0xff122636),
            ),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: clearFormInfo),
          title: Center(
            child: Text(
              "New Book ",
              style: TextStyle(
                  color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            FlatButton(
              onPressed: uploading?  null : () => uploadImageAndSaveItemInfo(),
              child: Text(
                "Add",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        body: ListView(
          children: [

            Container(
              height: 230.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file), fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap:(){
                    imageSelector=1;
                    return takeImage(context,imageSelector);
                  },
                  child: CircleAvatar(
                    radius: screenSize.width * 0.1,
                    backgroundColor: Colors.white,
                    backgroundImage: file1 == null?null:FileImage(file1),
                    child: file1 == null ? Icon(Icons.add_a_photo_outlined,
                      size: screenSize.width * 0.1,
                      color: Color(0xff122636),
                    ) : null,
                  ),
                ),
                SizedBox(width: screenSize.width*0.05,),

                InkWell(
                  onTap:(){

                    imageSelector=2;
                    return takeImage(context,imageSelector);
                  },
                  child: CircleAvatar(
                    radius: screenSize.width * 0.1,
                    backgroundColor: Colors.white,
                    backgroundImage: file2 == null?null:FileImage(file2),
                    child: file2 == null ? Icon(Icons.add_a_photo_outlined,
                      size: screenSize.width * 0.1,
                      color: Color(0xff122636),
                    ) : null,
                  ),
                ),
                SizedBox(width: screenSize.width*0.05,),

                InkWell(
                  onTap:(){
                    imageSelector=3;
                    return takeImage(context,imageSelector);
                  },
                  child: CircleAvatar(
                    radius: screenSize.width * 0.1,
                    backgroundColor: Colors.white,
                    backgroundImage: file3 == null?null:FileImage(file3),
                    child: file3 == null ? Icon(Icons.add_a_photo_outlined,
                      size: screenSize.width * 0.1,
                      color: Color(0xff122636),
                    ) : null,
                  ),
                ),
                SizedBox(width: screenSize.width*0.05,),

                InkWell(
                  onTap:(){
                    imageSelector=4;
                    return takeImage(context,imageSelector);
                  },
                  child: CircleAvatar(
                    radius: screenSize.width * 0.1,
                    backgroundColor: Colors.white,
                    backgroundImage: file4 == null?null:FileImage(file4),
                    child: file4 == null ? Icon(Icons.add_a_photo_outlined,
                      size: screenSize.width * 0.1,
                      color: Color(0xff122636),
                    ) : null,
                  ),
                ),


              ],
            ),



            Divider(
              color: Color(0xff122636),
            ),

            Padding(
              padding: EdgeInsets.only(top: 12.0),
            ),
            ListTile(
              leading: Icon(
                Icons.bookmark,
                color: Color(0xff122636),
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _titletextEditingController,
                  decoration: InputDecoration(
                      hintText: "Title : ",
                      hintStyle: TextStyle(
                        color: Colors.deepOrangeAccent,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
            Divider(
              color: Colors.pink,
            ),
            ListTile(
              leading: Icon(
                Icons.description_outlined,
                color: Colors.pink,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _descriptiontextEditingController,
                  decoration: InputDecoration(
                      hintText: "Description : ",
                      hintStyle: TextStyle(
                        color: Colors.deepOrangeAccent,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
            uploading ? circularProgress() : Text(""),

            Divider(
              color: Colors.pink,
            ),
            ListTile(
              leading: Icon(
                Icons.high_quality_sharp,
                color: Colors.pink,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _statustextEditingController,
                  decoration: InputDecoration(
                      hintText: "Status (New,Used) :",
                      hintStyle: TextStyle(
                        color: Colors.deepOrangeAccent,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
            Divider(
              color: Colors.pink,
            ),
            ListTile(
              leading: Icon(
                Icons.money,
                color: Colors.pink,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _pricetextEditingController,
                  decoration: InputDecoration(
                      hintText: "Price : ",
                      hintStyle: TextStyle(
                        color: Colors.deepOrangeAccent,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
            Divider(
              color: Colors.pink,
            ),
            ListTile(
              leading: Icon(
                Icons.location_on_outlined,
                color: Colors.pink,
              ),

              title: Container(
                width: 250.0,
                child:   DropdownButton(
                  value: this.selectedCity,
                  hint: Text("City : " ,style: TextStyle(color: Colors.pink),),
                  items:[

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
                  onChanged:(String value){
                  city=value;
                  setState(() {this.selectedCity=value;});
                  },
                ),
              ),
            ),
            Divider(
              color: Colors.pink,
            ),
            ListTile(
              leading: Icon(
                Icons.category,
                color: Colors.pink,
              ),
              title: Container(
                width: 250.0,
                child:   DropdownButton(
                  value: this.selectedCategory,
                  hint: Text("Category : " ,style: TextStyle(color: Colors.pink),),
                  items:[
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
                  onChanged: (String value){
                    category=value;
                    setState(() {
                      this.selectedCategory=value;
                    });
                  },




                ),

              ),
            ),
            Divider(
              color: Colors.pink,
            ),
            ListTile(
              leading: Icon(
                Icons.link,
                color: Colors.pink,
              ),

              title: Container(
                width: 250.0,
                child:   DropdownButton(
                  value: this.selectedPurpose,
                  hint: Text("purpose : " ,style: TextStyle(color: Colors.pink),),
                  items:[
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          //Icon(Icons.logout),
                          SizedBox(width: 2.0,),
                          Text("Sale"),
                        ],
                      ),
                      value: "Sale",
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                          SizedBox(width: 2.0,),
                          Text("Donation or Exchange"),
                        ],
                      ),
                      value: "Donation or Exchange",
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                          SizedBox(width: 2.0,),
                          Text("Donation"),
                        ],
                      ),
                      value: "Donation",
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                          SizedBox(width: 2.0,),
                          Text("Exchange"),
                        ],
                      ),
                      value: "Exchange",
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          //Icon(Icons.favorite_border_outlined,color:Colors.red),
                          SizedBox(width: 2.0,),
                          Text("Sale or Exchange "),
                        ],
                      ),
                      value: "Sale or Exchange",
                    ),
                    DropdownMenuItem(
                      child: Row(
                        children: [
                          SizedBox(width: 2.0,),
                          Text("choice purpose :"),
                        ],
                      ),
                      value: "choice purpose :",
                    ),
                  ],
                  onChanged: (String value){
                    purpose=value;
                    setState(() {
                      this.selectedPurpose=value;
                    });
                  },




                ),

              ),
            ),





          ],
        ),
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptiontextEditingController.clear();
      _pricetextEditingController.clear();
      _statustextEditingController.clear();
      _titletextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async
  {
    if(_titletextEditingController.text.isNotEmpty &&
        _descriptiontextEditingController.text.isNotEmpty &&
        _statustextEditingController.text.isNotEmpty &&
        _pricetextEditingController.text.isNotEmpty&&
        category.isNotEmpty&& city.isNotEmpty && purpose.isNotEmpty
    )
    {
      setState(() {uploading = true;});


      print("before file,file1,file2,file3,file4.............................................................");

      await  uploadBookImage(file,file1,file2,file3,file4);
      print("after file,file1,file2,file3,file4.............................................................");

      saveBookInfo();

    }
    else
      {
        displayDialog("Please fill up the Data Book ..");
      }
  }
   uploadBookImage(File image,File image1,File image2,File image3,File image4) async
  {

    final  StorageReference storageReference =FirebaseStorage.instance.ref().child("Books");

    print("image0.............................................................");
    StorageUploadTask uploadTask = storageReference.child("product_$bookId 0.jpg").putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
     downloadUrl[0] = await taskSnapshot.ref.getDownloadURL();

    if(image1!=null)
      {
        print("image1.............................................................");

        StorageUploadTask uploadTask1 = storageReference.child("product_$bookId 1.jpg").putFile(image1);
        StorageTaskSnapshot taskSnapshot1 = await uploadTask1.onComplete;
         downloadUrl[1] = await taskSnapshot1.ref.getDownloadURL();
      }
    else
      {downloadUrl[1]='https://firebasestorage.googleapis.com/v0/b/gradproject-5d48e.appspot.com/o/Items%2Fdownload.png?alt=media&token=d9c9dbf1-06b7-4e18-89fb-2f420a424a62';
      }
    if(image2!=null)
    {    print("image2.............................................................");
    StorageUploadTask uploadTask2 = storageReference.child("product_$bookId 2.jpg").putFile(image2);
      StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;
       downloadUrl[2] = await taskSnapshot2.ref.getDownloadURL();
    }
    else
      {
        downloadUrl[2]='https://firebasestorage.googleapis.com/v0/b/gradproject-5d48e.appspot.com/o/Items%2Fdownload.png?alt=media&token=d9c9dbf1-06b7-4e18-89fb-2f420a424a62';
      }

    if(image3!=null)
    {    print("image3.............................................................");

    StorageUploadTask uploadTask3 = storageReference.child("product_$bookId 3.jpg").putFile(image3);
      StorageTaskSnapshot taskSnapshot3 = await uploadTask3.onComplete;
       downloadUrl[3] = await taskSnapshot3.ref.getDownloadURL();
    }
    else
      {
        downloadUrl[3] = 'https://firebasestorage.googleapis.com/v0/b/gradproject-5d48e.appspot.com/o/Items%2Fdownload.png?alt=media&token=d9c9dbf1-06b7-4e18-89fb-2f420a424a62';
      }

      if (image4 != null) {
        print(
            "image4.............................................................");

        StorageUploadTask uploadTask4 = storageReference.child("product_$bookId 4.jpg").putFile(image4);
        StorageTaskSnapshot taskSnapshot4 = await uploadTask4.onComplete;
        downloadUrl[4] = await taskSnapshot4.ref.getDownloadURL();
      }
      else
        {
          downloadUrl[4] = 'https://firebasestorage.googleapis.com/v0/b/gradproject-5d48e.appspot.com/o/Items%2Fdownload.png?alt=media&token=d9c9dbf1-06b7-4e18-89fb-2f420a424a62';
        }


        for (int i = 0; i < downloadUrl.length; i++)
          print(downloadUrl[i]);

    }

  saveBookInfo() async {
    final itemsRef = Firestore.instance.collection("Books");
    itemsRef.document(bookId).setData({
      "status" : _statustextEditingController.text.trim(),
      "description" : _descriptiontextEditingController.text.trim(),
      "price" : int.parse(_pricetextEditingController.text),
      "publishedDate" : DateTime.now(),
      //"DateForUser":
      "thumbnailUrl" : downloadUrl,
      "title" : _titletextEditingController.text.toUpperCase().trim(),
      "city" : city,
      "phoneNumber":BookStore.sharedPreferences.getString(BookStore.phoneNumber),
      "category" : category,
      "bookId":bookId,
      "purpose":purpose,
      "uid":  BookStore.sharedPreferences.getString(BookStore.userUID),
    "caseSearch": setSearchParam(_titletextEditingController.text.toUpperCase()),
    });

    setState(() {
      file = null;
      uploading =false;
      bookId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontextEditingController.clear();
      _titletextEditingController.clear();
      _statustextEditingController.clear();
      _pricetextEditingController.clear();
      //_citytextEditingController.clear();
    });
    Route route = MaterialPageRoute(builder: (c) => Home());
    Navigator.pushReplacement(context, route);
  }


  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }




}