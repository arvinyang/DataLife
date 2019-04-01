import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'file_pperation.dart';
  

  class IsolateFileOperation
  {
    final String fileName = 'noteData.json';
    final String fileNameList = 'noteDataList.json';
    String filePath;
    factory IsolateFileOperation() =>_getInstance();
    static IsolateFileOperation get instance => _getInstance();
    static IsolateFileOperation _instance;
    static NoteData noteData;
    static NoteDataList noteDataList;
    static File localFile;
    bool readFlag = true;

    IsolateFileOperation._internal() {
    // 初始化
    //filePath = (await getApplicationDocumentsDirectory()).path;
    noteDataList = new NoteDataList(0, []);
    //noteData = new NoteData(' ',' ',' ',' ',' ',' ',[' ']);
    //readFromLocalFileList();
    }
    static IsolateFileOperation _getInstance() {
      _instance ??= new IsolateFileOperation._internal();
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
        } catch (err) {
          print(err);
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
  