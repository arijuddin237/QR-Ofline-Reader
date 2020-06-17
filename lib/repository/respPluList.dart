import 'package:qr_offline_order/model/pluList.dart';
import 'package:qr_offline_order/data/restData.dart';

class RespPluList{
  RestData _restData = RestData();

  Future<PluList> getPluList(){
    return _restData.getPlu();
  }
}