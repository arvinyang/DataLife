import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:async/src/async_memoizer.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'file_pperation.dart';
import 'photo_page.dart';

class LifeStory extends StatefulWidget {
  @override
  _LifeStory createState() => _LifeStory();
}
class _LifeStory extends State<LifeStory> {
  FileOperation myfile;
  final AsyncMemoizer _memoizer = new AsyncMemoizer<dynamic>();
  NoteData myData;
  String commentStr;
  String teststr;
  int cnt=0;
  @override
  void initState() {
    super.initState();
    if(myfile==null || FileOperation.noteDataList!=null){
          myfile= new FileOperation();
    }
    // 关键的读取文件的步骤
    new Future(()=>myfile.readFromLocalFile()).then((dynamic onValue)=>
      setState(() {
        //TODO 
      })
    );
  }
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    if(FileOperation.noteDataList != null)
    {
      if(FileOperation.noteDataList.noteList.length > 0){
        return new ListView.builder(
          itemCount: FileOperation.noteDataList.noteList.length + 1,
          itemBuilder: (context, index) {
            
          if(index == 0){
            return Image.asset(
            'assets/images/lifestory.png',
            fit: BoxFit.cover,
            );
          }
          else {
            int rsvOrder = FileOperation.noteDataList.noteNum-index;
            NoteData noteContent = FileOperation.noteDataList.noteList[rsvOrder];
            return noteContent.imagePath.isNotEmpty
              ?Container(
                alignment: Alignment.center,
                height: 200,
                width: 500,
                margin: EdgeInsets.all(5.0),
  
                      child:GestureDetector(
                    //发生点击事件后回调
                    onTap: () {
                      print("hia");
                      //_showWholeImage(context,noteContent);
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
                          return MyPhotoPageState(noteContent);
                        }));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: new Image.file(
                      new File(noteContent.imagePath[0]),
                      filterQuality:FilterQuality.low ,
                      fit: BoxFit.cover, 
                      scale: 0.1,
                    ),
                    ))
                  ):Padding(
                    //当没有图片时候，给一个空的占位元素
                    padding: const EdgeInsets.all(0.0),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[Text('')]),
                  );
        }});
      }else{
        return new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
              child: new Center(
                child: new Icon(Icons.sentiment_dissatisfied),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
              child: new Center(
                child: new Text('还没有任何日记哦...'),
              ),
            ),
          ],
        );
      }
    }
    else{
      return new Stack(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
          child: new Center(
            child: SpinKitFadingCircle(
              color: Colors.blueAccent,
              size: 30.0,
            ),
          ),
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: new Center(
            child: new Text('正在努力加载中....'),
          ),
        ),
      ],
    );
    }
  }
  Future<dynamic> readAll() async {
    return _memoizer.runOnce(
      () async {
        if(myfile==null || FileOperation.noteDataList!=null){
          myfile= new FileOperation();
        }
        myfile.readFromLocalFile();
        cnt++;
      }
    );
  }
  String readTimestamp(String timesStr) {
    if(timesStr == null || timesStr == ''){
      return 'Some time ago';
    }
    int dealTime = DateTime.parse(timesStr).millisecondsSinceEpoch;
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var dealDate = new DateTime.fromMillisecondsSinceEpoch(dealTime);
    var diff = now.difference(dealDate);
    var timeStr = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0){
      timeStr = '1 minute ago';
    }else if(diff.inMinutes > 0 && diff.inHours == 0){
      timeStr = diff.inMinutes.toString() +  'minutes ago';
    } else if(diff.inHours > 0 && diff.inDays == 0) {
      if (diff.inDays == 1) {
        timeStr = diff.inHours.toString() + ' hour ago';
      } else {
        timeStr = diff.inHours.toString() + ' hours ago';
      } 
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        timeStr = diff.inDays.toString() + ' Day ago';
      } else {
        timeStr = diff.inDays.toString() + ' Days ago';
      }
    } else {
      if (diff.inDays == 7) {
        timeStr = (diff.inDays / 7).floor().toString() + ' Week ago';
      } else {

        timeStr = (diff.inDays / 7).floor().toString() + ' Weeks ago';
      }
    }

    return timeStr;
  }
}
