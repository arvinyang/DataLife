import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'isolate_file_operation.dart';
import 'file_pperation.dart';
import 'http_dio.dart';

//一个普普通通的Flutter应用的入口
//main函数这里有async关键字，是因为创建的isolate是异步的

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncFibonacci(NoteDataList noteList) async{
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  await Isolate.spawn(_isolate,response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  dynamic msg = await sendReceive(sendPort, noteList);
  //sendPort.send([noteList,answer.sendPort]);
  //获得数据并返回
  return answer.first;
}


Future sendReceive(SendPort port, NoteDataList msg) {
  ReceivePort response = new ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}

//创建isolate必须要的参数
void _isolate(SendPort initialReplyTo){
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((dynamic message){
    //获取数据并解析
    final data = message[0] as NoteDataList;
    final send = message[1] as SendPort;
    //返回结果
    send.send(executeIsolate(data));
  });
}
Future<NoteDataList> executeIsolate(NoteDataList noteList) async{
  int cnt =0;
  SyncNoteList syncnotelist = SyncNoteList(noteList);
  return await syncnotelist.syncAll(); 
/*   syncnotelist.myfile.readFromLocalFile().then((onValue){
      syncnotelist.syncAll();
    }); */
}
class SyncNoteList{
  IsolateFileOperation myfile;
  NoteDataList syscNoteList;
  SyncNoteList(NoteDataList noteList){
    syscNoteList = noteList;
  }
  Future<NoteDataList> syncAll() async{
    //等待读取文件完成
    while(true){
      if(true)
      {
        //TODO 设备发现
      }
      if(syscNoteList == null || syscNoteList.noteList.length == 0)
      {
        sleep(Duration(milliseconds: 5000));;
        continue;
      }
      else{
        break;
      }
    }
    int cnt = 0;
    HttpDio httpTest = new HttpDio();
    for (NoteData item in syscNoteList.noteList)
    {
      String response = await httpTest.postNoteList(item.toJson()).then(
        (response){
          debugPrint('cnt:$cnt, response:$response');
          if(response != 'failed'){
            item.postID = response;
          }
        }
      );
      cnt ++;
    }
    debugPrint('SyncNoteList OK! Total:$cnt');
    return syscNoteList;
  }
}