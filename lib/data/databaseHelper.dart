import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streamqflite/streamqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_offline_order/model/setting.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async{
    if(_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  var streamDb = StreamDatabase(_db);

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE SETTING(id INTEGER, apiUrl TEXT, endPointGetPlu TEXT,"
      "endPointSendData TEXT, currency TEXT, decimalPoint INTEGER, changeOperator BOOLEAN,"
      "editOrder BOOLEAN, auth BOOLEAN, tableOveride BOOLEAN,endPointGetOperator TEXT, endPointGetModifier TEXT,"
      "passwordSpv TEXT, passwordAuth TEXT, cover BOOLEAN)"
    );
    await db.execute(
      "INSERT INTO SETTING VALUES("
      "'1', 'http://192.168.0.95:8000/RaptorWCF/', 'getplu/1','qrofflineprocess', 'Rp', '0',"
      "'0', '0', '0', '0','getOperator', 'getModifier','123456', 'R4pt0rWCF', '0')"
    );
  }
  
  void _onUpgrade(Database db, int oldVersion, int newVersion){
    if(oldVersion == 1){
      //-Update add currency setting-----------------------------------------------------
      db.execute("ALTER TABLE SETTING ADD COLUMN currency TEXT");
      db.execute("UPDATE SETTING "
      "SET apiUrl = 'http://192.168.0.95:8000/RaptorWCF/', endPointGetPlu = 'getPlu/1', endPointSendData = 'qrofflineprocess', currency = 'Rp', decimalPoint = '0'"
      "WHERE id = '1'");
      db.execute("ALTER TABLE SETTING ADD COLUMN changeOperator BOOLEAN");
      db.execute("ALTER TABLE SETTING ADD COLUMN editOrder BOOLEAN");
      db.execute("ALTER TABLE SETTING ADD COLUMN auth BOOLEAN");
      db.execute("ALTER TABLE SETTING ADD COLUMN endPointGetOperator TEXT");
      db.execute("ALTER TABLE SETTING ADD COLUMN endPointGetModifier TEXT");
      db.execute("ALTER TABLE SETTING ADD COLUMN passwordSpv TEXT");
      db.execute("ALTER TABLE SETTING ADD COLUMN passwordAuth TEXT");
      db.execute("ALTER TABLE SETTING ADD COLUMN tableOveride BOOLEAN");
      db.execute("ALTER TABLE SETTING ADD COLUMN cover BOOLEAN");
      db.execute("UPDATE SETTING SET "
        "changeOperator = '0',"
        "editOrder = '0',"
        "auth = '0',"
        "tableOveride = '0',"
        "endPointGetPlu = 'getPlu/1',"
        "endPointGetOperator = 'getOperator',"
        "endPointGetModifier = 'getModifier',"
        "passwordSpv = '123456',"
        "passwordAuth = 'R4pt0rWCF',"
        "cover = '0'"
        "WHERE id = '1'");
    } else if(oldVersion == 2){
      db.execute("ALTER TABLE SETTING ADD COLUMN tableOveride BOOLEAN");
      db.execute("UPDATE SETTING SET tableOveride = '0' WHERE id = '1'");
    } else if(oldVersion == 3){
      db.execute("ALTER TABLE SETTING ADD COLUMN cover BOOLEAN");
      db.execute("UPDATE SETTING SET cover = '0' WHERE id = '1'");
    }
  }

  //-Get setting-------------------------------------------------------------------------
  Future<List<Setting>> getSetting() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('select * from setting');
    List<Setting> setting = List();
    setting.add(Setting(
      apiUrl: list[0]['apiUrl'],
      endPointGetPlu: list[0]['endPointGetPlu'],
      endPointSendData: list[0]['endPointSendData'],
      endPointGetOperator: list[0]['endPointGetOperator'],
      endPointGetModifier: list[0]['endPointGetModifier'],
      currency: list[0]['currency'],
      passwordSpv: list[0]['passwordSpv'],
      passwordAuth: list[0]['passwordAuth'],
      decimalPoint: list[0]['decimalPoint'],
      changeOperator: list[0]['changeOperator'],
      editOrder: list[0]['editOrder'],
      auth: list[0]['auth'],
      tableOveride: list[0]['tableOveride'],
      cover: list[0]['cover']
    ));
    return setting;
  }

  //-Update Setting----------------------------------------------------------------------
  Future<int> updateSetting(Setting setting) async {
    var dbClient = await db;
    int res = await dbClient.rawUpdate(
      "UPDATE SETTING "
      "SET apiUrl = '${setting.apiUrl}', endPointGetPlu = '${setting.endPointGetPlu}',"
      "endPointSendData = '${setting.endPointSendData}', currency = '${setting.currency}',"
      "decimalPoint = '${setting.decimalPoint}', changeOperator = '${setting.changeOperator}',"
      "editOrder = '${setting.editOrder}', passwordSpv = '${setting.passwordSpv}',"
      "endPointGetOperator = '${setting.endPointGetOperator}', auth = '${setting.auth}',"
      "passwordAuth = '${setting.passwordAuth}', endPointGetModifier = '${setting.endPointGetModifier}',"
      "tableOveride = '${setting.tableOveride}', cover ='${setting.cover}'"
      "WHERE id = ${setting.id}"
    );
    return res;
  }
}