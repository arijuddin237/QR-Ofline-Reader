import 'package:qr_offline_order/model/pluList.dart';
import 'package:qr_offline_order/repository/respPluList.dart';
import 'package:rxdart/rxdart.dart';

class BlocPluList{
  final RespPluList _respPluList = RespPluList();
  final BehaviorSubject<PluList> _subject = BehaviorSubject<PluList>();

  getPluList() async {
    PluList pluList = await _respPluList.getPluList();
    _subject.sink.add(pluList);
  }

  void dispose(){
    _subject.close();
  }
  BehaviorSubject<PluList> get subject => _subject;
}
final blocPluList = BlocPluList();