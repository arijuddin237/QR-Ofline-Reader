import 'package:qr_offline_order/bloc/blocPluList.dart';
import 'package:qr_offline_order/bloc/blocGetOp.dart';
import 'package:qr_offline_order/bloc/blocError.dart';
import 'package:qr_offline_order/bloc/blocGetModifier.dart';

void getPlu(){
  blocPluList.getPluList().catchError((e){
    blocError.addErrorText(e.message);
  });
}

void getOperator(){
  blocGetOperator.getOperator().catchError((e){
    blocError.addErrorText(e.message);
  });
}

void getModifier(){
  blocGetModifier.getModifier().catchError((e){
    if(e.message.source.contains('Authentication')){
      print(e.message.source);
      print('authentication failed');
    }
    blocError.addErrorText(e.message.source.toString());
  });
}