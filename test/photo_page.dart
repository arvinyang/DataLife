import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';



class MyPhotoPageState extends LoadingDelegate {
  String currentSelected = "";
  String _photoPageTitle = "My Album";

  MyPhotoPageState(String title){
      _photoPageTitle = title;
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_photoPageTitle),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.image),
            onPressed: null,//_testPhotoListParams,
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              IconTextButton(
                  icon: Icons.photo,
                  text: "photo",
                  onTap: () => _pickAsset(context, PickType.onlyImage)),
              IconTextButton(
                  icon: Icons.videocam,
                  text: "video",
                  onTap: () => _pickAsset(context, PickType.onlyVideo)),
              IconTextButton(
                  icon: Icons.album,
                  text: "all",
                  onTap: () => _pickAsset(context, PickType.all)),
              Text(
                '$currentSelected',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _pickAsset(context, PickType.all),
        tooltip: 'pickImage',
        child: new Icon(Icons.add),
      ),
    );
  }

  void _testPhotoListParams(BuildContext context) async {
    var assetPathList = await PhotoManager.getImageAsset();
    _pickAsset(context, PickType.all, pathList: assetPathList);
  }

  void _pickAsset(BuildContext context, PickType type, {List<AssetPathEntity> pathList}) async {
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
      currentSelected = "not select item";
    } else {
      List<String> r = [];
      for (var e in imgList) {
        var file = await e.file;
        r.add(file.absolute.path);
      }
      currentSelected = r.join("\n\n");
    }
    //setState(() {});
  }
}

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  const IconTextButton({Key key, this.icon, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: ListTile(
          leading: Icon(icon ?? Icons.device_unknown),
          title: Text(text ?? ""),
        ),
      ),
    );
  }
}