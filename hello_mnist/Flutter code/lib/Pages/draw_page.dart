import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:hello_mnist/DL_model/classifier.dart';
import 'package:image/image.dart';


class DrawPage extends StatefulWidget {

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  Classifier classifier = Classifier();
  List<Offset> points = List<Offset>.empty(growable: true);
  int digit = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[210],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.close),
        onPressed: () {
          points.clear();
          digit = -1;
          setState(() {

          });
        },
      ),
      appBar: AppBar(backgroundColor: Colors.blue,
      title: Text("Digit Recogniser")),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40,),
            Text("Draw a digit inside the box",style: TextStyle(fontSize: 20)),
            SizedBox(height: 10,),
            Container(
              height: 300+2*2.0,
              width: 300+2*2.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black,width: 2.0)
              ),
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details){
                  Offset localPosition = details.localPosition;
                  setState(() {
                    if(localPosition.dx>=0 && localPosition.dx<300 &&
                    localPosition.dy>=0 && localPosition.dy<300) {
                      points.add(localPosition);
                    }
                  });
                },
                onPanEnd: (DragEndDetails details) async{
                  points.add(Offset.infinite);
                  digit = await classifier.classifyDrawing(points);
                  setState(() {

                  });
                },
                child: CustomPaint(
                  painter: Painter(points),
                ),
              ),
            ),
            SizedBox(height: 45,),
            Text("Prediction: ",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            SizedBox(height:20),
            Text(
              digit != -1 ? "$digit" : "",
              style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}

class Painter extends CustomPainter{
  List<Offset> points = List<Offset>.empty();

  Painter(List<Offset> points){
    this.points = points;
  }
  final Paint paintDetails = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0
    ..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    for(int i=0;i<points.length-1;i++){
      if(points[i] != Offset.infinite && points[i+1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paintDetails);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
