import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'each_view.dart';
import 'insta_body.dart';
import 'add_story.dart';
import 'file_pperation.dart';
import 'isolate_sync.dart';

class BottomAppBarDemo extends StatefulWidget {
  @override
  _BottomAppBarDemoState createState() => _BottomAppBarDemoState();
}
PageController pageController;
class _BottomAppBarDemoState extends State<BottomAppBarDemo> {
  List<Widget> _eachView;
  int _page = 0;
  int _index = 0;
  bool triedSilentLogin = false;
  bool setupNotifications = false;
  String ipAddr;
  FileOperation myfile;
   AsyncIsolate asyncIsolate;
  //FileOperation myfile = new FileOperation();

  @override
  Widget build(BuildContext context) {
    Widget appBarDis = new AppBar(
      backgroundColor: new Color(0xfff8faf8),
      centerTitle: true,
      elevation: 1.0,
      leading: (Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(icon: Icon(Icons.settings ,color: Colors.black), onPressed: (){_showAlertDialog(context);})
        )),
      title: SizedBox(
          height: 35.0, child: Image.asset("assets/images/insta_logo.png")),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: Icon(Icons.sync ,color: Colors.black), 
            onPressed: (){
              setState(() {
                IconButton;
              });
              _reSync();

              },)
        )
      ],
    );
    return new Scaffold(
      appBar:appBarDis,
      body: new PageView(
              children: [
                new Container(color: Colors.white, child: new InstaBody(),),
                new Container(color: Colors.white, child: new InstaBodyFavor()),
              ],
              controller: pageController,
              physics: new NeverScrollableScrollPhysics(),
              onPageChanged: onPageChanged,
            ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
            return AddStorty('Add a New Story');
          }));
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // T
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // his
      bottomNavigationBar: new CupertinoTabBar(
        activeColor: Colors.orange,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home, color: (_page == 0) ? Colors.black : Colors.grey),
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.favorite, color: (_page == 1) ? Colors.black : Colors.grey),
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
  void onPageChanged(int page) {
    debugPrint('onPageChanged is tapped!!!!!!!');
    setState(() {
      this._page = page;
    });
  }
  void navigationTapped(int page) {
    //Animating Page
    debugPrint('navigationTapped');
    pageController.jumpToPage(page);
  }
  @override
  void initState() {
    super.initState();
    debugPrint('main:');
    if(myfile==null || FileOperation.noteDataList!=null){
            myfile= new FileOperation();
      }
      
      asyncIsolate = AsyncIsolate();
      // 关键的全局最早读取文件的步骤
      myfile.readFromLocalFile().then((onValue)async{
        await asyncIsolate.asyncIsolateInit();
        if(FileOperation.noteDataList.noteNum > 0){
          //读取服务器IP地址
          if(FileOperation.noteDataList.serverAddr.isNotEmpty)
          {
            ipAddr = FileOperation.noteDataList.serverAddr[0];
          }else{
            ipAddr = '请输入IP地址';
          }
          NoteDataList response = await AsyncIsolate.asyncExcute(AsyncIsolate.sendPort, FileOperation.noteDataList);
          //update the postID and write to file
          int index = 0;
          for(var item in response.noteList){
            FileOperation.noteDataList.noteList[index].postID =item.postID;
            index++;
          }
          myfile.writeToLocalFile();
          debugPrint('initState asyncExcute finished');
        }
      });
    debugPrint('sync OK!');
    _eachView = List();
    _eachView..add(EachView('home'))..add(EachView('me'));
    pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
  void _showAlertDialog(BuildContext context) {
    NavigatorState navigator= context.rootAncestorStateOfType(const TypeMatcher<NavigatorState>());
    final controller = TextEditingController();
    debugPrint("navigator is null?"+(navigator==null).toString());
    showDialog<dynamic>(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('同步服务器IP地址'),
        content: new TextField(
          controller: controller,
          keyboardType: TextInputType.url,
          decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: "$ipAddr",
          ),
          onChanged: (text) {
            //debugPrint('change $text');
            //ipAddr = text;
          },
        ),
        actions:<Widget>[
          new FlatButton(child:new Text("取消"), onPressed: (){
            //debugPrint('IP Address:$ipAddr');
            Navigator.of(context).pop();

          },),
          new FlatButton(child:new Text("保存"), onPressed: (){
            ipAddr = controller.text;
            debugPrint('IP Address:$ipAddr');
            FileOperation.noteDataList.serverAddr.clear();//只支持1个ip
            FileOperation.noteDataList.serverAddr.add(ipAddr);
            myfile.writeToLocalFile();
            Navigator.of(context).pop();

          },) 
        ]
    ));
  }
  void _reSync() async{
    NavigatorState navigator= context.rootAncestorStateOfType(const TypeMatcher<NavigatorState>());
    final controller = TextEditingController();
    debugPrint("navigator is null?"+(navigator==null).toString());
    showDialog<dynamic>(
      context: context,
      builder: (_) => new AlertDialog(
        content: new Text('正在同步...'),
        ),
    );
    Future<dynamic>.delayed(Duration(milliseconds: 2000)).then((dynamic onValue){
      Navigator.of(context).pop();
    });
    if(FileOperation.noteDataList.noteNum > 0){
      NoteDataList response = await AsyncIsolate.asyncExcute(AsyncIsolate.sendPort, FileOperation.noteDataList);
      FileOperation.noteDataList = response;
      myfile.writeToLocalFile();
      debugPrint('_reSync asyncExcute finished');
    }
   }
}
