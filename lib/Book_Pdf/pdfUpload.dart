import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/Config/config.dart';
import 'file:///D:/GradProject/lib/Book_Pdf/pdfFiles.dart';
import 'package:gradproject/Widgets/customAppBar.dart';
import 'package:gradproject/Widgets/customTextField.dart';
import 'package:gradproject/Widgets/myDrawer.dart';

class pdfUpload extends StatefulWidget {


  @override
  _pdfUploadState createState() => _pdfUploadState();
}

class _pdfUploadState extends State<pdfUpload> {
  final TextEditingController _nametextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child:Scaffold(
        appBar: MyAppBar(),
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(44), bottomRight: Radius.circular(44)),
          child: MyDrawer(),),
        body:  SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * 0.09,
              ),
              SizedBox(
                height: screenSize.height * 0.09,
              ),
              CustomTextField(
                data: Icons.drive_file_rename_outline,
                hintText: "write name of pdf:",
                specifer: 1,
                isObsecure: false,
                controller:_nametextEditingController,
              ),
              SizedBox(
                height: screenSize.height * 0.09,
              ),

              ElevatedButton(
                onPressed: () {
                    uploadPdfBook();

                },
                style: OutlinedButton.styleFrom(
                  elevation: 9,
                  backgroundColor: Colors.lightBlueAccent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'upload pdf',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );




  }


  uploadPdfBook() async {
    String pdfID = DateTime.now().microsecondsSinceEpoch.toString();

    print("zero function....................................");


    File file=await FilePicker.getFile(type: FileType.any);
    print("zero 1 function....................................");

    String fileName="$pdfID.PDF";
    print("z\ero 2 function....................................");

    savePDF(file,fileName);



  }


  void savePDF(File file, String fileName) async {
    print("first function....................................");

    final  StorageReference storageReference =FirebaseStorage.instance.ref().child("PDFBooks");
    print("pdf file.. before...........................................................");
    StorageUploadTask uploadTask = storageReference.child("pdfBook_$fileName .pdf").putFile(file);
    print("pdf file....... after............................................");

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    print("first after.......... url....................................");
    String url=await taskSnapshot.ref.getDownloadURL();

    documentFileUpload(url,fileName);

  }

  void documentFileUpload(String url,String name) {
    print("seconad function....................................");

    Firestore.instance.collection("BookPdf").document(name).setData({
      "urlPicture":"https://firebasestorage.googleapis.com/v0/b/gradproject-5d48e.appspot.com/o/Items%2Fdigital-book-logo.jpg?alt=media&token=1fe3a373-4de2-4d21-829d-8147df43a933",
      "urlPdf":url,
      'publisher':BookStore.sharedPreferences.getString(BookStore.userName),
      "name":_nametextEditingController.text,
      "uid":BookStore.sharedPreferences.getString(BookStore.userUID),
    }).then((value) {print("book pdf uploaded................");});

    _nametextEditingController.clear();
    Route route = MaterialPageRoute(builder: (c)=> pdfFiles() );
    Navigator.pushReplacement(context, route);

  }





}