import 'package:flutter/material.dart';
import 'dart:async';
import 'bottom_appBar_demo.dart';
import 'isolate_sync.dart';
import 'file_pperation.dart';

void main() async{
  runApp(new MyApp());
  FileOperation myfile;
  debugPrint('main:');
  if(myfile==null || FileOperation.noteDataList!=null){
          myfile= new FileOperation();
    }
    // 关键的读取文件的步骤
    myfile.readFromLocalFile().then((onValue)async{
      dynamic rstList = await asyncFibonacci(FileOperation.noteDataList);
      print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:$rstList');
    });
  debugPrint('sync OK!');
 
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

