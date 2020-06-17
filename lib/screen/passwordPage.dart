import 'package:flutter/material.dart';
import 'package:qr_offline_order/screen/operatorScreen.dart';
import 'package:qr_offline_order/library/librarySetting.dart' as appsSetting;

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController _controllerPassword = TextEditingController(); 
  final _formKey = GlobalKey<FormState>();

  Widget _buildLoginTextField(){
    return TextFormField(
      controller: _controllerPassword,
      //maxLength: 6,
      enableInteractiveSelection: false,
      obscureText: true,
      textInputAction: TextInputAction.go,
      onFieldSubmitted: (value){
        if(_formKey.currentState.validate()){
          if(_controllerPassword.text == appsSetting.passwordSpv){
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => OperatorScreen()
            ));
          }
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        labelText: 'Please input password',
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear
          ),
          onPressed: (){
            _controllerPassword.clear();
          },
        ),
      ),
      validator: (String value){
        if(value.isEmpty || value != appsSetting.passwordSpv){
          return 'Wrong Password';
        }
        return null;
      },
      /*onSaved: (String value){
        _password = value;
      },*/
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: getAppBar('QR Offline Order', context, 2),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * .25),
            Column(
              children: <Widget>[
                Image.asset('image/homescreenQrOffline.png', height: 300),
                SizedBox(height: 12),
                //Text('QR Offline Order', style: TextStyle(fontSize: 20))
              ],
            ),
            Text('Login :'),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: _buildLoginTextField(),
            ),
            //_buildEnterButton(context)
            RaisedButton(
              child: Text('Login'),
              onPressed: (){
                if(_formKey.currentState.validate()){
                  if(_controllerPassword.text == appsSetting.passwordSpv){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => OperatorScreen()
                    ));
                  }
                }
                //restData.getOperator();
              },
            )
          ],
        ),
      )
    );
  }
}

class MomentsButton extends RaisedButton {
  final String text;
  final Function action;

  MomentsButton({this.text, this.action});

  ButtonTheme getButton(BuildContext context){
    return ButtonTheme(
      minWidth: 116.0,
      height: 33.0,
      child: RaisedButton(
        color: Colors.black,
        child: Text(text, style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0))
        ),
        onPressed: (){
          //action();
        },
      ),
    );
  }
}