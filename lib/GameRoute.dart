import 'package:flutter/material.dart';
import 'GameBox.dart';
import 'dart:math';

/**
 * 游戏页面
 */
class GameRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() {
    // TODO: implement createState
    return _GamePageState();
  }
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  //滑动方向，默认垂直方向
  bool _moveVertical = true;
  //滑动距离,配合滑动方向确定方块的移动信息
  double _moveDistance = 0;
  bool _needBuildNextBox = false;
  //创建游戏方块对象
  List<GameBoxWidget> _gameBoxList = List();
  int _firstPosition;
  int _secondPosition;
  //当前的积分
  int _toatalScore = 0;
  @override
  void initState() {
    super.initState();
    //依次创建创建16个方块，避免重复创建对象
    _initGameBox();
  }

  //初始化方块信息
  void _initGameBox() {
    _gameBoxList.clear();
    for (int i = 0; i < 16; i++) {
      GameBoxWidget gameBoxWidget = GameBoxWidget(
        position: i,
      );
      _gameBoxList.add(gameBoxWidget);
    }
    _firstPosition = generalPoaition();
    _secondPosition = generalPoaition();
  }

  //刷新数据
  void _onRefresh(){
     _initGameBox(); 
    setState(() {
    
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Color.fromARGB(255, 227, 204, 169),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //上面是显示游戏名称和得分
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Positioned(
                  left: 10.0,
                  //左边显示游戏名称
                  child: Text(
                    "2048",
                    style: TextStyle(
                      color: Color.fromARGB(200, 105, 75, 35),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textScaleFactor: 2.0,
                  ),
                ),
                //右边显示当前分数和刷新按钮
                /*
                Positioned(
                  right: 10.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(200, 105, 75, 35),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "得分",
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12.0),
                            ),
                            Text(
                              _toatalScore.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(200, 105, 75, 35),
                                borderRadius: BorderRadius.circular(3.0)),
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                          onTap: (){
                            _onRefresh();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                */
              ],
            ),
          ),

          Expanded(
            flex: 5,
            child: GestureDetector(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  constraints: BoxConstraints.tightFor(),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
                    constraints: BoxConstraints.tightFor(),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 105, 75, 35),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Stack(
                      children: _gameBoxList.map((item) {
                        if (item.position == _firstPosition ||
                            item.position == _secondPosition) {
                          item.value = generatorRandom();
                        }
                        return item;
                      }).toList(),
                    ),
                  ),
                ),
              ),
              onVerticalDragUpdate: (updateEvent) {
                _moveVertical = true;
                _moveDistance += updateEvent.delta.dy;
              },
              onVerticalDragEnd: (dragUpDetails) {
                checkPostionMoveInfo(_moveVertical, _moveDistance);
                _moveDistance = 0;
              },
              onHorizontalDragUpdate: (updateEvent) {
                _moveVertical = false;
                _moveDistance += updateEvent.delta.dx;
              },
              onHorizontalDragEnd: (details) {
                checkPostionMoveInfo(_moveVertical, _moveDistance);
                _moveDistance = 0;
              },
            ),
          ),
          Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }

  //遍历查看需要滑动的position和滑动的距离
  void checkPostionMoveInfo(bool isVertical, double path) {
    //如果是垂直方向滑动
    if (isVertical) {
      List<GameBoxWidget> column0Box = List();
      List<GameBoxWidget> column1Box = List();
      List<GameBoxWidget> column2Box = List();
      List<GameBoxWidget> column3Box = List();
      for (int i = 0; i < 16; i++) {
        switch (i % 4) {
          case 0:
            //将第一列的数据加入到List中
            column0Box.add(_gameBoxList[i]);
            break;
          case 1:
            column1Box.add(_gameBoxList[i]);
            break;
          case 2:
            column2Box.add(_gameBoxList[i]);
            break;
          case 3:
            column3Box.add(_gameBoxList[i]);
            break;
          default:
        }
      }
      if (path < 0) {
        print("向上滑动");
        //垂直方向向上移动
        moveVerticalUp(column0Box, true);
        moveVerticalUp(column1Box, true);
        moveVerticalUp(column2Box, true);
        moveVerticalUp(column3Box, true);
      } else {
        moveVerticalDown(column0Box, true);
        moveVerticalDown(column1Box, true);
        moveVerticalDown(column2Box, true);
        moveVerticalDown(column3Box, true);
      }
    } else {
      List<GameBoxWidget> row0Box = List();
      List<GameBoxWidget> row1Box = List();
      List<GameBoxWidget> row2Box = List();
      List<GameBoxWidget> row3Box = List();
      for (int i = 0; i < 16; i++) {
        switch (i ~/ 4) {
          case 0:
            //将第一列的数据加入到List中
            row0Box.add(_gameBoxList[i]);
            break;
          case 1:
            row1Box.add(_gameBoxList[i]);
            break;
          case 2:
            row2Box.add(_gameBoxList[i]);
            break;
          case 3:
            row3Box.add(_gameBoxList[i]);
            break;
          default:
        }
      }
      if (path < 0) {
        //水平方向向左移动
        moveVerticalUp(row0Box, false);
        moveVerticalUp(row1Box, false);
        moveVerticalUp(row2Box, false);
        moveVerticalUp(row3Box, false);
        print("循环完成：是否需要生成下一个游戏方块$_needBuildNextBox");
      } else {
        moveVerticalDown(row0Box, false);
        moveVerticalDown(row1Box, false);
        moveVerticalDown(row2Box, false);
        moveVerticalDown(row3Box, false);
      }
    }

    //在此处判断是否需要生成洗一个方块
    if (_needBuildNextBox) {
      _generalNextRandonBox();
    } else {
      SnackBar(
        content: Text("请向其它方向移动"),
        duration: Duration(seconds: 1),
      );
    }
    _needBuildNextBox = false;
  }

  //垂直方向向上滑动
  void moveVerticalUp(List<GameBoxWidget> columnList, bool isVertical) {
    //遍历第一列的数据
    for (int i = 0; i < columnList.length; i++) {
      if (checkGameBoxExit(columnList[i])) {
        //查看剩余方块中有没有可以合并的
        for (int j = i + 1; j < columnList.length; j++) {
          if (checkGameBoxExit(columnList[j])) {
            if (checkGameBoxMerge(columnList[i], columnList[j])) {
              //定义变量，设置循环完成之后方块的移动信息
              int boxMovePosition = i;
              //遍历查询方块应该移动的位置
              for (int k = i - 1; k > -1; k--) {
                //如果当前方块不存在，继续遍历，一直查询到找到方块为止
                if (checkGameBoxExit(columnList[k])) {
                  boxMovePosition = k - 1;
                  break;
                }
              }
              //循环结束后，根据movePosition设置方块应该执行的操作
              if (boxMovePosition == i) {
                columnList[i]
                    .updateValue(columnList[i].value + columnList[j].value);
                _toatalScore += (columnList[i].value + columnList[j].value);
                columnList[j].updateValue(null);
                columnList[j].startAnimation(
                    _gameBoxList[columnList[i].position].position, isVertical);
              } else {
                _toatalScore += (columnList[i].value + columnList[j].value);
                columnList[boxMovePosition]
                    .updateValue(columnList[i].value + columnList[j].value);
                columnList[i].updateValue(null);
                columnList[j].updateValue(null);
                columnList[i]
                    .startAnimation(columnList[0].position, isVertical);
                columnList[j]
                    .startAnimation(columnList[0].position, isVertical);
                _needBuildNextBox = true;
              }
              //找到之后移动位置之后跳出循环
              break;
            } else {
              break;
            }
          }
        }
        //没有找到和row[i]一样的方块,查看row[i]是否需要移动
        int movePosition = 0;
        for (int m = 0; m < i; m++) {
          if (checkGameBoxExit(columnList[m])) {
            movePosition = m + 1;
          }
        }
        if (movePosition != i || movePosition == columnList.length) {
          //将movePosition的方块设置为当前的方块值，将当前的方块值重置为null
          _gameBoxList[columnList[movePosition].position]
              .updateValue(_gameBoxList[columnList[i].position].value);
          _gameBoxList[columnList[i].position].updateValue(null);

          _gameBoxList[columnList[i].position].startAnimation(
              _gameBoxList[columnList[movePosition].position].position, true);

          _needBuildNextBox = true;
        }
      }
    }
  }

  //垂直方向向下滑动
  void moveVerticalDown(List<GameBoxWidget> columnList, bool isVertical) {
    for (int i = columnList.length - 1; i > -1; i--) {
      if (checkGameBoxExit(columnList[i])) {
        //查看剩余方块中有没有可以合并的
        for (int j = i - 1; j > -1; j--) {
          if (checkGameBoxExit(columnList[j])) {
            //查看两个方块的value是否相等
            if (checkGameBoxMerge(columnList[i], columnList[j])) {
              //定义变量，设置循环完成之后方块的移动信息
              int boxMovePosition = i;
              //遍历查询方块应该移动的位置
              for (int k = i + 1; k < columnList.length; k++) {
                //如果当前方块不存在，继续遍历，一直查询到找到方块为止
                if (checkGameBoxExit(columnList[k])) {
                  boxMovePosition = k - 1;
                  break;
                }
              }
              //循环结束后，根据movePosition设置方块应该执行的操作
              if (boxMovePosition == i) {
                columnList[i]
                    .updateValue(columnList[i].value + columnList[j].value);
                _toatalScore += (columnList[i].value + columnList[j].value);
                columnList[j].updateValue(null);
                columnList[j].startAnimation(
                    _gameBoxList[columnList[i].position].position, isVertical);
              } else {
                _toatalScore += (columnList[i].value + columnList[j].value);
                columnList[boxMovePosition]
                    .updateValue(columnList[i].value + columnList[j].value);
                columnList[i].updateValue(null);
                columnList[j].updateValue(null);
                columnList[i]
                    .startAnimation(columnList[0].position, isVertical);
                columnList[j]
                    .startAnimation(columnList[0].position, isVertical);
                _needBuildNextBox = true;
              }
              //找到之后移动位置之后跳出循环
              break;
            } else {
              break;
            }
          }
        }
        //没有找到和row[i]一样的方块,查看row[i]是否需要移动
        int movePosition = columnList.length - 1;
        for (int m = columnList.length - 1; m > i; m--) {
          if (checkGameBoxExit(columnList[m])) {
            movePosition = m - 1;
          }
        }
        if (movePosition != i) {
          print("需要移动的position $i,需要移动到的位置： $movePosition");
          //将movePosition的方块设置为当前的方块值，将当前的方块值重置为null
          _gameBoxList[columnList[movePosition].position]
              .updateValue(_gameBoxList[columnList[i].position].value);
          _gameBoxList[columnList[i].position].updateValue(null);

          _gameBoxList[columnList[i].position].startAnimation(
              _gameBoxList[columnList[movePosition].position].position,
              isVertical);

          _needBuildNextBox = true;
        }
      }
    }
  }

  //水平方向向右滑动
  void moveHorRight(List<GameBoxWidget> rowList) {
    print("向右滑动");
    //水平方向向右滑动和水平方向向左滑动逻辑是一样的，只是循环的时候是从后到前的
    for (int i = rowList.length - 1; i > -1; i--) {
      if (checkGameBoxExit(rowList[i])) {
        //查看剩余方块中有没有可以合并的
        for (int j = i - 1; j > -1; j--) {
          if (checkGameBoxExit(rowList[j])) {
            if (checkGameBoxMerge(rowList[i], rowList[j])) {
              //找到了和当前方块数值一样的方块
              //查找i的右边是否有可以滑动的位置
              for (int k = i + 1; k < rowList.length; k++) {
                if (checkGameBoxExit(rowList[k])) {
                  if (k - 1 == i) {
                    //将i的value设置为i + j的value，并移动j的位置
                    rowList[i].updateValue(rowList[i].value + rowList[j].value);
                    _toatalScore += (rowList[i].value + rowList[j].value);
                    rowList[j].updateValue(null);
                    rowList[j].startAnimation(
                        _gameBoxList[rowList[i].position].position, false);
                  } else {
                    //查找到右边第一个存在的方块，比较这两个方块的位置
                    rowList[k - 1]
                        .updateValue(rowList[i].value + rowList[j].value);
                    _toatalScore += (rowList[i].value + rowList[j].value);
                    rowList[i].updateValue(null);
                    rowList[j].updateValue(null);
                    //移动i和j两个方块
                    rowList[i].startAnimation(
                        _gameBoxList[rowList[k - 1].position].position, false);
                    rowList[j].startAnimation(
                        _gameBoxList[rowList[k - 1].position].position, false);
                    _needBuildNextBox = true;
                  }
                }
              }
              //循环结束，没有找到不为空的方块，
              if (i == rowList.length - 1) {
                rowList[i].updateValue(rowList[i].value + rowList[j].value);
                _toatalScore += (rowList[i].value + rowList[j].value);
                rowList[j].updateValue(null);
                rowList[j].startAnimation(
                    _gameBoxList[rowList[i].position].position, false);
              } else {
                rowList[rowList.length - 1]
                    .updateValue(rowList[i].value + rowList[j].value);
                _toatalScore += (rowList[i].value + rowList[j].value);
                rowList[i].updateValue(null);
                rowList[j].updateValue(null);
                rowList[i].startAnimation(rowList[0].position, false);
                rowList[j].startAnimation(rowList[0].position, false);
                _needBuildNextBox = true;
              }
            } else {
              //如果存在但是不一样，跳出循环
              break;
            }
          }
        }
        //没有找到和row[i]一样的方块,查看row[i]是否需要移动
        int movePosition = rowList.length - 1;
        for (int m = rowList.length - 1; m > i; m--) {
          if (checkGameBoxExit(rowList[m])) {
            movePosition = m - 1;
          }
        }
        if (movePosition != i) {
          print("需要移动的position $i,需要移动到的位置： $movePosition");
          //将movePosition的方块设置为当前的方块值，将当前的方块值重置为null
          _gameBoxList[rowList[movePosition].position]
              .updateValue(_gameBoxList[rowList[i].position].value);
          _gameBoxList[rowList[i].position].updateValue(null);

          _gameBoxList[rowList[i].position].startAnimation(
              _gameBoxList[rowList[movePosition].position].position, false);

          _needBuildNextBox = true;
        }
      }
    }
  }

  //水平方向向左滑动
  void moveHorLeft(List<GameBoxWidget> rowList) {
    for (int i = 0; i < rowList.length; i++) {
      if (checkGameBoxExit(rowList[i])) {
        //查看剩余方块中有没有可以合并的
        for (int j = i + 1; j < rowList.length; j++) {
          if (checkGameBoxExit(rowList[j])) {
            if (checkGameBoxMerge(rowList[i], rowList[j])) {
              //找到了和当前方块数值一样的方块
              //查找i的左边是否有可以滑动的位置
              for (int k = i - 1; k > -1; k--) {
                if (checkGameBoxExit(rowList[k])) {
                  if (k + 1 == i) {
                    //将i的value设置为i + j的value，并移动j的位置
                    rowList[i].updateValue(rowList[i].value + rowList[j].value);
                    _toatalScore += (rowList[i].value + rowList[j].value);
                    rowList[j].updateValue(null);
                    rowList[j].startAnimation(
                        _gameBoxList[rowList[i].position].position, false);
                  } else {
                    //查找到左边第一个存在的方块，比较这两个方块的位置
                    rowList[k + 1]
                        .updateValue(rowList[i].value + rowList[j].value);
                    _toatalScore += (rowList[i].value + rowList[j].value);
                    rowList[i].updateValue(null);
                    rowList[j].updateValue(null);
                    //移动i和j两个方块
                    rowList[i].startAnimation(
                        _gameBoxList[rowList[k + 1].position].position, false);
                    rowList[j].startAnimation(
                        _gameBoxList[rowList[k + 1].position].position, false);
                    _needBuildNextBox = true;
                  }
                }
              }
              print(
                  "没有找到同一行左边的方块，移动到最左边:${rowList[i].value + rowList[j].value},要移动到的位置${rowList[0].position}");
              //循环结束，没有找到不为空的方块，
              if (i == 0) {
                rowList[i].updateValue(rowList[i].value + rowList[j].value);
                _toatalScore += (rowList[i].value + rowList[j].value);
                rowList[j].updateValue(null);
                rowList[j].startAnimation(
                    _gameBoxList[rowList[i].position].position, false);
              } else {
                int moveValue = rowList[i].value + rowList[j].value;
                _gameBoxList[rowList[0].position].updateValue(moveValue);
                _toatalScore += (rowList[i].value + rowList[j].value);
                rowList[i].updateValue(null);
                rowList[j].updateValue(null);
                rowList[i].startAnimation(rowList[0].position, false);
                rowList[j].startAnimation(rowList[0].position, false);
                _needBuildNextBox = true;
                continue;
              }
            } else {
              //如果存在但是不一样，跳出循环
              break;
            }
          }
        }
        //没有找到和row[i]一样的方块,查看row[i]是否需要移动
        int movePosition = 0;
        for (int m = 0; m < i; m++) {
          if (checkGameBoxExit(rowList[m])) {
            movePosition = m + 1;
          }
        }
        if (movePosition != i || movePosition == rowList.length) {
          //将movePosition的方块设置为当前的方块值，将当前的方块值重置为null
          _gameBoxList[rowList[movePosition].position]
              .updateValue(_gameBoxList[rowList[i].position].value);
          _gameBoxList[rowList[i].position].updateValue(null);

          _gameBoxList[rowList[i].position].startAnimation(
              _gameBoxList[rowList[movePosition].position].position, false);

          _needBuildNextBox = true;
        }
      }
    }
  }

  //生成下一个随机的方块
  void _generalNextRandonBox() {
    int randomPosition = generalPoaition();
    if (randomPosition > -1) {
      _gameBoxList[randomPosition].updateValue(generatorRandom());
    } else {
      print("没有可用的方块，游戏结束");
    }
  }

  //查看当前方块是否存在
  bool checkGameBoxExit(GameBoxWidget widget) {
    if (widget.value != null && widget.value > 0) {
      return true;
    }
    return false;
  }

  //查看两个方块是否可以合并
  bool checkGameBoxMerge(GameBoxWidget widget1, GameBoxWidget widget2) {
    if (widget1.value == widget2.value) {
      return true;
    }
    return false;
  }

  //在0~15之间生成一个随机数
  int generalPoaition() {
    //首先循环遍历查看是否所有的方块都被填充
    bool allIn = true;
    for (var i = 0; i < _gameBoxList.length; i++) {
      if (_gameBoxList[i].value == null || _gameBoxList[i].value < 2) {
        allIn = false;
        break;
      }
    }
    if (allIn) {
      return -1;
    }

    int generalPosition;
    do {
      generalPosition = Random().nextInt(16);
    } while (_gameBoxList[generalPosition].value != null &&
        _gameBoxList[generalPosition].value > 0);

    return generalPosition;
  }

  //生成一个2或者4的随机数
  int generatorRandom() {
    int value;
    do {
      value = Random().nextInt(5);
    } while (value != 2 && value != 4);

    return value;
  }
}
