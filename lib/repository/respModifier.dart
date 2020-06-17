import 'package:qr_offline_order/data/restData.dart';
import 'package:qr_offline_order/model/modifier.dart';

class RespGetModifier{
  RestData _restData = RestData();

  Future<Modifier> getModifier(){
    return _restData.getModifier();
  }
}