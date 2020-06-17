import 'package:rxdart/rxdart.dart';

class BlocError{
  String errorText;
  BehaviorSubject<String> _subject;

  BlocError(this.errorText){
    _subject = BehaviorSubject<String>.seeded(errorText);
  }

  void addErrorText(String data){
    errorText = data;
    _subject.sink.add(errorText);
  }

  void clearError(){
    errorText = null;
    _subject.sink.add(errorText);
  }

  void dispose(){
    _subject.close();
  }

  BehaviorSubject<String> get subject => _subject;
}
final blocError = BlocError(null);