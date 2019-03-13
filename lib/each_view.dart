import 'package:flutter/material.dart';
import 'dart:convert';
import 'file_pperation.dart';
import 'photo_page.dart';

class EachView extends StatefulWidget {
  String _title;
  EachView(this._title);
  @override
  _EachViewState createState() => _EachViewState();
}

class _EachViewState extends State<EachView> {
  var results = "";
  FileOperation myfile = new FileOperation();
  final TextEditingController controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    readAll().then((String value) {
      setState(() {
        results = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    readAll();
    Future<dynamic>.delayed(Duration(milliseconds: 200));
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('41'),
        ],
      ),
    );
    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'CALL'),
          _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          _buildButtonColumn(color, Icons.share, 'SHARE'),
        ],
      ),
    );
    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(hintText: "Say Something..."),
              onSubmitted: (String str) {
                var now = new DateTime.now();
                String timeStr = now.toString();
                //results = results + "\n" + timeStr.substring(0, timeStr.lastIndexOf('.')) + '  ' + str;
                //myfile.writeToLocalFile(json.encode(results));
                setState(() {
                  controller.text = "";
                });
              },
              controller: controller,
            ),
            new Text(results),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(widget._title),),
      body: new MyPhotoPageState('my photo'),
      /* body: ListView(
        children: [
          Image.asset(
            'assets/images/lake.jpg',
            width: 600,
            height: 240,
            fit: BoxFit.cover,
          ),
          //titleSection,
          //buttonSection,
          textSection,
        ],
      ), */
    );
  }
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
  Future<String> readAll() async {
    results = json.decode(await myfile.readFromLocalFile());
    return results;
    print('readAll:$results');
  // Do something with version
  }
}
