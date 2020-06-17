import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:qr_offline_order/widget/dialogError.dart';

class BlocQRReader{
  List qrReader = [];
  String orderCode = '';
  BehaviorSubject<List> _subject;
  int i = 1;

  BlocQRReader(this.qrReader){
    _subject = BehaviorSubject<List>.seeded(qrReader);
  }

  void addQRReader(dynamic data, BuildContext context){
    try {
      List split = data.split('_@@_');
      List splitNumber = split[1].split('/');
      List splitCharLength = split[2].split('/');
      print(data);
      if(qrReader.length == 0){
        i = 1;
      }
      if(split.length == 4){
        if(splitNumber.length == 2){
          if(split[3].length == int.parse(splitCharLength[0])){
            if(int.parse(splitNumber[0]) == i){
              if(i == 1){
                orderCode = split[0];
                qrReader.add(split);
                _subject.sink.add(qrReader);
                i++;
              } else {
                if(split[0] == orderCode){
                  qrReader.add(split);
                  _subject.sink.add(qrReader);
                  i++;
                } else {
                  showDialogError(context, "Wrong barcode", 1);
                }
              }
            } else if(int.parse(splitNumber[0]) != i){
              if(i > int.parse(splitNumber[1])){
                showDialogError(context, 'Barcode already complete', 1);
              } else if(i < int.parse(splitNumber[1]) || i == int.parse(splitNumber[1])){
                showDialogError(context, 'Scan barcode number $i from ${splitNumber[1]} barcode', 1);
              }
            }
          } else if(split[3].length != int.parse(splitCharLength[0])){
            showDialogError(context, 'Error, barcode length invalid', 1);
          }
        } else if(splitNumber.length != 2) {
          showDialogError(context, 'Error barcode value, missing separator', 1);
        }
      } else if(split.length != 3){
        showDialogError(context, 'Error barcode value, missing separator', 1);
      }
    } catch (e) {
      showDialogError(context, 'Error barcode value', 1);
    }
  }

  void clearList(){
    qrReader.clear();
    _subject.sink.add(qrReader);
  }

  void dispose(){
    _subject.close();
  }
  BehaviorSubject<List> get subject => _subject;
}
final blocQRReader = BlocQRReader([]);