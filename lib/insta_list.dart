import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:async/src/async_memoizer.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
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
          itemBuilder: (context, index) {
            
          if(index == 0){
            return Text(
                    "My Stories:",
                    style: TextStyle(fontSize: 16.0 ,fontWeight: FontWeight.bold),
                  ); /* new SizedBox(
                child: new InstaStories(),
                height: deviceSize.height * 0.15,
              ) */
          }
          else{
            int rsvOrder = FileOperation.noteDataList.noteNum-index;
            NoteData noteContent = FileOperation.noteDataList.noteList[rsvOrder];
            String timeFolding =readTimestamp(noteContent.datetime);
            return Card(
              elevation: 20.0,  //设置阴影
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))), 
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  noteContent.imagePath.isNotEmpty
                  ?Container(
                    //fit: FlexFit.loose,
                    height: 300,
                    child: noteContent.imagePath.length==1
                    ?GestureDetector(
                    //发生点击事件后回调
                    onTap: () {
                      print("hia");
                      _showWholeImage(context,noteContent);
                    },
                    child:new Image.file(
                      new File(noteContent.imagePath[0]),
                      filterQuality:FilterQuality.low ,
                      fit: BoxFit.fitWidth, 
                      scale: 0.1,      
                    ))
                    :Swiper(
                      itemBuilder: (BuildContext context, int swipIdx) {
                        int itemNum = noteContent.imagePath.length;
                        debugPrint("Swiper itemNum:$itemNum");
                        return new Image.file(
                          File(noteContent.imagePath[swipIdx]),
                          filterQuality:FilterQuality.low ,
                          fit: BoxFit.fitWidth,
                          scale: 0.1,             
                        );
                      },
                      itemCount: noteContent.imagePath.length,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      pagination: new SwiperPagination(),
                      onTap: (index){
                         _showWholeImage(context,noteContent);
                      },
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
                        new Icon(Icons.check_circle,color:(noteContent.postID==null
                        ||noteContent.postID=="") 
                        ? Colors.grey : Colors.black,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      noteContent.feeling,
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
                                child:Text(noteContent.location.isEmpty
                                ?'没有位置信息哟...':noteContent.location,
                                  style: TextStyle(fontWeight: FontWeight.w100),softWrap: true),
                            ),
                          ]),
                      ),
                      ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child:Text(timeFolding, style: TextStyle(color: Colors.grey)),
                  )
                ],
              ),
              );
            };
          }
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
 void _showWholeImage(BuildContext context,NoteData item) {
    NavigatorState navigator= context.rootAncestorStateOfType(const TypeMatcher<NavigatorState>());
    debugPrint("navigator is null?"+(navigator==null).toString());
    showDialog<dynamic>(
      context: context,
      builder: (_) => new GestureDetector(
        onTap: () {
        Navigator.of(context).pop();
        },
        child:Container(
            child: item.imagePath.length==1
            ?new Image.file(
              new File(item.imagePath[0]),
              filterQuality:FilterQuality.low ,
              fit: BoxFit.cover, 
              scale: 0.1,      
            )
            :Swiper(
              itemBuilder: (BuildContext context, int swipIdx) {
                return new Image.file(
                  File(item.imagePath[swipIdx]),
                  filterQuality:FilterQuality.low ,
                  fit: BoxFit.cover,
                  scale: 1.0,             
                );
              },
              itemCount: item.imagePath.length,
              viewportFraction: 1.0,
              scale: 0.9,
              pagination: new SwiperPagination(),
            )
          ),
        ),
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
