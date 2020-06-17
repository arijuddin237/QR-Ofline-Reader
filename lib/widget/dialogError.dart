import 'package:flutter/material.dart';
import 'package:qr_offline_order/function/httpRequest.dart';
import 'package:qr_offline_order/library/librarySetting.dart' as appsSetting;

void showDialogError(BuildContext context, String errorText, int target){
  showDialog(
    context: context,
    builder: (BuildContext context){
      if(target == 1){
        return AlertDialog(
          content: Text(errorText, style: TextStyle(
            fontSize: appsSetting.fontSizeContent
          )),
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
      } else{
        return AlertDialog(
          content: Text(errorText, style: TextStyle(
            fontSize: appsSetting.fontSizeContent
          )),
          actions: <Widget>[
            FlatButton(
              child: Text('Close', style: TextStyle(
                color: Colors.black
              )),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Reconnect!', style: TextStyle(
                color: Colors.black
              )),
              onPressed: (){
                getPlu();
                getOperator();
                getModifier();
                Navigator.pop(context);
              },
            )
          ],
        );
      } 
    }
  );
}