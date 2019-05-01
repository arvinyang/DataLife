import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import "dart:io";
import 'file_pperation.dart';


class MyPhotoPageState extends StatefulWidget {
  NoteData item;
  
  MyPhotoPageState(this.item);
  @override
  _MyPhotoPageState createState() => _MyPhotoPageState(item);
}

class _MyPhotoPageState extends State<MyPhotoPageState> with SingleTickerProviderStateMixin {
  NoteData item;
  //_scale control
  AnimationController _controller;
  Animation<Offset> _animation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;
  double _kMinFlingVelocity = 600.0;
  @override
  _MyPhotoPageState(this.item);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync:this);
    _controller.addListener(() {
      setState(() {
        _offset = _animation.value;
      });
    });
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
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    // widget的屏幕宽度
    final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
    // 限制他的最小尺寸
    return Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
    
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // 计算图片放大后的位置
      _controller.stop();
    });
    debugPrint('_handleOnScaleStart _scale:$_scale');
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 5.0);
      // 限制放大倍数 1~3倍
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
      // 更新当前位置
    });
    debugPrint('_handleOnScaleUpdate _scale:$_scale');
    debugPrint('_handleOnScaleEnd _offset:${_offset.dx},${_offset.dy}');
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    // 计算当前的方向
    final double distance = (Offset.zero & context.size).shortestSide;
    // 计算放大倍速，并相应的放大宽和高，比如原来是600*480的图片，放大后倍数为1.25倍时，宽和高是同时变化的
    _animation = _controller.drive(Tween<Offset>(
        begin: _offset, end: _clampOffset(_offset + direction * distance)));
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
    debugPrint('_handleOnScaleEnd _scale:$_scale');
    debugPrint('_handleOnScaleEnd _offset:${_offset.dx},${_offset.dy}');
  }
  void _resetScale(int index){
    setState(() {
       _scale = 1.0;
       _offset = Offset.zero;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //appBar: AppBar(title: Text(widget._title),), 
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        onDoubleTap: () {
          _resetScale(0);
        },
        onScaleStart: _handleOnScaleStart,
        onScaleUpdate: _handleOnScaleUpdate,
        onScaleEnd: _handleOnScaleEnd,
        child: ClipRect(
          child: Transform(
            transform: Matrix4.identity()..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
            child:Container(
          alignment: Alignment.center,
          //width: ,
          //height: 300,
          decoration: BoxDecoration(
            color: Colors.black87,
          ),
          child: item.imagePath.length==1
          ?new Image.file(
            new File(item.imagePath[0]),
            gaplessPlayback:false,
            filterQuality:FilterQuality.low ,
            fit: BoxFit.contain, 
            scale: 1.0,      
          )
          :Swiper(
            itemBuilder: (BuildContext context, int swipIdx) {
              return new Image.file(
                File(item.imagePath[swipIdx]),
                gaplessPlayback:false,
                filterQuality:FilterQuality.low ,
                fit: BoxFit.contain,
                scale: 1.0,             
              );
            },
            itemCount: item.imagePath.length,
            viewportFraction: 1.0,
            scale: 0.6,
            pagination: new SwiperPagination(),
            onIndexChanged: _resetScale,
          )
        ),
    ))));
  }

}
