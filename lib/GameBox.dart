import 'package:flutter/material.dart';
import 'dart:math';

/**
 * 游戏运行过程中的方块
 */

class GameBoxWidget extends StatefulWidget {
  //方块所在的位置
  final int position;
  //方块显示的数值
  int value;

  _GameBoxState _gameBoxState;

  GameBoxWidget({Key key, this.position = 0}) : super(key: key);

  //更新value值
  void updateValue(int newValue){
    _gameBoxState.setState((){
      this.value =newValue;
    });
  }

  //设置动画执行
  void startAnimation(int movePosition, bool vertical) {
    _gameBoxState.startPaddingAnimation(movePosition, vertical);
  }

  @override
  _GameBoxState createState() {
    _gameBoxState = _GameBoxState();
    return _gameBoxState;
  }
}

class _GameBoxState extends State<GameBoxWidget>
    with SingleTickerProviderStateMixin {
  //方块的宽度
  double _boxWidth;
  //方块初始时的颜色，根据方块中的数值来显示
  Color _baseColor = Colors.orangeAccent;
  int _baseColorR = 20;
  int _baseColorG = 30;
  int _baseColorB = 30;

  //距离顶部的padding
  double _topPadding = 0;
  //距离左边的padding
  double _leftPadding = 0;

  //动画控制器
  AnimationController _controller;
  //距离顶部的动画
  Animation<double> _topAnimation;
  Tween<double> _topTween;
  //距离左边的动画
  Animation<double> _leftAnimation;
  Tween<double> _leftTween;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //获取颜色值
    //_getBoxColor();

    //设置动画控制器
    _controller = new AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    //初始化动画参数
    _topTween = Tween<double>();
    _topAnimation = _topTween.animate(_controller);

    _leftTween = Tween<double>();
    _leftAnimation = _leftTween.animate(_controller);
  }

  //根据不同的数字设置不同的背景颜色
  Color _getBoxColor() {
    int currentValue = widget.value;
    if (widget.value != null && widget.value > 0) {
      do {
        if (_baseColorR + 30 < 255) {
          _baseColorR += 22;
        } else {
          _baseColorR = 70;
        }

        if (_baseColorG + 20 < 255) {
          _baseColorG += 22;
        } else {
          _baseColorG = 80;
        }

        if (_baseColorB + 33 < 255) {
          _baseColorB += 22;
        } else {
          _baseColorB = 90;
        }
        currentValue = (currentValue ~/ 2).toInt();
      } while (currentValue / 2 != 1);
    }
    print("获取到的颜色值：$_baseColorR,$_baseColorG,$_baseColorB");
    _baseColor = Color.fromARGB(255, _baseColorR, _baseColorG, _baseColorB);
    return _baseColor;
  }

  //根据不同的value值设置不同的背景颜色
  Color _getBackColor() {
    switch (widget.value ?? 0) {
      case 0:
        return Colors.orangeAccent;
      case 2:
        return Colors.pinkAccent;
      case 4:
        return Colors.purpleAccent;

      case 8:
        return Colors.redAccent;

      case 16:
        return Colors.tealAccent;

      case 32:
        return Colors.deepOrange;
      case 64:
        return Colors.amberAccent;
      case 128:
        return Colors.blueAccent;
      case 256:
        return Colors.brown;
      case 512:
        return Colors.cyanAccent;
      case 1024:
        return Colors.deepOrangeAccent;
      case 2048:
        return Colors.deepPurpleAccent;
      case 4096:
        return Colors.indigoAccent;
      case 8192:
        return Colors.limeAccent;
      case 16384:
        return Colors.orangeAccent;

      default:
    }
  }

  //启动动画
  /**
   * value: 移动距离
   * vertical:方向信息
   */
  void startPaddingAnimation(int movePosition, bool isVertical) async{
    print("开始执行动画：$isVertical");
    if (widget.position < 16) {
      if (isVertical) {
        _topTween.begin = 10.0 +
            (widget.position ~/ 4) * _boxWidth +
            (widget.position ~/ 4) * 10;

        _topTween.end =
            10.0 + (movePosition ~/ 4) * _boxWidth + (movePosition ~/ 4) * 10;
      } else {
        _leftTween.begin = 10.0 +
            (widget.position % 4) * _boxWidth +
            (widget.position % 4) * 10;
        _leftTween.end =
            10.0 + (movePosition % 4) * _boxWidth + (movePosition % 4) * 10;
      }
      _controller.addStatusListener((listener) {
        switch (listener) {
          case AnimationStatus.completed:
            //动画执行完成,重置topPadding和leftPadding
            _topPadding = 10.0 +
                (widget.position ~/ 4) * _boxWidth +
                (widget.position ~/ 4) * 10;
            _leftPadding = 10.0 +
                (widget.position % 4) * _boxWidth +
                (widget.position % 4) * 10;
            //_getBoxColor();
            break;
          default:
        }
      });
      _controller.addListener(() {
        if (isVertical) {
          _topPadding = _topAnimation.value;
        } else {
          _leftPadding = _leftAnimation.value;
        }
      });
      await _controller.forward().orCancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Positioned(
            left: _leftPadding,
            top: _topPadding,
            child: Container(
              width: _boxWidth,
              height: _boxWidth,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _getBackColor(),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                widget.value == null ? "" : widget.value.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
                textScaleFactor: 1.3,
              ),
            ),
          );
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _boxWidth = (MediaQuery.of(context).size.width - 30 - 50) / 4;
    //设置每一个gameBox的位置
    _topPadding =
        10.0 + (widget.position ~/ 4) * _boxWidth + (widget.position ~/ 4) * 10;
    _leftPadding =
        10.0 + (widget.position % 4) * _boxWidth + (widget.position % 4) * 10;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
