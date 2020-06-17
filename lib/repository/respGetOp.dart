import 'package:qr_offline_order/model/operator.dart';
import 'package:qr_offline_order/data/restData.dart';

class RespGetOperator{
  RestData _restData = RestData();

  Future<Operator> getOperator(){
    return _restData.getOperator();
  }
}