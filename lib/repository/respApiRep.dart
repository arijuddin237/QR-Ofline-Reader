import 'package:qr_offline_order/model/responseAPI.dart';
import 'package:qr_offline_order/data/restData.dart';

class RespApiRepository{
  RestData _restData = RestData();

  Future<ResponseAPI> getRespApi(String bodyString){
    return _restData.sendApi(bodyString);
  }
}