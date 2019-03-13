import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
  

  class FileOperation
  {
    final String fileName = 'noteData.json';
    String filePath;
    factory FileOperation() =>_getInstance();
    static FileOperation get instance => _getInstance();
    static FileOperation _instance;
    static NoteData noteData = new NoteData(' ',' ',' ',' ',' ',' ',[' ']);
    bool readFlag = true;
    FileOperation._internal() {
    // 初始化
    //filePath = (await getApplicationDocumentsDirectory()).path;
    }
    static FileOperation _getInstance() {
      _instance ??= new FileOperation._internal();
      return _instance;
    }
    Future<File> getLocalFile() async {
      // get the path to the document directory.
      String dir = (await getApplicationDocumentsDirectory()).path;
      String tempPath = (await getTemporaryDirectory()).path;
      String appDocPath = (await getApplicationDocumentsDirectory()).path;

      print('临时目录: ' + tempPath);
      print('文档目录: ' + appDocPath);
      return new File('$appDocPath/$fileName');
    }

    Future<String> readFromLocalFile() async {
      if(readFlag){
        try {
          File file = await getLocalFile();
          // read the variable as a string from the file.
          String contents = await file.readAsString();
          print("contents:$contents");
          if(contents.length > 0){
            Map userMap = json.decode(contents);
            noteData = new NoteData.fromJson(userMap);
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

    Future<Null> writeToLocalFile(NoteData tmpNoteData) async {
      // write the variable as a string to the file
      String jsonStr = json.encode(tmpNoteData);
      print("writeToLocalFile:$jsonStr");
      await (await getLocalFile()).writeAsString(jsonStr);
      //readFlag = true;
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