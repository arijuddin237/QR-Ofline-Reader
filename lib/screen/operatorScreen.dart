import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qr_offline_order/screen/homeScreen.dart';
import 'package:qr_offline_order/screen/settingScreen.dart';
import 'package:qr_offline_order/widget/appbar.dart';
import 'package:qr_offline_order/bloc/blocGetOp.dart';
import 'package:qr_offline_order/bloc/blocError.dart';
import 'package:qr_offline_order/model/operator.dart';
import 'package:qr_offline_order/data/databaseHelper.dart';
import 'package:qr_offline_order/library/librarySetting.dart' as appsSetting;

class OperatorScreen extends StatefulWidget {
  @override
  _OperatorScreenState createState() => _OperatorScreenState();
}

class _OperatorScreenState extends State<OperatorScreen> {
  var db = DatabaseHelper();
  final f = DateFormat('hh:mm a');

  void _showAuthDialog(context, int index){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return StreamBuilder<Operator>(
          stream: blocGetOperator.subject.stream,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  children: <Widget>[
                    Text('Choose Operator ${snapshot.data.message[index].operatorName} ?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Divider(
                      color: Colors.black,
                    ),
                    ListTile(
                      title: Text('Yes'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) => HomeScreen()
                        ), (Route<dynamic> route) => false);
                        blocSetOperator.setOperatorIndex(index);
                        appsSetting.loginTime = f.format(DateTime.now());
                      },
                    ),
                  ],
                ),
              ),
            );
            } else {
              return Row();
            }
          },
        );
      }
    );
  }

  Widget stremBuilderGetOp(){
    return StreamBuilder<Operator>(
      stream: blocGetOperator.subject.stream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return ListView.separated(
            separatorBuilder: (context, index){
              return Divider(
                color: Colors.black,
              );
            },
            itemCount: snapshot.data.message.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text('Operator Number : '+snapshot.data.message[index].operatorNo.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
                leading: Image.asset('image/user.png'),
                subtitle: Text('Operator Name : '+snapshot.data.message[index].operatorName),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: (){
                  _showAuthDialog(context, index);
                },
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: blocError.subject.stream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          if(snapshot.data.length > 0){
            /*if(snapshot.data.contains('Authentication')){
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Error!'),
                    content: Text('Authentication Failed, please check authentication setting'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close'),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                }
              );
            }*/
            Widget textError(){
              if(snapshot.data.contains('Authentication')){
                return Text('Authentication Failed, please check authentication setting', style: TextStyle(fontSize: 14));
              } else {
                return Text('Cannot connect to database ${appsSetting.apiUrl}', style: TextStyle(fontSize: 14));
              }
            }
            return Scaffold(
              appBar: getAppBar('QR Offline Order', context, 1),
              body: Stack(
                children: <Widget>[
                  SettingScreen(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      elevation: 10,
                      color: Colors.orange[700],
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: textError()
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            );
          } else {
            return Scaffold(
              appBar: getAppBar('Choose Operator', context, 2),
              body: stremBuilderGetOp(),
            );
          }
        } else {
          return Scaffold(
            appBar: getAppBar('Choose Operator', context, 2),
            body: stremBuilderGetOp(),
          );
        }
      },
    );
  }
}