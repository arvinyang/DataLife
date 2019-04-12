
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class HttpDio{
  Dio dio;
  HttpDio(){
     dio = new Dio();
     //dio.options.baseUrl = "//192.168.1.65:5000";
  }
  Future<String> postTest() async {
    Map<String, dynamic> tmpMap = new Map<String, dynamic>();
    String timeStr = new DateTime.now().toString();
    tmpMap['postID'] = md5.convert(utf8.encode(timeStr)).toString();
    tmpMap['datetime'] = timeStr;
    tmpMap['feeling'] = 'test ! test !';
    tmpMap['weather'] = '晴天';
    tmpMap['mood'] = '开心';
    tmpMap['lat'] = 104.5773647;
    tmpMap['lgt'] = 29.7773865;
    tmpMap['tags'] = ['1个tag','2个tag'];
    tmpMap['location'] = '霉霉山';
    tmpMap['images'] = ['IMG_20190325_133435.jpg','IMG_20190325_133431.jpg'];
    tmpMap["files"] = [new UploadFileInfo(new File("/storage/emulated/0/DCIM/Camera/IMG_20190325_133435.jpg"), "IMG_20190325_133435.jpg"),
                        new UploadFileInfo(new File("/storage/emulated/0/DCIM/Camera/IMG_20190325_133431.jpg"), "IMG_20190325_133431.jpg"),];

    FormData formData = new FormData.from(tmpMap);
    //Response response = await dio.post("/push_post?id=12&name=wendu");
    Response response = await dio.post<dynamic>("http://192.168.1.65:5000/push_post",data: formData,);
    String output = response.data;
    debugPrint('postNoteList:$output');
    return response.data;
  }
  Future<String> postNoteList(Map<String, dynamic> localInfo, String srvAddr) async {
    Map<String, dynamic> tmpMap = new Map<String, dynamic>();
    Map<String, dynamic> sendMap = new Map<String, dynamic>();
    //String timeStr = new DateTime.now().toString();
    String timeStr = '"' + localInfo['datetime'];
    String postID = md5.convert(utf8.encode(timeStr)).toString();
    tmpMap['post_id'] = postID;
    tmpMap['datetime'] = localInfo['datetime'].substring(0, timeStr.lastIndexOf('.')-1);
    tmpMap['text'] = localInfo['feeling'];
    tmpMap['weather'] =  localInfo['weather'];
    tmpMap['mood'] = localInfo['mood']==null?'':localInfo['mood'];
    tmpMap['GPS_latitude'] = localInfo['lat'];
    tmpMap['GPS_longitude'] = localInfo['lgt'];
    tmpMap['tags'] = localInfo['tags']==null?['']:localInfo['tags'];;
    tmpMap['location'] = localInfo['location'];
    tmpMap['device'] = "这部手机";
   
    sendMap["image"] = List<dynamic>();
    List<String> tmpFileName = [];
    for(String item in localInfo['imagePath'])
    {
      if(item.isEmpty){
        //跳过错误路径
        continue;
      }
      //TODO 所有类型的路径考虑完了吗？
      String tmpStr = item.substring(item.lastIndexOf('/')+1, item.length);
      if(tmpStr.isEmpty){
        //跳过错误路径
        continue;
      }
      try{
        sendMap["image"].add(new UploadFileInfo(new File(item), tmpStr));
        tmpFileName.add(tmpStr);
      }catch(err)
      {
        debugPrint('postNoteList:read file error,info:$err');
      }
      tmpMap['images'] = tmpFileName;
    }
    
    String sendStr = json.encode(tmpMap);
    sendMap['post'] = sendStr;
    
    //debugPrint('sendMsg post:$sendStr');
    FormData formData = new FormData.from(sendMap);
    //Response response = await dio.post("/push_post?id=12&name=wendu");
    debugPrint('Sync Server:$srvAddr');
    try{
      Response response = await dio.post<dynamic>(srvAddr,data: formData,);
      String output = response.data;
      debugPrint('http response:$output');
      if(response.statusCode == 200)
      {
        return postID;
      }else
      {
        return 'failed';
      }
    }catch(err){
      print('http post error:$err');
      return 'failed';
    }
  }
}

