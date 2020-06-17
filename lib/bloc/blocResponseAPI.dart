import 'package:qr_offline_order/model/responseAPI.dart';
import 'package:qr_offline_order/repository/respApiRep.dart';
import 'package:rxdart/rxdart.dart';

class BlocResponseAPI {
  final RespApiRepository _respApiRepository = RespApiRepository();
  final BehaviorSubject<ResponseAPI> _subject = BehaviorSubject<ResponseAPI>();

  sendToApi(String bodyString) async {
    ResponseAPI response = await _respApiRepository.getRespApi(bodyString);
    _subject.sink.add(response);
  }

  clearBloc(){
    _subject.sink.add(null);
  }

  void dispose(){
    _subject.close();
  }
  BehaviorSubject<ResponseAPI> get subject => _subject;
}
final blocRespApi = BlocResponseAPI();