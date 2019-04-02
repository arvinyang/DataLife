import 'package:flutter/material.dart';
import 'dart:async';
import 'bottom_appBar_demo.dart';


void main() async{
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomAppBarDemo(),
    );
  }
}

