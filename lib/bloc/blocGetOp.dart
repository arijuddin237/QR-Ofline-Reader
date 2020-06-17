import 'package:qr_offline_order/model/operator.dart';
import 'package:qr_offline_order/repository/respGetOp.dart';
import 'package:rxdart/rxdart.dart';

class BlocGetOperator{
  final RespGetOperator _getOperator = RespGetOperator();
  final BehaviorSubject<Operator> _subject = BehaviorSubject<Operator>();

  getOperator() async {
    Operator operatorList = await _getOperator.getOperator();
    _subject.sink.add(operatorList);
  }

  void dispose(){
    _subject.close();
  }
  BehaviorSubject<Operator> get subject => _subject;
}
final blocGetOperator = BlocGetOperator();

//-Bloc set operator---------------------------------------------------------------------
class BlocSetOperator{
  int indexOperator;
  BehaviorSubject<int> _subject;

  BlocSetOperator(this.indexOperator){
    _subject = BehaviorSubject<int>.seeded(indexOperator);
  }

  void setOperatorIndex(int data){
    indexOperator = data;
    _subject.sink.add(indexOperator);
  }

  void clearIndexOperator(){
    indexOperator = null;
    _subject.sink.add(indexOperator);
  }

  void dispose(){
    _subject.close();
  }
  BehaviorSubject<int> get subject => _subject;
}
final blocSetOperator = BlocSetOperator(null);