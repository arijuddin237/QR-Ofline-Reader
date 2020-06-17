import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:archive/archive.dart';

class BlocDecrypt{
  String decrypt;
  BehaviorSubject<String> _subject;
  String password = 'password';
  List splitString = [];

  BlocDecrypt(this.decrypt){
    _subject = BehaviorSubject<String>.seeded(decrypt);
  }

  void decryptData(List data){
    for (var i = 0; i < data.length; i++) {
      splitString.add(data[i][3]);
    }
    try {
      String cipherText = splitString.reduce((value, element) => value + element);
      var hashPassword = utf8.encode(password);
      var hash = sha256.convert(hashPassword);
      final key1 = hash.toString().substring(0, 32);
      final key = Key.fromUtf8(key1);
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(cipherText, iv: iv);
      final stringBytes = base64.decode(decrypted);
      final gzipBytes = GZipDecoder().decodeBytes(stringBytes);
      final decompress = utf8.decode(gzipBytes);
      decrypt = decompress;
      _subject.sink.add(decrypt);
      splitString = [];
    } catch (e) {
      splitString = [];
      print(e.toString());
      _subject.sink.add(e.toString());
    }
  }

  void editQuantity(String data){
    decrypt = data;
    _subject.sink.add(decrypt);
  }

  void dispose(){
    _subject.close();
  }

  BehaviorSubject<String> get subject => _subject;
}
final blocDecrypt = BlocDecrypt('');