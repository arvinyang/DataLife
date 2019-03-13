import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'each_view.dart';
import 'insta_body.dart';
import 'add_story.dart';
import 'file_pperation.dart';

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
  FileOperation myfile = new FileOperation();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
    print('onPageChanged is tapped!!!!!!!');
    setState(() {
      this._page = page;
    });
  }
  void navigationTapped(int page) {
    //Animating Page
    print('navigationTapped');
    pageController.jumpToPage(page);
  }
  @override
  void initState() {
    super.initState();
    _eachView = List();
    _eachView..add(EachView('home'))..add(EachView('me'));
    pageController = new PageController();
    readAll();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
  Future<String> readAll() async {
    await myfile.readFromLocalFile();
  }
}
