import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_offline_order/bloc/blocGetOp.dart';
import 'package:qr_offline_order/bloc/blocQRReader.dart';
import 'package:qr_offline_order/bloc/blocSetting.dart';
import 'package:qr_offline_order/data/databaseHelper.dart';
import 'package:qr_offline_order/function/httpRequest.dart';
import 'package:qr_offline_order/model/setting.dart';
import 'package:qr_offline_order/widget/dialogError.dart';
import 'package:qr_offline_order/library/libraryFontStyle.dart' as textStyle;
import 'package:qr_offline_order/library/librarySetting.dart' as appsSetting;
import 'package:qr_offline_order/screen/splashScreen.dart';

AppBar getAppBar(String text, BuildContext context, int index){
  var db = DatabaseHelper();
  Widget iconButton(){
    //-if index == 0 (button for clear list), if index == 1 (button for save setting)
    if(index == 0){
      return StreamBuilder<List>(
        stream: blocQRReader.subject.stream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.length > 0){
              return IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        content: Text('Clear List?', style: textStyle.txtStyleTilteDialog),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No', style: textStyle.txtFlatButton),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text('Delete', style: textStyle.txtFlatButton),
                            onPressed: (){
                              blocQRReader.clearList();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }
                  );
                },
              );
            } else {
              return IconButton(
                icon: Icon(Icons.delete, color: Colors.grey),
                onPressed: null,
              );
            }
          } return Row();
        },
      );
    } else if(index == 1){
      return StreamBuilder<Setting>(
        stream: blocSetting.subject.stream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.apiUrl != null){
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  final setting = Setting(
                    id: 1,
                    apiUrl: snapshot.data.apiUrl,
                    endPointGetPlu: snapshot.data.endPointGetPlu,
                    endPointSendData: snapshot.data.endPointSendData,
                    endPointGetOperator: snapshot.data.endPointGetOperator,
                    endPointGetModifier: snapshot.data.endPointGetModifier,
                    passwordSpv: snapshot.data.passwordSpv,
                    passwordAuth: snapshot.data.passwordAuth,
                    currency: snapshot.data.currency,
                    decimalPoint: snapshot.data.decimalPoint,
                    changeOperator: snapshot.data.changeOperator,
                    editOrder: snapshot.data.editOrder,
                    auth: snapshot.data.auth,
                    tableOveride: snapshot.data.tableOveride,
                    cover: snapshot.data.cover
                  );
                  Future<int> updateDb = db.updateSetting(setting);
                  updateDb.then((data){
                    if(data == 1){
                      appsSetting.apiUrl = snapshot.data.apiUrl;
                      appsSetting.endpointGetPlu = snapshot.data.endPointGetPlu;
                      appsSetting.endpointSendData = snapshot.data.endPointSendData;
                      appsSetting.endpointGetOperator = snapshot.data.endPointGetOperator;
                      appsSetting.endpointGetModifier = snapshot.data.endPointGetModifier;
                      appsSetting.passwordSpv = snapshot.data.passwordSpv;
                      appsSetting.passwordAuth = snapshot.data.passwordAuth;
                      appsSetting.currency = snapshot.data.currency;
                      appsSetting.decimalPoint = snapshot.data.decimalPoint;
                      appsSetting.editOrder = (snapshot.data.editOrder == 1)? true: false;
                      appsSetting.auth = (snapshot.data.auth == 1)? true: false;
                      appsSetting.tableOveride = (snapshot.data.tableOveride == 1)? true: false;
                      appsSetting.cover = (snapshot.data.cover == 1)? true : false;
                      //showDialogError(context, 'Success Update Setting', 1);
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            content: Text('Success Update Setting'),
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
                      getPlu();
                      getOperator();
                      getModifier();
                      if(appsSetting.changeOperator != (snapshot.data.changeOperator == 1)? true: false){
                        appsSetting.changeOperator = (snapshot.data.changeOperator == 1)? true: false;
                        blocSetOperator.clearIndexOperator();
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              content: Text('Success update setting, please login'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Close', style: TextStyle(
                                    color: Colors.black
                                  )),
                                  onPressed: (){
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                      builder: (context) => SplashScreen()
                                    ), (Route<dynamic> route) => false);
                                  },
                                )
                              ],
                            );
                          }
                        );
                      }
                    } else {
                      showDialogError(context, 'Failed Update Setting', 1);
                    }
                  });
                },
              );
            } else {
              return IconButton(
                icon: Icon(Icons.save, color: Colors.grey),
                onPressed: null,
              );
            }
          } else {
            return IconButton(
                icon: Icon(Icons.save, color: Colors.grey),
                onPressed: null,
              );
          }
        },
      );
    } else {
      return Row();
    }
  }

  return AppBar(
    title: Text(text),
    actions: <Widget>[
      iconButton()
    ],
  );
}