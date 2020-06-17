import 'package:rxdart/rxdart.dart';
import 'package:qr_offline_order/model/setting.dart';

class BlocSetting<Setting>{
  Setting setting;
  BehaviorSubject<Setting> _subject;

  BlocSetting(this.setting){
    _subject = BehaviorSubject<Setting>.seeded(setting);
  }

  void onChangeHandler(Setting settingValue){
    setting = settingValue;
    _subject.sink.add(setting);
  }

  void dispose(){
    _subject.close();
  }

  BehaviorSubject<Setting> get subject => _subject;
}
final blocSetting = BlocSetting<Setting>(Setting());