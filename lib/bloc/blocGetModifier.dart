import 'package:qr_offline_order/model/modifier.dart';
import 'package:qr_offline_order/repository/respModifier.dart';
import 'package:rxdart/rxdart.dart';

class BlocGetModifier{
  final RespGetModifier _getModifier = RespGetModifier();
  final BehaviorSubject<Modifier> _subject = BehaviorSubject<Modifier>();

  getModifier() async {
    Modifier modifier = await _getModifier.getModifier();
    _subject.sink.add(modifier);
  }

  void dispose(){
    _subject.close();
  }
  BehaviorSubject<Modifier> get subject => _subject;
}
final blocGetModifier = BlocGetModifier();