import 'dart:io';
import 'dart:async';
import 'dart:convert';
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
    File localFile;
    bool readFlag = true;

    FileOperation._internal() {
    // 初始化
    //filePath = (await getApplicationDocumentsDirectory()).path;
    //noteDataList = new NoteDataList(0, []);
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
    String noteID;
    String date;
    String feeling;
    String weather;
    String temperature;
    String place;
    List<String> imagePath = [''];
    //final List<NoteComment> noteComment;

    NoteData(this.noteID, this.date, this.feeling, this.weather, this.temperature, this.place, this.imagePath);
    //NoteData(this.noteID, this.date, this.feeling, this.weather, this.temperature, this.place, this.imagePath, this.noteComment);

    NoteData.fromJson(Map<String, dynamic> jsonMap)
    {
        noteID = jsonMap['noteID'];
        date = jsonMap['date'];
        feeling = jsonMap['feeling'];
        weather = jsonMap['weather'];
        temperature = jsonMap['temperature'];
        place = jsonMap['place'];
        jsonMap['imagePath'].forEach(imagePath.add);
        //noteComment = jsonMap['noteComment'];
    }
          
          //

    Map<String, dynamic> toJson()
    {
      Map<String, dynamic> tmpMap = new Map<String, dynamic>();
      tmpMap['noteID']= noteID;
      tmpMap['date']= date;
      tmpMap['feeling']= feeling;
      tmpMap['weather']= weather;
      tmpMap['temperature']= temperature;
      tmpMap['place']= place;
      tmpMap['imagePath']= imagePath;
      return tmpMap;
    }
}

class NoteComment 
  {
    final String name;
    final String date;
    final String feeling;

    NoteComment(this.name, this.date, this.feeling);

    NoteComment.fromJson(Map<String, dynamic> jsonMap)
        : name = jsonMap['name'],
          date = jsonMap['date'],
          feeling = jsonMap['feeling'];

    Map<String, dynamic> toJson()
    {
      Map<String, dynamic> tmpMap = new Map<String, dynamic>();
      tmpMap['name']= name;
      tmpMap['date']= date;
      tmpMap['feeling']= feeling;
      return tmpMap;
    }
}

class NoteDataList 
  {
    int noteNum;
    List<NoteData> noteList =new List();
    //final List<NoteComment> noteComment;

    NoteDataList(int numb ,List<NoteData> dataList){
      noteNum = numb;
      if(dataList.length > 0){
        dataList.every(noteList.add);
      }
        
    }
    //NoteData(this.noteID, this.date, this.feeling, this.weather, this.temperature, this.place, this.imagePath, this.noteComment);

    NoteDataList.fromJson(Map<String, dynamic> jsonMap)
    {
        noteNum = jsonMap['noteNum'];
        NoteData tmp = new NoteData('','','','','','',[]);
        for (var item in jsonMap['noteList']){
          _copyToList(item);
        }

    }
    void _copyToList(Map<String, dynamic> jsonMap)
    {
        NoteData tmp;// = new NoteData('','','','','','',[]);
        tmp = NoteData.fromJson(jsonMap);
        noteList.add(tmp);
    }      
          //

    Map<String, dynamic> toJson()
    {
      Map<String, dynamic> tmpMap = new Map<String, dynamic>();
      tmpMap['noteNum']= noteNum;
      tmpMap['noteList']= noteList;
      return tmpMap;
    }
  }