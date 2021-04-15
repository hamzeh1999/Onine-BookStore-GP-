import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/SciencePage.dart';
import 'package:gradproject/Widgets/loadingWidget.dart';
import 'package:gradproject/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptiontextEditingController =
      TextEditingController();
  TextEditingController _pricetextEditingController = TextEditingController();
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _citytextEditingController = TextEditingController();
  TextEditingController _shortinfotextEditingController = TextEditingController();
  String city ="";
   String category="";


  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
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
        leading: IconButton(
            icon: Icon(
              Icons.border_color,
              color: Colors.white,
            ),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            }),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: Colors.pink,

            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => Home());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.pink, Colors.lightGreenAccent],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                child: Text(
                  "Upload New Item",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () => takeimage(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  takeimage(mContext) {
    return showDialog(
      context: mContext,
      builder: (con) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.lightGreen, width: 4),
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "item Image",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              child: Text("Capture With Camera",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: caputrePhotoWithCamera,
            ),
            SimpleDialogOption(
              child: Text("Select From Gallery",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: pickPhotoFromGallery,
            ),
            SimpleDialogOption(
              child: Text("Cancel",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  caputrePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      file = imageFile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = imageFile;
    });
  }

  displayAdminUploadScreen() {
    return Scaffold(
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
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: clearForminfo),
        title: Text(
          "New Product ",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          FlatButton(
            onPressed: uploading?  null : () => uploadImageAndSaveItemInfo(),
            child: Text(
              "Add",
              style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
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
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: Icon(
              Icons.book_online_outlined,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortinfotextEditingController,
                decoration: InputDecoration(
                    hintText: "Short Info",
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
              Icons.bookmark,
              color: Colors.pink,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titletextEditingController,
                decoration: InputDecoration(
                    hintText: "Title",
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
                    hintText: "Description",
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
                    hintText: "Price",
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
              Icons.category,
              color: Colors.pink,
            ),

            title: Container(
              width: 250.0,
              child:   DropdownButton(
                hint: Text("City" ,style: TextStyle(color: Colors.pink),),
                items:[
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        SizedBox(width: 2.0,),
                        Text("Irbid"),
                      ],
                    ),
                    value: " Irbid",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Amman"),
                      ],
                    ),
                    value: "Amman",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Zarga"),
                      ],
                    ),
                    value: "Zarga",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Jarash"),
                      ],
                    ),
                    value: "Jarash",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Salt"),
                      ],
                    ),
                    value: "Salt",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Ajloun"),
                      ],
                    ),
                    value: "Ajloun",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Aqaba"),
                      ],
                    ),
                    value: "Aqaba",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Madaba"),
                      ],
                    ),
                    value: "Madaba",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Mafraq"),
                      ],
                    ),
                    value: "Mafraq",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Karak"),
                      ],
                    ),
                    value: "Karak",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Ma`an"),
                      ],
                    ),
                    value: "Ma`an",
                  ),
                  DropdownMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border_outlined,color:Colors.red),
                        SizedBox(width: 2.0,),
                        Text("Tafila"),
                      ],
                    ),
                    value: "Tafila",
                  ),



                ],
                onChanged: (value){
                  city=value;

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
              hint: Text("Category" ,style: TextStyle(color: Colors.pink),),
              items:[
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 2.0,),
                      Text("جامعي"),
                    ],
                  ),
                  value: " Science",
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border_outlined,color:Colors.red),
                      SizedBox(width: 2.0,),
                      Text("توجيهي"),
                    ],
                  ),
                  value: "Tawjihi",
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border_outlined,color:Colors.red),
                      SizedBox(width: 2.0,),
                      Text("روايات"),
                    ],
                  ),
                  value: "Novels",
                ),
              ],
              onChanged: (value){
                category=value;

              },



            ),

          ),
        ),
          Divider(
            color: Colors.pink,
          ),
        ],
      ),
    );
  }

  clearForminfo() {
    setState(() {
      file = null;
      _descriptiontextEditingController.clear();
      _pricetextEditingController.clear();
      _shortinfotextEditingController.clear();
      _titletextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async
  {
    setState(() {
      uploading = true ;
    });
   String ImageDownloadUrl= await uploadItemImage(file);
   saveiteminfo(ImageDownloadUrl);

  }
   Future<String> uploadItemImage(mFileImage) async
   {
     final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
     StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
     StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
     String downloadUrl = await taskSnapshot.ref.getDownloadURL();
     return downloadUrl;

  }

  saveiteminfo(String downloadUrl)
  {
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
      "shortInfo" : _shortinfotextEditingController.text.trim(),
      "longDescription" : _descriptiontextEditingController.text.trim(),
      "price" : int.parse(_pricetextEditingController.text),
      "publishedDate" : DateTime.now(),
      "status" : "available",
      "thumbnailUrl" : downloadUrl,
      "title" : _titletextEditingController.text.trim(),
      "city" : city,
      "category" : category,




    });
    setState(() {
      file = null;
      uploading =false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptiontextEditingController.clear();
      _titletextEditingController.clear();
      _shortinfotextEditingController.clear();
      _pricetextEditingController.clear();
      _citytextEditingController.clear();
    });


  }
}
