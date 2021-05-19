import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/Config/config.dart';
import 'package:gradproject/Models/BookPdf.dart';
import 'package:gradproject/Store/Home.dart';
import 'package:gradproject/Store/pdfUpload.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/myDrawer.dart';
import 'package:permission_handler/permission_handler.dart';

class pdfFiles extends StatefulWidget {
  @override
  pdfFilesState createState() => pdfFilesState();
}

class pdfFilesState extends State<pdfFiles> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }
  @override
  Widget build(BuildContext context)
  {

    Size screenSize= MediaQuery.of(context).size;
    //  width = MediaQuery.of(context).size.width;
    // height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: WillPopScope(
        onWillPop: (){Navigator.pop(context);},
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: MyAppBar(),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
            child: MyDrawer(),),
          body: Column(
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
                        text: "Welcome To PDF Books",
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
                          .collection("BookPdf").snapshots(),
                      builder: (context, dataSnapShot) {
                        return !dataSnapShot.hasData
                            ? SliverToBoxAdapter(
                          child:Center(child: Text("There are no PDF books",style: TextStyle(fontSize: 25,color: Colors.redAccent),)),
                        )
                            : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            BookPdf model = BookPdf.fromJson(
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff122636),
            onPressed:(){
              Route route = MaterialPageRoute(builder: (c)=> pdfUpload() );
              Navigator.push(context, route);

            },
            child: Icon(Icons.library_add),
          ),

        ),
      ),
    );
  }

void getPermission() async {
  print("getPermission");
  await PermissionHandler().requestPermissions([PermissionGroup.storage]);
}

}






Widget sourceInfo(BookPdf book, BuildContext context) {

  var dio=Dio();
  Size sizeScreen= MediaQuery.of(context).size;
  return Padding(
    padding: EdgeInsets.only(right: (20 / 375.0)*sizeScreen.width ,left:(10 / 375.0)*sizeScreen.width),//(40 / 375.0)*sizeScreen.height
    child: SizedBox(
      height:sizeScreen.height*.6,
      child: GestureDetector(
        onTap: () async {


          String path =
              await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS);
          String fullPath = "$path/${book.name}.pdf";


          print("herererere................................................................................................");
            download2(dio, book.pdfUrl, fullPath);




        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.19,
              child: Container(
                padding: EdgeInsets.all((20 / 375.0)*sizeScreen.width),
                decoration: BoxDecoration(
                  color: Color(0xff122636),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(book.urlPicture),
              ),
            ),
            //const SizedBox(height:3),
            Flexible(
              child: Text(
                book.name,
                //overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xff122636)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    book.publisher,
                    style: TextStyle(
                      fontSize: (18 / 375.0)*sizeScreen.width,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {print("hi");},
                  child: Container(
                    padding: EdgeInsets.all((8 / 375.0)*sizeScreen.width),
                    height: (38 / 375.0)*sizeScreen.width,
                    width: (38 / 375.0)*sizeScreen.width,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      // ? Colors.black.withOpacity(0.15)
                      // : Color(0xFF979797).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.favorite_outlined,color: Colors.white,),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    ),
  );




}



Future download2(Dio dio, String url, String savePath) async {
  //get pdf from link
  Response response = await dio.get(
    url,
    onReceiveProgress: showDownloadProgress,
    //Received data with List<int>
    options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        }),
  );

  //write in download folder
  File file = File(savePath);
  var raf = file.openSync(mode:FileMode.write);
  raf.writeFromSync(response.data);
  await raf.close();
}
showDownloadProgress(received,total)
{

  if (total != -1) {
    String s1=((received / total * 100).toStringAsFixed(0) + "%");

    if(s1=="100%")
  Fluttertoast.showToast(
    msg: "it\'s Downloaded",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    //timeInSecForIosWeb: 1,
    backgroundColor: Colors.lightBlueAccent,
    textColor: Colors.white,
    fontSize: 16.0,
  );


  }


}




