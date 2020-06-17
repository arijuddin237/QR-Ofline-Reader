import 'package:flutter/material.dart';
import 'package:qr_offline_order/bloc/blocDecrypt.dart';
import 'package:qr_offline_order/bloc/blocError.dart';
import 'package:qr_offline_order/function/scan.dart';
import 'package:qr_offline_order/bloc/blocQRReader.dart';
import 'package:qr_offline_order/widget/dialogDecrypt.dart';

class FABBottomAppBarItem{
  IconData iconData;
  String text;
  FABBottomAppBarItem({this.iconData, this.text});
}

class FABBottomApBar extends StatefulWidget {

  FABBottomApBar({
    this.items,
    this.centerItemText,
    this.height : 60.0,
    this.iconSize : 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected
  }) {
    assert(this.items.length == 2 || this.items. length == 4);
  }

  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  _FABBottomApBarState createState() => _FABBottomApBarState();
}

class _FABBottomApBarState extends State<FABBottomApBar> {
  int _selectedIndex = 0;

  _updateIndex(int index){
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: (){
              onPressed(index);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.iconData, color: color, size: widget.iconSize),
                Text(
                  item.text,
                  style: TextStyle(color: color)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText ?? '',
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index){
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());
    return BottomAppBar(
      elevation: 3.0,
      shape: widget.notchedShape,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }
}

FloatingActionButton fabScan(context){
  return FloatingActionButton(
    backgroundColor: Colors.red,
    onPressed: (){
      scan(context);
    },
    tooltip: 'Scan Barcode',
    child: Icon(Icons.photo_camera),
    elevation: 3.0,
  );
}

FloatingActionButton fabDecrypt(context, encryptedData){
  return FloatingActionButton(
    backgroundColor: Colors.red,
    onPressed: (){
      DialogDecrypt().showDialogDecrypt(context);
      blocDecrypt.decryptData(encryptedData);
    },
    tooltip: 'Decrypt',
    child: Icon(Icons.lock_open),
    elevation: 3,
  );
}

void showAlertDialog(context, String text){
  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text('Close', style: TextStyle(
              color: Colors.black
            )),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      );
    }
  );
}

Widget floatActionButton(BuildContext context){
  return StreamBuilder<List>(
    stream: blocQRReader.subject.stream,
    builder: (context, snapshot){
      if(snapshot.hasData){
        if(snapshot.data.length > 0){
          List splitNumber;
          for (var i = 0; i < snapshot.data.length; i++) {
            splitNumber = snapshot.data[i][1].split('/');
          }
          if(splitNumber[0] == splitNumber[1]){
            return StreamBuilder(
              stream: blocError.subject.stream,
              builder: (context, snapError){
                if(snapError.hasData){
                    return FloatingActionButton(
                      backgroundColor: Colors.grey,
                      onPressed: (){
                        showAlertDialog(context, "Can't decrypt data, connectionError");
                      },
                      child: Icon(Icons.lock_open),
                      elevation: 3,
                    );
                } else {
                  return fabDecrypt(context, snapshot.data);
                }
              },
            );
          } else {
            return fabScan(context);
          }
        } else {
            return fabScan(context);
        }
      } else {
        return fabScan(context);
      }
    },
  );
}