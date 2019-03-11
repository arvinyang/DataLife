import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
  

  class FileOperation
  {
    final String fileName = 'noteData.json';
    String filePath;
    factory FileOperation() =>_getInstance();
    static FileOperation get instance => _getInstance();
    static FileOperation _instance;
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
      try {
        File file = await getLocalFile();
        // read the variable as a string from the file.
        String contents = await file.readAsString();
        return contents;
      } on FileSystemException {
        return "";
      }
    }

    Future<Null> writeToLocalFile(String str) async {
      // write the variable as a string to the file
      await (await getLocalFile()).writeAsString(str);
    }

  }
  