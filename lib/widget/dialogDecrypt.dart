import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_offline_order/bloc/blocDecrypt.dart';
import 'package:qr_offline_order/bloc/blocPluList.dart';
import 'package:qr_offline_order/bloc/blocQRReader.dart';
import 'package:qr_offline_order/bloc/blocResponseAPI.dart';
import 'package:qr_offline_order/bloc/blocGetModifier.dart';
import 'package:qr_offline_order/library/librarySizeConfig.dart';
import 'package:qr_offline_order/library/libraryFontStyle.dart' as textStyle;
import 'package:qr_offline_order/library/librarySetting.dart' as appsSetting;
import 'package:qr_offline_order/model/pluList.dart';
import 'package:qr_offline_order/model/modifier.dart';
import 'package:qr_offline_order/widget/dialogError.dart';
import 'custom_icons_icons.dart';

class DialogDecrypt{
  var response;
  NumberFormat numberFormat(){
    if(appsSetting.decimalPoint == 0){
      return NumberFormat("#,##0", "en_US");
    } else if (appsSetting.decimalPoint == 1) {
      return NumberFormat("#,##0.0", "en_US");
    } else {
      return NumberFormat("#,##0.00", "en_US");
    }
  }

  void _sendData(String bodyString, BuildContext context){
    blocRespApi.sendToApi(bodyString).catchError((e){
      Navigator.pop(context);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Failed send data'),
            content: Text('Check your connection or URL in setting page'),
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
    });
  }

  void showDialogDecrypt(BuildContext context){
    var _textFieldValue = '';
    var _textCoverValue = '';
    final _formKey = GlobalKey<FormState>();
    final _keyCover = GlobalKey<FormState>();
    String oldMap = '';
    final occy = numberFormat();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context){
        SizeConfig().init(context);
        return Scaffold(
          appBar: AppBar(
            leading: Container(),
          ),
          body: StreamBuilder(
            stream: blocDecrypt.subject.stream,
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(snapshot.data.length > 0){
                  //print(snapshot.data);
                  if(snapshot.data.contains('Time')){
                    var data = json.decode(snapshot.data);
                    List prepItem = [];
                    List masterItem = [];
                    List modifier = [];
                    List customModifier = [];
                    for (var i = 0; i < data['Orders'].length; i++) {
                      var itemType;
                      if(data['Orders'][i][3] is String){
                        itemType = data['Orders'][i][3];
                      } else {
                        itemType = data['Orders'][i][3].toString();
                      }
                      if(itemType == "1"){
                        prepItem.add(data['Orders'][i]);
                      } else if(itemType == "0"){
                        masterItem.add(data['Orders'][i]);
                      } else if(itemType == "2"){
                        modifier.add(data['Orders'][i]);
                      } else if(itemType == "3"){
                        customModifier.add(data['Orders'][i]);
                      }
                    }

                    if(snapshot.data.contains('TableNo')){
                      _textFieldValue = data['TableNo'];
                    }

                    if(snapshot.data.contains('Cover')){
                      _textCoverValue = data['Cover'].toString();
                    }
                    

                    Future scanTable() async {
                      Map<String, dynamic> mapTable = jsonDecode(snapshot.data);
                      try {
                        String barcode = await BarcodeScanner.scan();
                        mapTable['TableNo'] = barcode;
                        var bodyString = json.encode(mapTable);
                        blocDecrypt.editQuantity(bodyString);
                      } catch (e) {
                        print(e.toString());
                      }
                    }

                    Widget txtTableOveride(){
                      if(appsSetting.tableOveride){
                        return TextFormField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: _textFieldValue,
                              selection: TextSelection.collapsed(offset: _textFieldValue.length)
                            )
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            labelText: 'Table No.',
                            suffixIcon: IconButton(
                              icon: Icon(
                                CustomIcons.qrcode
                              ),
                              onPressed: (){
                                scanTable();
                              },
                            ),
                          ),
                          validator: (String value){
                            if(value.isEmpty){
                              return 'Empty table number';
                            }
                            return null;
                          },
                          onChanged: (value){
                            data['TableNo'] = value;
                            String bodyString = json.encode(data);
                            blocDecrypt.editQuantity(bodyString);
                          },
                          onEditingComplete: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        );
                      } else {
                        return Row();
                      }
                    }

                    Widget txtCover(){
                      if(appsSetting.cover){
                        return TextFormField(
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: _textCoverValue,
                              selection: TextSelection.collapsed(offset: _textCoverValue.length)
                            )
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            labelText: 'Cover'
                          ),
                          validator: (String value){
                            if(value.isEmpty){
                              return 'Empty Cover';
                            }
                            return null;
                          },
                          onChanged: (value){
                            data['Cover'] = int.parse(value);
                            String bodyString = json.encode(data);
                            blocDecrypt.editQuantity(bodyString);
                          },
                          onEditingComplete: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        );
                      } else {
                        return Row();
                      }
                    }


                    //-Build listview master Item------------------------------------------
                    Widget listItem(){
                      return ListView.separated(
                        separatorBuilder: (context, snap){
                          return Divider(
                            color: Colors.black,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: masterItem.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          return Column(
                            children: <Widget>[
                              StreamBuilder<PluList>(
                                stream: blocPluList.subject.stream,
                                builder: (context, pluList){
                                  if(pluList.hasData){
                                    
                                    //-Build Row Qty---------------------------------------
                                    Row rowQty(){
                                      Map<String, dynamic> map = jsonDecode(snapshot.data);
                                      Icon iconButton(){
                                        if(int.parse(map['Orders'][masterItem[index][0]][1]) > 1){
                                          return Icon(Icons.remove);
                                        } else {
                                          return Icon(Icons.clear);
                                        }
                                      }

                                      if(!oldMap.contains('Orders')){
                                        String jsonString = json.encode(map);
                                        oldMap = jsonString;
                                        //print('masuk');
                                      } else {
                                        //print('test');
                                      }
                                      
                                      void removeItems(){

                                        //-remove prep item and modifier-------------------
                                        List count = [];
                                        for (var i = 0; i < map['Orders'].length; i++) {
                                          if(map['Orders'][i][5] == map['Orders'][masterItem[index][0]][4]){
                                            count.add(map['Orders'][i]);
                                            print(count.toString());
                                          }
                                        }
                                        for (var b = 0; b < count.length; b++) {
                                          map['Orders'].removeWhere((item) => item[0] == count[b][0]);
                                        }
                                        //-------------------------------------------------

                                        //-remove master item------------------------------
                                        map['Orders'].removeAt(masterItem[index][0]);
                                        for (var i = 0; i < map['Orders'].length; i++) {
                                          map['Orders'][i][0] = i;
                                        }
                                        String bodyString = json.encode(map);
                                        blocDecrypt.editQuantity(bodyString);
                                      }

                                      if(appsSetting.editOrder){
                                        Map test = jsonDecode(oldMap);
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            IconButton(
                                              icon: iconButton(),
                                              onPressed: (){
                                                if(int.parse(map['Orders'][masterItem[index][0]][1]) > 1){
                                                  //-decrease qty prep item & modifier---
                                                  /*for (var i = 0; i < map['Orders'].length; i++) {
                                                    if(map['Orders'][i][5] == map['Orders'][masterItem[index][0]][4]){
                                                      map['Orders'][i][1] = (int.parse(map['Orders'][i][1]) - int.parse(test['Orders'][i][1])).toString();
                                                    }
                                                  }*/

                                                  //-decrease qty masterItem-------------
                                                  map['Orders'][masterItem[index][0]][1] = (int.parse(map['Orders'][masterItem[index][0]][1]) - 1).toString();
                                                  for (var i = 0; i < map['Orders'].length; i++) {
                                                    if(map['Orders'][i][5] == map['Orders'][masterItem[index][0]][4]){
                                                      map['Orders'][i][1] = map['Orders'][masterItem[index][0]][1];
                                                    }
                                                  }
                                                  String bodyString = json.encode(map);
                                                  blocDecrypt.editQuantity(bodyString);
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return AlertDialog(
                                                        content: StreamBuilder<PluList>(
                                                          stream: blocPluList.subject.stream,
                                                          builder: (context, snapshot){
                                                            if(snapshot.hasData){
                                                              for(var listPlu in pluList.data.message){
                                                                if(listPlu.plunumber == map['Orders'][masterItem[index][0]][2].toString()){
                                                                  return Text('Remove item ${listPlu.pluname} ?');
                                                                }
                                                              } return Row();
                                                            } else {
                                                              return Row();
                                                            }
                                                          },
                                                        ),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            child: Text('No', style: TextStyle(
                                                              color: Colors.black
                                                            )),
                                                            onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            child: Text('Yes', style: TextStyle(
                                                              color: Colors.black
                                                            )),
                                                            onPressed: (){
                                                              removeItems();
                                                              Navigator.pop(context);
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    }
                                                  );
                                                }
                                              },
                                            ),
                                            Text(masterItem[index][1],
                                                  style: textStyle.txtStyleContentDialog),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: (){
                                                //-increase qty masterItem---------------
                                                map['Orders'][masterItem[index][0]][1] = (int.parse(map['Orders'][masterItem[index][0]][1]) + 1).toString();
                                                
                                                //-increase qty modifier & prepItem------
                                                for (var i = 0; i < map['Orders'].length; i++) {
                                                  if(map['Orders'][i][5] == map['Orders'][masterItem[index][0]][4]){
                                                    map['Orders'][i][1] = map['Orders'][masterItem[index][0]][1];
                                                  }
                                                }
                                                /*for (var i = 0; i < map['Orders'].length; i++) {
                                                  if(map['Orders'][i][5] == map['Orders'][masterItem[index][0]][4]){
                                                    map['Orders'][i][1] = (int.parse(map['Orders'][i][1]) + int.parse(test['Orders'][i][1])).toString();
                                                  }
                                                }*/
                                                String bodyString = json.encode(map);
                                                blocDecrypt.editQuantity(bodyString);
                                              },
                                            )
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(masterItem[index][1].toString(),
                                              style: textStyle.txtStyleContentDialog)
                                          ],
                                        );
                                      }
                                    }

                                    for(var listPlu in pluList.data.message){
                                      if(listPlu.plunumber == masterItem[index][2].toString()){
                                        var frmtAmount = listPlu.sell1 * int.parse(masterItem[index][1]);
                                        var frmtCurrency = occy.format(frmtAmount);
                                        return Row(
                                          children: <Widget>[
                                            Container(
                                              width: SizeConfig.safeBlockHorizontal * 7,
                                              child: Text((index + 1).toString(),
                                                style: textStyle.txtStyleContentDialog),
                                            ),
                                            Container(
                                              width: SizeConfig.safeBlockHorizontal * 33,
                                              child: Text(listPlu.pluname, style: textStyle.txtStyleContentDialog),
                                            ),
                                            Container(
                                              width: SizeConfig.safeBlockHorizontal * 30,
                                              child: rowQty()
                                            ),
                                            Container(
                                              width: SizeConfig.safeBlockHorizontal * 20,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    width: SizeConfig.safeBlockHorizontal * 5,
                                                    child: Text(appsSetting.currency, style: textStyle.txtStyleContentDialog),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(frmtCurrency, style: textStyle.txtStyleContentDialog),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    } return Row(
                                        children: <Widget>[
                                          Container(
                                            width: SizeConfig.safeBlockHorizontal * 7,
                                            child: Text((index + 1).toString(),
                                                style: textStyle.txtStyleContentDialog),
                                          ),
                                          Container(
                                            width: SizeConfig.safeBlockHorizontal * 60,
                                            child: Text('PLU ${masterItem[index][2]} NOT FOUND',
                                              style: textStyle.txtStyleContentDialog),
                                          ),
                                        ],
                                      );
                                  } return Row();
                                },
                              ),

                              //-Build listview prep item--------------------------------
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: prepItem.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, prepIndex){
                                  if(prepItem[prepIndex][5] == masterItem[index][4]){
                                    return StreamBuilder<PluList>(
                                      stream: blocPluList.subject.stream,
                                      builder: (context, pluList){
                                        if(pluList.hasData){
                                          for(var listPlu in pluList.data.message){
                                            if(listPlu.plunumber == prepItem[prepIndex][2].toString()){
                                              var frmtAmount = listPlu.sell1 * int.parse(prepItem[prepIndex][1]);
                                              var frmtCurrency = occy.format(frmtAmount);
                                              return Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: SizeConfig.safeBlockHorizontal * 7,
                                                  ),
                                                  Container(
                                                    width: SizeConfig.safeBlockHorizontal * 33,
                                                    child: Text("++ "+listPlu.pluname,
                                                      style: textStyle.txtStyleContentDialog),
                                                  ),
                                                  Container(
                                                    width: SizeConfig.safeBlockHorizontal * 30,
                                                    //child: Text(prepItem[prepIndex][1]),
                                                  ),
                                                  Container(
                                                    width: SizeConfig.safeBlockHorizontal * 20,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Container(
                                                          width: SizeConfig.safeBlockHorizontal * 5,
                                                          //child: Text(appsSetting.currency, style: textStyle.txtStyleContentDialog),
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(frmtCurrency, style: textStyle.txtStyleContentDialog),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              );
                                            }
                                          }
                                        } return Row(
                                          children: <Widget>[
                                            Container(
                                              width: SizeConfig.safeBlockHorizontal * 7,
                                            ),
                                            Container(
                                              width: SizeConfig.safeBlockHorizontal * 60,
                                              child: Text('++ PLU ${prepItem[prepIndex][2]} NOT FOUND',
                                                style: textStyle.txtStyleContentDialog),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    return Row();
                                  }
                                },
                              ),

                              //-Build listview modifier---------------------------------
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: modifier.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, modIndex){
                                  if (modifier[modIndex][5] == masterItem[index][4]){
                                    return StreamBuilder<Modifier>(
                                      stream: blocGetModifier.subject.stream,
                                      builder: (context, snapshot){
                                        if(snapshot.hasData){
                                          for(var listModifier in snapshot.data.message){
                                            if(listModifier.msgid == double.parse(modifier[modIndex][2])){
                                              return Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: SizeConfig.safeBlockHorizontal * 7,
                                                  ),
                                                  Container(
                                                    width: SizeConfig.safeBlockHorizontal * 33,
                                                    child: Text(">> "+listModifier.message,
                                                      style: textStyle.txtStyleContentDialog),
                                                  ),
                                                  Container(
                                                    width: SizeConfig.safeBlockHorizontal * 30,
                                                    //child: Text(modifier[modIndex][1]),
                                                  ),
                                                ],
                                              );
                                            }
                                          }
                                        }
                                        return Row(
                                          children: <Widget>[
                                            Container(
                                              width: SizeConfig.safeBlockHorizontal * 7,
                                            ),
                                            Container(
                                              width: SizeConfig.safeBlockHorizontal * 60,
                                              child: Text('>> Modifier ${modifier[index][2]} NOT FOUND',
                                                style: textStyle.txtStyleContentDialog),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    return Row();
                                  }
                                },
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: customModifier.length,
                                itemBuilder: (context, cusModindex){
                                  if(customModifier[cusModindex][5] == masterItem[index][4]){
                                    return Row(
                                      children: <Widget>[
                                        Container(
                                          width: SizeConfig.safeBlockHorizontal * 7,
                                        ),
                                        Container(
                                          width: SizeConfig.safeBlockHorizontal * 33,
                                          child: Text("** "+customModifier[cusModindex][2],
                                            style: textStyle.txtStyleContentDialog),
                                        ),
                                        Container(
                                          width: SizeConfig.safeBlockHorizontal * 30,
                                        )
                                      ],
                                    );
                                  } else {
                                    return Row();
                                  }
                                },
                              )
                            ],
                          );
                        },
                      );
                    }

                    return Container(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 16, right: 16, top: 16),
                          child: Wrap(
                            children: <Widget>[
                              Text('Order Code : '+data['OrderCode'],
                                style: textStyle.txtStyleTilteDialog),
                              Divider(
                                color: Colors.black,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 11,
                                    child: Text('Name ',
                                      style: textStyle.txtStyleContentDialog),
                                    ),
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 50,
                                    child: Text(': '+data['Name'],
                                      style: textStyle.txtStyleContentDialog),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 11,
                                    child: Text('Time ',
                                      style: textStyle.txtStyleContentDialog),
                                  ),
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 50,
                                    child: Text(': '+data['Time'],
                                      style: textStyle.txtStyleContentDialog),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 11,
                                    child: Text('ETD ',
                                      style: textStyle.txtStyleContentDialog),
                                  ),
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 50,
                                    child: Text(': '+data['ETD'],
                                      style: textStyle.txtStyleContentDialog),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 11,
                                    child: Text('Paid ',
                                      style: textStyle.txtStyleContentDialog),
                                  ),
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 50,
                                    child: Text(': '+data['Paid'].toString(),
                                      style: textStyle.txtStyleContentDialog),
                                  )
                                ],
                              ),
                              Form(
                                key: _formKey,
                                child: txtTableOveride(),
                              ),
                              Form(
                                key: _keyCover,
                                child: txtCover(),
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 7,
                                    child: Text('No', style: textStyle.txtStleTitleTable),
                                  ),
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 33,
                                    child: Text('Plu Name', style: textStyle.txtStleTitleTable),
                                  ),
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Qty', style: textStyle.txtStleTitleTable)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: SizeConfig.safeBlockHorizontal * 20,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Price', style: textStyle.txtStleTitleTable),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              SingleChildScrollView(child: listItem()),
                              Divider(
                                color: Colors.black,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              ListTile(
                                title: Text('Send', style: TextStyle(fontWeight: FontWeight.bold)),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: (){
                                  Map<String, dynamic> newMap = jsonDecode(snapshot.data);
                                  if(newMap['Orders'].length > 0){
                                    if(_formKey.currentState.validate()){
                                      if(_keyCover.currentState.validate()){
                                        newMap['RaptorWCFKey'] = appsSetting.passwordAuth;
                                        if(appsSetting.changeOperator){
                                          newMap['Operator'] = appsSetting.operatorID;
                                        }
                                        var bodyString = json.encode(newMap);
                                        _sendData(bodyString, context);
                                        showDialogResponse(context, data['OrderCode']);
                                      }
                                    }
                                  } else {
                                    showDialogError(context, 'Error!, Empty Item', 1);
                                  }
                                },
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              ListTile(
                                title: Text('Close', style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return AlertDialog(
                      content: Container(
                        height: 155,
                        child: Column(
                          children: <Widget>[
                            Text(snapshot.data.toString())
                          ],
                        ),
                      ),
                    );
                  }
                } return Row();
              } else {
                return Row();
              }
            },
          ),
        );
      }
    );
  }

  Future<bool> _onWillPop(){
    return Row() ?? false;
  }

  //-Dialog Send Data to Database----------------------------------------------------
  void showDialogResponse(BuildContext context, String orderId){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return WillPopScope(
          onWillPop: _onWillPop,
          child: StreamBuilder(
            stream: blocRespApi.subject.stream,
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(snapshot.data.data['Success'] == 1){
                  blocQRReader.clearList();
                  return AlertDialog(
                    title: Text('Order Code : '+orderId),
                    content: Container(
                      height: 150,
                      child: Column(
                      children: <Widget>[
                        Text(snapshot.data.data['Message']),
                      ],
                    )
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close', style: textStyle.txtFlatButton),
                        onPressed: (){
                          blocRespApi.clearBloc();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                } else {
                  return AlertDialog(
                    title: Text('Order Code : '+orderId),
                    content: Container(
                      height: 150,
                      child: Column(
                        children: <Widget>[
                          Text(snapshot.data.data['Message'])
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close', style: textStyle.txtFlatButton),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                }
              } return AlertDialog(
                content: Container(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text('Please Wait', style: TextStyle(
                        fontSize: appsSetting.fontSizeContent
                      ))
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }
  
}