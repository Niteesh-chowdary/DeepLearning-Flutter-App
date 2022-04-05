import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:hello_mnist/DL_model/classifier.dart';

class uploadImage extends StatefulWidget {
  const uploadImage({Key? key}) : super(key: key);

  @override
  State<uploadImage> createState() => _uploadImageState();
}

class _uploadImageState extends State<uploadImage> {
  final picker = ImagePicker();
  int digit = -1;
  Classifier classifier = Classifier();
  late PickedFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[210],
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            child: Icon(Icons.camera_alt_outlined),
            onPressed: () async {

              image = await (picker.getImage(source: ImageSource.camera)) ;
              digit = await classifier.classifyImage(image);
              setState(() {

              });
            },
          ),
          SizedBox(height: 15,),
          FloatingActionButton(
            backgroundColor: Colors.black,
            child: Icon(Icons.add_photo_alternate ),
            onPressed: () async{
              image = await picker.getImage(source: ImageSource.gallery) ;
              digit = await classifier.classifyImage(image);
              setState((){
              });
            },
          ),
        ],
      ),
      appBar: AppBar(backgroundColor: Colors.blue,
      title: Text("Digit Recogniser")),
      body: Center(
        child:Column(
        children:[
          SizedBox(height: 40,),
          Text("Upload a digit Image",style: TextStyle(fontSize: 18)),
          SizedBox(height: 10,),
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black,width: 2.0),
              image: DecorationImage(
                image: digit !=-1 ? FileImage(File(image.path)) : AssetImage("assets/white backg.jpg") as ImageProvider,
                fit: BoxFit.fill,
              )
            ),
          ),
          SizedBox(height: 45,),
          Text("Prediction: ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          SizedBox(height:20),
          Text(
          digit == - 1 ? "" : "$digit",
          style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),)
        ]
      ),
      )
    );
  }
}
