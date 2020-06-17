import 'package:flutter/cupertino.dart';
import 'package:qr_offline_order/bloc/blocQRReader.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:qr_offline_order/widget/dialogError.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

/*Future scan(BuildContext context) async {
  try {
    String barcode = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.BARCODE);
    blocQRReader.addQRReader(barcode, context);
  } catch(e){
    showDialogError(context, e.toString(), 1);
  }
}*/

Future scan(BuildContext context) async{
  try{
    String barcode = await BarcodeScanner.scan();
    blocQRReader.addQRReader(barcode, context);
  } on PlatformException catch (e){
    if(e.code == BarcodeScanner.CameraAccessDenied){
      showDialogError(context, 'The user did not grant the camera permission!', 1);
    } else {
      showDialogError(context, e.toString(), 1);
    }
  } on FormatException{
    showDialogError(context, 'User returned using the "back"-button before scanning anything.', 1);
  } catch (e){
    showDialogError(context, e.toString(), 1);
  }
}