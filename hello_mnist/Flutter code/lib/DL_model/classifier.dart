import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io' as io;
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

class Classifier{
  Classifier();

  classifyImage(PickedFile image) async{
    var _file = io.File(image.path);
    img.Image imageTemp = img.decodeImage(_file.readAsBytesSync());
    img.Image resizedImg = img.copyResize(imageTemp,
    height: 28,width: 28);
    var imgBytes = resizedImg.getBytes();
    var imgAsList = imgBytes.buffer.asUint8List();

    return getPrediction(imgAsList);
  }

  Future<int> getPrediction(Uint8List imageAsList) async{
    List resultBytes = List.filled(28*28, null, growable: false);

    int index = 0;
    for(int i=0;i < imageAsList.lengthInBytes;i+=4){
      final r = imageAsList[i];
      final g = imageAsList[i+1];
      final b = imageAsList[i+2];
      resultBytes[index] = ((r+g+b)/3.0)/255.0;
      index++;
    }
    var input = resultBytes.reshape([1,28,28,1]);
    var output = List.filled(1*10, null,growable: false).reshape([1,10]);


    try{
      Interpreter interpreter = await Interpreter.fromAsset("model.tflite");
      interpreter.run(input, output);
    }
    catch(e){
      print("Error loading model or Loading model");
    }
    double highProbability = 0;
    int prediction = -1;

    for(int i=0;i<output[0].length;i++){
      if(output[0][i]>highProbability){
        highProbability = output[0][i];
        prediction = i;
      }
    }
    return prediction;
  }
  classifyDrawing(List<Offset> points) async{
    final picture = toPicture(points);
    final image = await picture.toImage(28,28);
    var imgBytes = await image.toByteData();
    var imgAsList = imgBytes?.buffer.asUint8List();
    
    return getPrediction(imgAsList!);
  }
}
ui.Picture toPicture(List<Offset> points){
  final _whitePaint = Paint()
    ..strokeCap = StrokeCap.round
    ..color = Colors.white
    ..strokeWidth = 16.0;

  final _bgPaint = Paint()..color = Colors.black;
  final _canvasCullRect = Rect.fromPoints(Offset(0,0),Offset(28.toDouble(),28.toDouble()));
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder,_canvasCullRect)
    ..scale(28/300);

  canvas.drawRect(Rect.fromLTWH(0, 0, 28, 28), _bgPaint);

  for(int i =0;i<points.length-1;i++){
    if(points[i] != Offset.infinite && points[i+1] != Offset.infinite){
      canvas.drawLine(points[i], points[i+1], _whitePaint);
    }
  }
  return recorder.endRecording();
}