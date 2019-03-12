import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:convert';
import 'dart:io';
import 'file_pperation.dart';

class AddStorty extends StatefulWidget {
  String _title;
  AddStorty(this._title);
  @override
  _AddStorty createState() => _AddStorty();
}

class _AddStorty extends State<AddStorty> with LoadingDelegate {
  var results = "";
  FileOperation myfile = new FileOperation();
  final TextEditingController controller = new TextEditingController();
  String currentSelected = "";
  String photoTitle = 'my photo';
  List<String> selectedPhoto = [];
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
  Widget buildPreviewLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
  }
  @override
  Widget buildBigImageLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
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
                results = results + "\n" + timeStr.substring(0, timeStr.lastIndexOf('.')) + '  ' + str;
                myfile.writeToLocalFile(json.encode(results));
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
      body: ListView(
        children: [
          //Icon(AssetImage("assets/images/addPhoto.jpg")),
          new IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.blueAccent,
                  onPressed: () => _pickImage(PickType.onlyImage)),
          (selectedPhoto.length > 0)
          ? new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("itemBuilder::::::::::::::::::::::::::::::::::::::$selectedPhoto.length");
                return new Image.file(
                      File(selectedPhoto[index]),
                      width: 100,
                      height: 100,
                    );
              },
              itemCount: selectedPhoto.length,
            )
            : new Text("no select item"),
          new Text(currentSelected),
          textSection,
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => null,
        tooltip: 'pickImage',
        child: new Icon(Icons.navigate_next),
      ),
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
  void _pickImage(PickType type, {List<AssetPathEntity> pathList}) async {
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      // BuildContext required
      context: context,

      /// The following are optional parameters.
      themeColor: Colors.green,
      // the title color and bottom color
      padding: 1.0,
      // item padding
      dividerColor: Colors.grey,
      // divider color
      disableColor: Colors.grey.shade300,
      // the check box disable color
      itemRadio: 0.88,
      // the content item radio
      maxSelected: 8,
      // max picker image count
      // provider: I18nProvider.english,
      provider: I18nProvider.chinese,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 3,
      // item row count
      textColor: Colors.white,
      // text color
      thumbSize: 150,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
      ),
      // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox

      loadingDelegate: this,
      // if you want to build custom loading widget,extends LoadingDelegate, [see example/lib/main.dart]

      badgeDelegate: const DurationBadgeDelegate(),
      // badgeDelegate to show badge widget

      pickType: type,

      photoPathList: pathList,
    );

    if (imgList == null) {
      currentSelected = "no select item";
    } else {
      selectedPhoto = [];
      for (var e in imgList) {
        var file = await e.file;
        selectedPhoto.add(file.absolute.path);
      }
      currentSelected = selectedPhoto.join("\n\n");
    }
    setState(() {});
  }
}
