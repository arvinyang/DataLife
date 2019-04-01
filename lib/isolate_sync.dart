import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'isolate_file_operation.dart';
import 'file_pperation.dart';
import 'http_dio.dart';

//创建isolate必须要的参数
void _isolate(SendPort initialReplyTo){
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((dynamic message)async{
    //获取数据并解析
    final data = message[0] as NoteDataList;
    final send = message[1] as SendPort;
    //返回结果
    dynamic tmpRst = await executeIsolate(data);
    send.send(tmpRst);
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

class AsyncIsolate{
  static ReceivePort response = null;
  static SendPort sendPort = null;

  //一个普普通通的Flutter应用的入口
  Future<dynamic> asyncIsolateInit() async{
    //首先创建一个ReceivePort，为什么要创建这个？
    //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
    //final response = new ReceivePort();
    //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
    //_isolate是创建isolate必须要的参数。
    response ??= new ReceivePort();
    await Isolate.spawn(_isolate,response.sendPort);
    //获取sendPort来发送数据
    sendPort ??= await response.first as SendPort;

    //发送数据
    //dynamic msg = await sendReceive(sendPort, noteList);
    //获得数据并返回
    //return msg;
  }
  //给创建的isolate发送命令，完成指定任务
  static Future asyncExcute(SendPort port, NoteDataList msg) {
    if(port == null)
    {
      debugPrint('sendPort need to initial');
      return null;
    }
    ReceivePort localResponse = new ReceivePort();
    port.send([msg, localResponse.sendPort]);
    return localResponse.first;
  }
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