import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'file_pperation.dart';
import 'package:amap_location_plugin/amap_location_plugin.dart';



class AddStorty extends StatefulWidget {
  String _title;
  AddStorty(this._title);
  @override
  _AddStorty createState() => _AddStorty();
}

class _AddStorty extends State<AddStorty> with LoadingDelegate {
  String storyFeeling = "";
  FileOperation myfile;
  final TextEditingController controller = new TextEditingController();
  String currentSelected = "";
  String photoTitle = 'my photo';
  List<String> selectedPhoto = [];
  String _location = 'Unknown';
  AmapLocation _amapLocation = AmapLocation();
  StreamSubscription<String> _locationSubscription;
  Map<String, dynamic> _locationInfo;
  @override
  void initState() {
    super.initState();
    myfile = new FileOperation();
    _locationInfo = null;
    _locationSubscription = _amapLocation.onLocationChanged.listen((String location) {
      print(location);
      if (!mounted) return;
      setState(() {
        _location = location;
        if(_location != 'Unknown')
        {
          _locationInfo =  json.decode(_location);
        }
        controller.text = storyFeeling;
      });
      //get location once
      _amapLocation.stopLocation;
    });
    _amapLocation.startLocation;
    
    setState(() {
      //_location = location;
    });
  }
  Future<void> getLocation() async {
    String location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      location = await _amapLocation.getLocation;
      print(location);
    } catch(err) {
      location = 'Failed to get location.';
    }
  }
  @override
  void dispose() {
    super.dispose();
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
  }
  @override
  Widget buildPreviewLoading(
    BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 30.0,
        height: 30.0,
        child: CupertinoActivityIndicator(
          radius: 10.0,
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
    Widget buildTextField() {
      return TextField(
        controller: controller,
        maxLength: 2000,
        maxLines: 12,
        autofocus: true,
        obscureText: false,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 14.0, color: Colors.black87),
        scrollPadding: const EdgeInsets.all(10.0),
        onChanged: (text) {
          //debugPrint('change $text');
          storyFeeling = text;
        },
        onSubmitted: (text) {
          //debugPrint('submit $text');
        },
        enabled: true,
        decoration: InputDecoration(
          hintText: "Say Something...",
          //icon: Icon(Icons.flare),
          contentPadding: EdgeInsets.all(15.0),
          border: OutlineInputBorder(
            gapPadding: 10.0,
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.cyan, width: 1.0, style: BorderStyle.none)
          )),
      );
    }
    Widget buildImgView() {
       return Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 8.0,
                  ),
                ),
                child: Image.file(
                File(selectedPhoto[0]),
                width: 100,
                height: 100,
                fit:BoxFit.cover
              )),
              selectedPhoto.length>1?Container(
                alignment: Alignment.center,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 5.0,
                  ),
                ),
                child: Image.file(
                File(selectedPhoto[1]),
                width: 100,
                height: 100,
                fit:BoxFit.cover
              )):null,
              Container(
                alignment: Alignment.center,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 5.0,
                  ),
                ),
                child: FlatButton(
                  child: new Icon(Icons.more_horiz,size: 50,),
                  onPressed: () {},
              )),
          ]);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: new IconButton(
                  icon: Icon(Icons.add_a_photo),
                  color: Colors.white,
                  onPressed: () => _pickImage(PickType.onlyImage))
        )
      ],
      ),
      body: ListView(
        children: [
          (selectedPhoto.length > 0)
          ?buildImgView(): new Text(" "),
          //new Text(currentSelected),
          buildTextField(),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
             Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    new Icon(
                      Icons.location_on,
                    ),
                    Expanded(
                      child:Text(_locationInfo == null?'定位中...':_locationInfo['address'],
                        style: TextStyle(fontWeight: FontWeight.normal),softWrap: true),
                  ),
                ]),
             ),
            ]),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _saveStory(),
        tooltip: 'save',
        child: new Icon(Icons.save),
      ),
    );
  }
  void _saveStory()
  {
    if(selectedPhoto.isEmpty && storyFeeling.isEmpty){
      _showAlertDialog(context);
      return;
    }
    var now = new DateTime.now();
    String timeStr = now.toString();
    String feeling = timeStr.substring(0, timeStr.lastIndexOf('.')) + '  ' + storyFeeling;
    debugPrint('selectedPhoto:$selectedPhoto');
    NoteData newStory = new NoteData('',timeStr,timeStr,feeling,' ',0,0,'',' ',[''],[''],selectedPhoto);
    if(_location != 'Unknown')
    {
      Map<String, dynamic> _locationMap =  json.decode(_location);
      newStory.lat = double.parse(_locationMap['latitude']);
      newStory.lgt = double.parse(_locationMap['longitude']);
      newStory.location = _locationMap['address'];
      newStory.district.clear();
      newStory.district.add(_locationMap['province']);
      newStory.district.add(_locationMap['city']);
      newStory.district.add(_locationMap['district']);
      print(_locationMap['address']);
    }
    FileOperation.noteDataList.noteList.add(newStory);
    FileOperation.noteDataList.noteNum++;
    myfile.writeToLocalFile();
    Navigator.of(context).pop();
  }
  void _showAlertDialog(BuildContext context) {
    NavigatorState navigator= context.rootAncestorStateOfType(const TypeMatcher<NavigatorState>());
    debugPrint("navigator is null?"+(navigator==null).toString());
    showDialog<dynamic>(
      context: context,
      builder: (_) => new AlertDialog(
          title: new Text(''),
          content: new Text("还什么都没有添加呢..."),
          actions:<Widget>[
            new FlatButton(child:new Text("关闭"), onPressed: (){
              Navigator.of(context).pop();

            },),
/*             new FlatButton(child:new Text("确定"), onPressed: (){
              Navigator.of(context).pop();

            },) */
          ]
      ));
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
  void _pickImage(PickType type, {List<AssetPathEntity> pathList}) async {
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      // BuildContext required
      context: context,

      /// The following are optional parameters.
      themeColor: Colors.lightBlue,
      // the title color and bottom color
      padding: 1.0,
      // item padding
      dividerColor: Colors.grey,
      // divider color
      disableColor: Colors.grey.shade600,
      // the check box disable color
      itemRadio: 0.88,
      // the content item radio
      maxSelected: 8,
      // max picker image count
      // provider: I18nProvider.english,
      provider: I18nProvider.chinese,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 4,
      // item row count
      textColor: Colors.white,
      // text color
      thumbSize: 256,
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
  }
  String noteGenerater(){
    String tmpStr;
    tmpStr = "noteID" + ":" + "019983874" + ','
    + "date" + ":" + "2019-03-12 09:30:12" + ','
    + "weather" + ":" + " " + ","
    + "temperature" + ":" + " " + ","
    + "place" + ":" + "成都市高新区益州大道" + ',';
    return tmpStr;
  }
}
