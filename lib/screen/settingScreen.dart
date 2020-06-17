import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_offline_order/bloc/blocSetting.dart';
import 'package:qr_offline_order/data/databaseHelper.dart';
import 'package:qr_offline_order/model/setting.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();
  var db = DatabaseHelper();
  bool readOnlyForm = true;
  bool passwordVisible = true;
  bool changeOperator = false;
  bool editOrder = false;
  bool authentication = false;
  bool tableOveride = false;
  bool cover = false;
  String password = 'testPassword';
  String dropdownValue = '1';
  Setting _setting = Setting();
  List splitEndPlu = [];

  TextEditingController cntrlApiUrl = TextEditingController();
  TextEditingController cntrlEndPointGetPlu = TextEditingController();
  TextEditingController cntrlEndPointSendData = TextEditingController();
  TextEditingController cntrlPassword = TextEditingController();
  TextEditingController cntrlCurrency = TextEditingController();
  TextEditingController cntrlDecimalPoint = TextEditingController();
  TextEditingController cntrlEndPointSellband = TextEditingController();
  TextEditingController cntrlEndPointGetOperator = TextEditingController();
  TextEditingController cntrlEndPointGetModifier = TextEditingController();
  TextEditingController cntrlPasswordAuthentication = TextEditingController();
  TextEditingController cntrlPasswordSpv = TextEditingController();

  @override
  void initState() {
    Future<List<Setting>> getDb = db.getSetting();
    getDb.then((data) {
      Setting setting = data[0];
      splitEndPlu = setting.endPointGetPlu.split('/');
      cntrlApiUrl.text = setting.apiUrl;
      cntrlEndPointGetPlu.text = splitEndPlu[0];
      dropdownValue = splitEndPlu[1];
      cntrlEndPointSendData.text = setting.endPointSendData;
      cntrlEndPointGetOperator.text = setting.endPointGetOperator;
      cntrlPasswordAuthentication.text = setting.passwordAuth;
      cntrlPasswordSpv.text = setting.passwordSpv;
      cntrlCurrency.text = setting.currency;
      cntrlDecimalPoint.text = setting.decimalPoint.toString();
      cntrlEndPointGetModifier.text = setting.endPointGetModifier;
      setState(() {
        changeOperator = (setting.changeOperator == 1) ? true : false;
        editOrder = (setting.editOrder == 1) ? true : false;
        authentication = (setting.auth == 1) ? true : false;
        tableOveride = (setting.tableOveride == 1) ? true : false;
        cover = (setting.cover == 1) ? true: false;
      });
      _setting = data[0];
    });
    super.initState();
  }

  //-Dialog password for update setting----------------------------------------------
  void dialogPassword() {
    cntrlPassword.text = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Setting'),
            content: Container(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: passwordVisible,
                  controller: cntrlPassword,
                  validator: (value) {
                    if (value != password) {
                      cntrlPassword.text = '';
                      return 'Wrong Password';
                    }
                    return null;
                  },
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Proses', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (cntrlPassword.text == password) {
                      setState(() {
                        readOnlyForm = false;
                        Navigator.pop(context);
                      });
                    }
                  }
                },
              )
            ],
          );
        });
  }

  //-Build textField API URL-------------------------------------------------------------
  Widget _textFieldAPIUrl() {
    return GestureDetector(
      onTap: () {
        if (readOnlyForm) {
          dialogPassword();
        }
      },
      child: Container(
        child: IgnorePointer(
          ignoring: readOnlyForm,
          child: TextField(
            controller: cntrlApiUrl,
            readOnly: readOnlyForm,
            decoration: InputDecoration(labelText: "API URL"),
            onChanged: (text) {
              _setting.apiUrl = text;
              blocSetting.onChangeHandler(_setting);
            },
          ),
        ),
      ),
    );
  }

  //-Build textField endpoint getPlu-----------------------------------------------------
  Widget _textFieldGetPlu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * .5,
          child: GestureDetector(
            onTap: () {
              if (readOnlyForm) {
                dialogPassword();
              }
            },
            child: Container(
              child: IgnorePointer(
                ignoring: readOnlyForm,
                child: TextField(
                  controller: cntrlEndPointGetPlu,
                  readOnly: readOnlyForm,
                  decoration: InputDecoration(labelText: "Endpoint Get PLU"),
                  onChanged: (text) {
                    _setting.endPointGetPlu = text + "/$dropdownValue";
                    blocSetting.onChangeHandler(_setting);
                  },
                ),
              ),
            ),
          ),
        ),
        Text('Sellband : ', style: TextStyle(fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () {
            if (readOnlyForm) {
              dialogPassword();
            }
          },
          child: DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
              _setting.endPointGetPlu = cntrlEndPointGetPlu.text + "/$newValue";
              blocSetting.onChangeHandler(_setting);
            },
            items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(value),
                  ));
            }).toList(),
          ),
        )
      ],
    );
  }

  //-Build textField endpoint sendData---------------------------------------------------
  Widget _textFieldSendData() {
    return GestureDetector(
      onTap: () {
        if (readOnlyForm) {
          dialogPassword();
        }
      },
      child: Container(
        child: IgnorePointer(
          ignoring: readOnlyForm,
          child: TextField(
            controller: cntrlEndPointSendData,
            readOnly: readOnlyForm,
            decoration: InputDecoration(labelText: "Endpoint Send Data"),
            onChanged: (text) {
              _setting.endPointSendData = text;
              blocSetting.onChangeHandler(_setting);
            },
          ),
        ),
      ),
    );
  }

  //-Build textField endpoint getOperator------------------------------------------------
  Widget _textFieldGetOperator() {
    return GestureDetector(
      onTap: () {
        if (readOnlyForm) {
          dialogPassword();
        }
      },
      child: Container(
        child: IgnorePointer(
          ignoring: readOnlyForm,
          child: TextField(
            controller: cntrlEndPointGetOperator,
            decoration: InputDecoration(labelText: "Endpoint Get Operator"),
            onChanged: (text) {
              _setting.endPointGetOperator = text;
              blocSetting.onChangeHandler(_setting);
            },
          ),
        ),
      ),
    );
  }

  //-Build textField endpoint getModifier------------------------------------------------
  Widget _textFieldGetModifier() {
    return GestureDetector(
      onTap: () {
        if (readOnlyForm) {
          dialogPassword();
        }
      },
      child: Container(
        child: IgnorePointer(
          ignoring: readOnlyForm,
          child: TextField(
            controller: cntrlEndPointGetModifier,
            decoration: InputDecoration(labelText: "Endpoint Get Modifier"),
            onChanged: (text) {
              _setting.endPointGetModifier = text;
              blocSetting.onChangeHandler(_setting);
            },
          ),
        ),
      ),
    );
  }

  //-Build switch authentication---------------------------------------------------------
  Widget _authentication() {
    return GestureDetector(
      onTap: () {
        if (readOnlyForm) {
          dialogPassword();
        }
      },
      child: Container(
        child: IgnorePointer(
            ignoring: readOnlyForm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 120,
                      child: Text('Authentication',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Switch(
                      activeColor: Colors.black,
                      inactiveThumbColor: Colors.grey,
                      value: authentication,
                      onChanged: (bool newValue) {
                        setState(() {
                          authentication = newValue;
                        });
                        _setting.auth = (newValue) ? 1 : 0;
                        blocSetting.onChangeHandler(_setting);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  child: IgnorePointer(
                    ignoring: !authentication,
                    child: TextField(
                      controller: cntrlPasswordAuthentication,
                      decoration:
                          InputDecoration(labelText: 'Password Authentication'),
                      obscureText: true,
                      onChanged: (text) {
                        _setting.passwordAuth = text;
                        blocSetting.onChangeHandler(_setting);
                      },
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  //-Build switch operator lock----------------------------------------------------------
  Widget _operatorLock() {
    return GestureDetector(
      onTap: () {
        if (readOnlyForm) {
          dialogPassword();
        }
      },
      child: Container(
        child: IgnorePointer(
            ignoring: readOnlyForm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        width: 120,
                        child: Text('Operator Lock',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Switch(
                      activeColor: Colors.black,
                      inactiveThumbColor: Colors.grey,
                      value: changeOperator,
                      onChanged: (bool newValue) {
                        setState(() {
                          changeOperator = newValue;
                        });
                        _setting.changeOperator = (newValue) ? 1 : 0;
                        blocSetting.onChangeHandler(_setting);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  child: IgnorePointer(
                    ignoring: !changeOperator,
                    child: TextField(
                      controller: cntrlPasswordSpv,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onChanged: (text) {
                        _setting.passwordSpv = text;
                        blocSetting.onChangeHandler(_setting);
                      },
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  //-Build switch edit order-------------------------------------------------------------
  Widget _editOrder() {
    return GestureDetector(
      onTap: () {
        if (readOnlyForm) {
          dialogPassword();
        }
      },
      child: Container(
        child: IgnorePointer(
            ignoring: readOnlyForm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 120,
                    child: Text('Edit Order',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Switch(
                  activeColor: Colors.black,
                  inactiveThumbColor: Colors.grey,
                  value: editOrder,
                  onChanged: (bool newValue) {
                    setState(() {
                      editOrder = newValue;
                    });
                    _setting.editOrder = (newValue) ? 1 : 0;
                    blocSetting.onChangeHandler(_setting);
                  },
                ),
                //Text('')
              ],
            )),
      ),
    );
  }

  //-Build switch tableNo Override-------------------------------------------------------
  Widget _tableNoOverride() {
    return GestureDetector(
      onTap: () {
        if (readOnlyForm) {
          dialogPassword();
        }
      },
      child: Container(
        child: IgnorePointer(
            ignoring: readOnlyForm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 120,
                    child: Text('Table No Overide',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Switch(
                  activeColor: Colors.black,
                  inactiveThumbColor: Colors.grey,
                  value: tableOveride,
                  onChanged: (bool newValue) {
                    setState(() {
                      tableOveride = newValue;
                    });
                    _setting.tableOveride = (newValue)? 1 : 0;
                    blocSetting.onChangeHandler(_setting);
                  },
                ),
                //Text('')
              ],
            )),
      ),
    );
  }

  //-Build switch cover------------------------------------------------------------------
  Widget _cover() {
    return GestureDetector(
      onTap: () {
        if (readOnlyForm) {
          dialogPassword();
        }
      },
      child: Container(
        child: IgnorePointer(
          ignoring: readOnlyForm,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 120,
                child: Text('Cover',
                    style: TextStyle(fontWeight: FontWeight.bold))),
              Switch(
                activeColor: Colors.black,
                inactiveThumbColor: Colors.grey,
                value: cover,
                onChanged: (bool newValue) {
                  setState(() {
                    cover = newValue;
                  });
                  _setting.cover = (newValue) ? 1 : 0;
                  blocSetting.onChangeHandler(_setting);
                },
              ),
            ],
          )),
      ),
    );
  }


  //-Build textField currency------------------------------------------------------------
  Widget _textFieldCurrency() {
    return TextField(
      controller: cntrlCurrency,
      decoration: InputDecoration(labelText: 'Currency'),
      onChanged: (value) {
        _setting.currency = value;
        blocSetting.onChangeHandler(_setting);
      },
    );
  }

  //-Build textField decimalPoint--------------------------------------------------------
  Widget _textFieldDecimalPoint() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: cntrlDecimalPoint,
      decoration: InputDecoration(labelText: 'Decimal Point of Price'),
      onChanged: (value) {
        _setting.decimalPoint = int.parse(value);
        blocSetting.onChangeHandler(_setting);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 100.0,
                color: Colors.grey[900],
                child: Image.asset('image/imageSetting.png'),
              ),
              GestureDetector(
                onTap: () {
                  if (readOnlyForm) {
                    dialogPassword();
                  }
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        _textFieldAPIUrl(),
                        _textFieldGetPlu(),
                        _textFieldSendData(),
                        _textFieldGetOperator(),
                        _textFieldGetModifier(),
                        _authentication(),
                        _operatorLock(),
                        _editOrder(),
                        _tableNoOverride(),
                        _cover()
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: <Widget>[
                    _textFieldCurrency(),
                    _textFieldDecimalPoint(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
