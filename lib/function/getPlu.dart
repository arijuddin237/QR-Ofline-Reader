/*import 'package:flutter/material.dart';
import 'package:qr_offline_order/bloc/blocPluList.dart';
import 'package:qr_offline_order/bloc/blocGetOp.dart';
import 'package:qr_offline_order/bloc/blocError.dart';
import 'package:qr_offline_order/widget/dialogError.dart';

void getPlu(){
  blocPluList.getPluList().catchError((e){
    blocError.addErrorText(e.message);
  });
}

void getOperator(BuildContext context){
  blocGetOperator.getOperator().catchError((e){
    showDialogError(context, e.toString(), 1);
  });
}*/