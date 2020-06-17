import 'package:flutter/material.dart';
import 'package:qr_offline_order/screen/splashScreen.dart';
import 'package:qr_offline_order/screen/homeScreen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(21, 21, 21, 1),
        primaryColorLight: Color.fromRGBO(48, 48, 48, 1),
        primaryColorDark: Color.fromRGBO(00, 00, 00, 1),
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home' : (context) => HomeScreen(),
      },
      home: SplashScreen()
      //home: PasswordScreen(),
    );
  }
}