import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
  

  class FileOperation
  {
    final String fileName = 'noteData.json';
    final String fileNameList = 'noteDataList.json';
    String filePath;
    factory FileOperation() =>_getInstance();
    static FileOperation get instance => _getInstance();
    static FileOperation _instance;
    static NoteData noteData;
    static NoteDataList noteDataList;
    static File localFile;
    bool readFlag = true;

    FileOperation._internal() {
    // 初始化
    //filePath = (await getApplicationDocumentsDirectory()).path;
    noteDataList = new NoteDataList(0, [],[]);
    //noteData = new NoteData(' ',' ',' ',' ',' ',' ',[' ']);
    //readFromLocalFileList();
    }
    static FileOperation _getInstance() {
      _instance ??= new FileOperation._internal();
      return _instance;
    }
    Future<File> getLocalFile() async {
      // get the path to the document directory.
      String appDocPath = (await getApplicationDocumentsDirectory()).path;
      try{
        localFile = new File('$appDocPath/$fileNameList');
      }
      on FileSystemException {
          localFile = null;
      }
      return localFile;
    }

    Future<String> readFromLocalFile() async {
      if(readFlag){
        try {
          File file = File((await getApplicationDocumentsDirectory()).path + '/' + fileNameList);
          // read the variable as a string from the file.
          String contents = await file.readAsString();
          debugPrint('my whole file:$contents');
          if(contents.length > 0){
            Map userMap = json.decode(contents);
            noteDataList = new NoteDataList.fromJson(userMap);
            noteDataList.noteNum = noteDataList.noteList.length;
          }
          readFlag = false;
          return contents;
        } on FileSystemException {
          return "";
        }
      }
      else{
        return "";
      }
    }

    Future<Null> writeToLocalFile() async {
      // write the variable as a string to the file
      if(noteDataList.noteList.length > 0){
        String jsonStrList = json.encode(noteDataList);
        if(localFile == null){
          await getLocalFile();
        }
        try{
          localFile.writeAsString(jsonStrList);
          
        }
        on FileSystemException {
            getLocalFile();
            //read again, write again;
            if(localFile != null){
              localFile.writeAsString(jsonStrList);
            }
        }
      }
    }
  }
  
  class NoteData 
  {
    String postID;
    String noteID;
    String datetime;
    String feeling;
    String weather;
    String temperature;
    String mood;
    double lat;
    double lgt;
    String location;
    List<String> district = [];
    List<String> tags = [];
    List<String> imagePath = [];
    //final List<NoteComment> noteComment;

    NoteData(this.postID,this.noteID, this.datetime, this.feeling, this.weather, 
      this.lat,this.lgt,this.temperature, this.location, this.district, this.tags, this.imagePath);
    //NoteData(this.noteID, this.datetime, this.feeling, this.weather, this.temperature, this.location, this.imagePath, this.noteComment);

    NoteData.fromJson(Map<String, dynamic> jsonMap)
    {
        postID = jsonMap['postID'];
        noteID = jsonMap['noteID'];
        datetime = jsonMap['datetime'];
        feeling = jsonMap['feeling'];
        weather = jsonMap['weather'];
        mood = jsonMap['mood'];
        lat = jsonMap['lat'];
        lgt = jsonMap['lgt'];
        temperature = jsonMap['temperature'];
        location = jsonMap['location'];
        //clear all
        district.clear();
        tags.clear();
        imagePath.clear();
        // add 
        jsonMap['district']==null?district=['','','']:jsonMap['district'].forEach(district.add);
        jsonMap['tags']==null?tags=['','','']:jsonMap['tags'].forEach(district.add);
        //clean null image path
         for(var item in jsonMap['imagePath']){
          item == ''?null:imagePath.add(item);
        } 
        //jsonMap['imagePath'].forEach((){imagePath.add;});
        //noteComment = jsonMap['noteComment'];
    }
          
          //

    Map<String, dynamic> toJson()
    {
      Map<String, dynamic> tmpMap = new Map<String, dynamic>();

      tmpMap['postID'] = postID;
      tmpMap['noteID'] = noteID;
      tmpMap['datetime'] = datetime;
      tmpMap['feeling'] = feeling;
      tmpMap['weather'] = weather;
      tmpMap['mood'] = mood;
      tmpMap['lat'] = lat;
      tmpMap['lgt'] = lgt;
      tmpMap['temperature'] = temperature;
      tmpMap['location'] = location;
      tmpMap['district'] = district;
      tmpMap['tags'] = tags;
      tmpMap['imagePath']= imagePath;
      return tmpMap;
    }
}

class NoteComment 
  {
    final String name;
    final String datetime;
    final String feeling;

    NoteComment(this.name, this.datetime, this.feeling);

    NoteComment.fromJson(Map<String, dynamic> jsonMap)
        : name = jsonMap['name'],
          datetime = jsonMap['datetime'],
          feeling = jsonMap['feeling'];

    Map<String, dynamic> toJson()
    {
      Map<String, dynamic> tmpMap = new Map<String, dynamic>();
      tmpMap['name']= name;
      tmpMap['datetime']= datetime;
      tmpMap['feeling']= feeling;
      return tmpMap;
    }
}

class NoteDataList 
  {
    int noteNum;
    List<String> serverAddr = new List();
    List<NoteData> noteList = new List();
    //final List<NoteComment> noteComment;

    NoteDataList(int numb ,List<String> srvAddr,List<NoteData> dataList){
      noteNum = numb;
      //serverAddr = new List();
      //noteList =new List();
      if(srvAddr.length > 0){
        srvAddr.every(serverAddr.add);
      }
      if(dataList.length > 0){
        dataList.every(noteList.add);
      }
        
    }
    //NoteData(this.noteID, this.datetime, this.feeling, this.weather, this.temperature, this.location, this.imagePath, this.noteComment);

    NoteDataList.fromJson(Map<String, dynamic> jsonMap)
    {
      noteNum = jsonMap['noteNum'];
      if(jsonMap['serverAddr'] != null)
      {
        //jsonMap['serverAddr'].every(serverAddr.add);
        serverAddr.clear();
        serverAddr.add(jsonMap['serverAddr'][0]);
        
      }
      NoteData tmp = new NoteData('','','','','',0,0,'','',[''],[''],['']);
      for (var item in jsonMap['noteList']){
        _copyToList(item);
      }

    }
    void _copyToList(Map<String, dynamic> jsonMap)
    {
        NoteData tmp;
        tmp = NoteData.fromJson(jsonMap);
        noteList.add(tmp);
    }      
          //

    Map<String, dynamic> toJson()
    {
      Map<String, dynamic> tmpMap = new Map<String, dynamic>();
      tmpMap['noteNum']= noteNum;
      tmpMap['serverAddr']= serverAddr;
      tmpMap['noteList']= noteList;
      return tmpMap;
    }
  }