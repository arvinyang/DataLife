import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'each_view.dart';
import 'insta_body.dart';
import 'add_story.dart';
import 'file_pperation.dart';
import 'http_dio.dart';

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
  //FileOperation myfile = new FileOperation();

  @override
  Widget build(BuildContext context) {
    Widget appBarDis = new AppBar(
      backgroundColor: new Color(0xfff8faf8),
      centerTitle: true,
      elevation: 1.0,
      leading: new Icon(Icons.camera_alt, color: Colors.black,),
      title: SizedBox(
          height: 35.0, child: Image.asset("assets/images/insta_logo.png")),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(icon: Icon(Icons.refresh ,color: Colors.black), onPressed: (){})
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
    _eachView = List();
    _eachView..add(EachView('home'))..add(EachView('me'));
    pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
