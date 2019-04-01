import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:BOPhotoNote/insta_stories.dart';
import 'file_pperation.dart';
import 'dart:io';
import "package:async/src/async_memoizer.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';


class InstaList extends StatefulWidget {
  @override
  _InstaList createState() => _InstaList();
}
class _InstaList extends State<InstaList> {
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
          itemBuilder: (context, index) => index == 0
          ? Text(
                  "My Stories:",
                  style: TextStyle(fontSize: 16.0 ,fontWeight: FontWeight.bold),
                ) /* new SizedBox(
              child: new InstaStories(),
              height: deviceSize.height * 0.15,
            ) */
          :new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].imagePath.isNotEmpty
              ?
              Flexible(
                fit: FlexFit.loose,
                child: new Image.file(
                  new File(FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].imagePath[FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].imagePath.length -1]),
                  fit: BoxFit.cover,                  
                )
              )
              :Padding(
                //当没有图片时候，给一个空的占位元素
                padding: const EdgeInsets.all(0.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[Text('')]),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Icon(
                          FontAwesomeIcons.heart,
                        ),
                        new SizedBox(
                          width: 16.0,
                        ),
                        new Icon(
                          FontAwesomeIcons.comment,
                        ),
                        new SizedBox(
                          width: 16.0,
                        ),
                        new Icon(FontAwesomeIcons.paperPlane),
                      ],
                    ),
                    new Icon(FontAwesomeIcons.bookmark)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].feeling,
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Liked by pawankumar, pk and 528,331 others",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: 40.0,
                      width: 40.0,
                      child: new Image.asset(
                          'assets/images/avatar.jpg',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                      ),
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: new TextField(
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "想说点什么...",
                        ),
                        onChanged: (text) {
                          debugPrint('submcommentString index: $index');
                          commentStr = text;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child:Text("Some Days Ago", style: TextStyle(color: Colors.grey)),
              )
            ],
          ),
        );
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
}

class InstaListFavor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                child: new Text('还在开发中...'),
              ),
            ),
          ],
        );
  }
}
