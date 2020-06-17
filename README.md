# QR Offline Reader Flutter

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.<br/><br/>

This project require to install few package, <br/>
1. Open up a terminal
2. `cd` into project directory
3. Run `flutter doctor` to ensure you have flutter dependencies working
4. Run `flutter pub get` to install missing package

This project using RxDart, you can find reference of RxDart on : <br/>
- [RxDart Package](https://pub.dev/packages/rxdart)
- [RxDart Articel](https://medium.com/nusanet/flutter-bloc-pattern-with-rxdart-60a34ec526df)

## Using QR code scanner
This project also using [barcode scanner](https://pub.dev/packages/barcode_scan), if you want to scan QR code,<br/> you need to add some code on android manifest project level before using barcode scanner, you can find at android/src/main/AndroidManifest.xml
- Add camera permission <br/>
  ```xml
  <uses-permission android:name="android.permission.CAMERA" />
  ```
- Add the BarcodeScanner activity <br/>
  ```xml
  <activity android:name="com.apptreesoftware.barcodescan.BarcodeScannerActivity"/>
  ```
here's the example code to scan barcode using [barcode scanner](https://pub.dev/packages/barcode_scan) package

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future scan() async {
    try{
        String barcode = await BarcodeScanner.scan();
        print(barcode) //-Result from scan QR Code
    } on PlatformException catch (e){
        if(e.code == BarcodeScanner.CameraAccessDenied){
            //-Handler if user didn't grant camera permission
        } else {
            //-Handler if catch another error
        }
    } on FormatException{
        //-Handler if user press back button before scanning anything
    } catch (e){
        //-Handler if catch error while scan QR
    }
}
```

## Decrypt QR code
This project using [Encrypt](https://pub.dev/packages/encrypt) package for decrypt data,
and using [Archive](https://pub.dev/packages/archive) package for decompress data, to convert string password into sha256 using [crypto](https://pub.dev/packages/crypto) package. <br/>
QR code from web ordering encrypted using AES CBC-256, you need to split data from QR code before decrypt it, here's structure data from QR code <br/>

```dart
"C595D6_@@_1/3_@@_150/344_@@_pj0IvUHTa0Ytsg1........"
```
"C595D6" : order code<br/>
"1/3" : Number of barcode, meaning barcode 1 of 3 barcode<br/>
"150/344" : Barcode value length<br/>
"pj0IvUHTa0Ytsg1........" : barcode value<br/>

```dart
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

String password = 'password';
List splitString = [];

void decryptData(List data){ //-List data from barcode scanner
    //-Split data to get barcode value
    for(var i = 0; i <data.length; i++){
        splitString.add(data[i][3]);
    }
    try{
        String chiperText = splitString.reduce((value, element) => value + element);
        var hashPassword = utf8.encode(password);
        var hash = sha256.convert(hashPassword);
        final key1 = hash.toString().substring(0, 32);
        final key = Key.fromUtf8(key1);
        final iv = IV.fromLength(16);
        final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
        final decrypted = encrypter.decrypt64(chiperText, iv: iv);
        final stringBytes = base64.decode(decrypted); //-String data from decrypt
        final gzipBytes = GZipDecoder().decodeBytes(stringBytes); //-decompress data
        final decompress = utf8.decode(gzipBytes);
    } catch(e){
        //-Handler if error decrypt data
    }
}
```

## Setting

Open the app and go to Setting menu on the right bottom.

**APIURL** <br/>
`http://192.168.0.95:8000/RaptorWCF/`

Password for edit: testPassword <br/>
Change ip address with ip address based on *WCF Raptor Services* program.

**Endpoint Get PLU**<br/>
`getplu`

**End Point Send Data**<br/>
`qrofflineprocess`

Save the setting by press Icon on the right top. 


