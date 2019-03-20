import 'package:flutter/material.dart';
import 'GameRoute.dart';

/**
 * 首页
 */
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: IndexPage(),
      ),
    );
  }
}

/**
 * 首页内容布局
 */
class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() {
    return _IndexPageState();
  }
}

class _IndexPageState extends State<IndexPage> {
  //按钮按下和抬起时的背景颜色
  Color _startGameColor = Colors.white70;
  //开始游戏的按钮
  String startGame = "开始游戏";
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.grey[400],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 20.0, left: 40.0, right: 40.0),
              child: Text(
                "2048",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textScaleFactor: 2.4,
              ),
            ),
            
            Listener(
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: _startGameColor,
                    border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                    child: Text(
                      startGame,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.greenAccent,
                      ),
                      textScaleFactor: 1.3,
                    ),
                  ),
                ),
                onTap: (){
                  //点击跳转到下个页面
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return GameRoute();
                    }
                  ));
                },
              ),
              onPointerDown: (downEvent) {
                //按下时改变背景
                //调用setState改变背景
                setState(() {
                  _startGameColor = Colors.white;
                });
              },
              onPointerUp: (upEvent) {
                //手指抬起时回复颜色
                setState(() {
                  _startGameColor = Colors.white70;
                });
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
