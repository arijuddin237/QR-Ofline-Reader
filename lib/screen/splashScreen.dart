import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qr_offline_order/bloc/blocError.dart';
import 'package:qr_offline_order/data/databaseHelper.dart';
import 'package:qr_offline_order/function/httpRequest.dart';
import 'package:qr_offline_order/model/setting.dart';
import 'package:qr_offline_order/screen/homeScreen.dart';
import 'package:qr_offline_order/screen/passwordPage.dart';
import 'package:qr_offline_order/library/librarySetting.dart' as appsSetting;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DatabaseHelper _db = DatabaseHelper();
  final f = DateFormat('hh:mm a');

  @override
  void initState() {
    Future<List<Setting>> getDb = _db.getSetting();
    getDb.then((data){
      Setting setting = data[0];
      appsSetting.apiUrl = setting.apiUrl;
      appsSetting.endpointGetPlu = setting.endPointGetPlu;
      appsSetting.endpointGetOperator = setting.endPointGetOperator;
      appsSetting.endpointGetModifier = setting.endPointGetModifier;
      appsSetting.endpointSendData = setting.endPointSendData;
      appsSetting.currency = setting.currency;
      appsSetting.decimalPoint = setting.decimalPoint;
      appsSetting.passwordSpv = setting.passwordSpv;
      appsSetting.passwordAuth = setting.passwordAuth;
      appsSetting.changeOperator = (setting.changeOperator == 1)? true:false;
      appsSetting.editOrder = (setting.editOrder == 1)? true:false;
      appsSetting.auth = (setting.auth == 1)? true:false;
      appsSetting.tableOveride = (setting.tableOveride == 1)? true:false;
      appsSetting.cover = (setting.cover == 1)? true : false;
      appsSetting.loginTime = f.format(DateTime.now());
      getPlu();
      getOperator();
      getModifier();
      blocError.addErrorText('2');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), _handleTapEvent);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('image/homescreenQrOffline.png')
              )
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .8,
              right: 20,
              left: 20
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  void _handleTapEvent() async {
    if(appsSetting.changeOperator){
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => PasswordScreen()
      ));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => HomeScreen()
      ));
    }
  }
}