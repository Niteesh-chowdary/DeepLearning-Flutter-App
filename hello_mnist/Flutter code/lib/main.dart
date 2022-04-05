// @dart=2.9
import 'package:flutter/material.dart';
import 'package:hello_mnist/Pages/upload_page.dart';
import 'package:hello_mnist/Pages/draw_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List tabs = [
    uploadImage(),
    DrawPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.image),
          label: "Image"),
          BottomNavigationBarItem(icon: Icon(Icons.album),
              label: "Draw"),
        ],
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

