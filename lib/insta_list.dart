import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:async/src/async_memoizer.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'file_pperation.dart';



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
              ?Container(
                //fit: FlexFit.loose,
                height: 300,
                child: FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].imagePath.length==1
                ?new Image.file(
                  new File(FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].imagePath[0]),
                  filterQuality:FilterQuality.low ,
                  fit: BoxFit.fitWidth, 
                  scale: 0.1,                
                )
                :Swiper(
                  itemBuilder: (BuildContext context, int swipIdx) {
                    int itemNum = FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].imagePath.length;
                    debugPrint("Swiper itemNum:$itemNum");
                    return new Image.file(
                      new File(FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].imagePath[swipIdx]),
                      filterQuality:FilterQuality.low ,
                      fit: BoxFit.fitWidth,
                      scale: 0.1,             
                    );
                  },
                  itemCount: FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].imagePath.length,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  pagination: new SwiperPagination(),
                  onTap: (index) => print('点击了第$index个'),
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
                    new Icon(Icons.check_circle,color:(FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].postID==null
                    ||FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].postID=="") 
                    ? Colors.grey : Colors.black,)
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          new Icon(
                            Icons.location_on,
                          ),
                          Expanded(
                            child:Text(FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].location.isEmpty
                            ?'没有位置信息哟...':FileOperation.noteDataList.noteList[FileOperation.noteDataList.noteNum-index].location,
                              style: TextStyle(fontWeight: FontWeight.w100),softWrap: true),
                        ),
                      ]),
                  ),
                  ]),
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
