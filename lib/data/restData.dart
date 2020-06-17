import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:qr_offline_order/bloc/blocError.dart';
import 'package:qr_offline_order/model/responseAPI.dart';
import 'package:qr_offline_order/model/pluList.dart';
import 'package:qr_offline_order/model/operator.dart';
import 'package:qr_offline_order/model/modifier.dart';
import 'package:qr_offline_order/library/librarySetting.dart' as appsSetting;

class RestData{
  final JsonDecoder _decoder = JsonDecoder();
  var client = http.Client();

  ResponseAPI sendAPI;

  //-Send data to database-----------------------------------------------------------
  Future<ResponseAPI> sendApi(String bodyString) async {
    print(appsSetting.apiUrl);
    try {
      var response = await client.post(
        Uri.encodeFull(appsSetting.apiUrl+appsSetting.endpointSendData),
        body: bodyString
      );
      if(response.statusCode == 200){
        var res = _decoder.convert(response.body);
        var jsonRes = json.decode(res);
        return ResponseAPI.fromJson(jsonRes[0]);
      } else {
        var res = _decoder.convert(response.body);
        var jsonRes = json.decode(res);
        return ResponseAPI.fromJson(jsonRes[0]);
      } 
    } catch (e) {
      throw Exception(e);
    }
  }

  //-Get PLU List--------------------------------------------------------------------
  Future<PluList> getPlu() async {
    print(appsSetting.apiUrl+appsSetting.endpointGetPlu);
    var response;
    try {
      if(appsSetting.auth){
        response = await client.get(
          Uri.encodeFull(appsSetting.apiUrl+appsSetting.endpointGetPlu),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            "RaptorWCFKey" : appsSetting.passwordAuth
          }
        );
      } else {
        response = await client.get(
          Uri.encodeFull(appsSetting.apiUrl+appsSetting.endpointGetPlu),
        );
      }
      if(response.statusCode == 200){
        var res = _decoder.convert(response.body);
        var jsonRes = json.decode(res);
        if(jsonRes[0]['Success'] == 0){
          throw Exception(response.body);
        } else {
          blocError.clearError();
          return PluList.fromJson(jsonRes[0]);
        }
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      if(e.message != ""){
        throw Exception(e.message.toString());
      } else {
        throw Exception('1');
      }
    }
  }

  //-Get Operator--------------------------------------------------------------------
  Future<Operator> getOperator() async {
    print(appsSetting.apiUrl+appsSetting.endpointGetOperator);
    var response;
    try {
      if(appsSetting.auth){
        response = await client.get(
          Uri.encodeFull(appsSetting.apiUrl+appsSetting.endpointGetOperator),
          headers: {
            HttpHeaders.contentTypeHeader : 'application/json',
            "RaptorWCFKey" : appsSetting.passwordAuth
          }
        );
      } else {
        response = await client.get(
          Uri.encodeFull(appsSetting.apiUrl+appsSetting.endpointGetOperator)
        );
      }
      if(response.statusCode == 200){
        var res = _decoder.convert(response.body);
        var jsonRes = json.decode(res);
        if(jsonRes[0]['Success'] == 0){
          throw Exception(response.body);
        } else {
          blocError.clearError();
          return Operator.fromJson(jsonRes[0]);
        }
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      if(e.message != ""){
        throw Exception(e.message.toString());
      } else {
        throw Exception('1');
      }
    }
  }

  //-Get Modifier--------------------------------------------------------------------
  Future<Modifier> getModifier() async {
    print(appsSetting.apiUrl+appsSetting.endpointGetModifier);
    var response;
    try {
      if(appsSetting.auth){
        response = await client.get(
          Uri.encodeFull(appsSetting.apiUrl+appsSetting.endpointGetModifier),
          headers: {
            HttpHeaders.contentTypeHeader : 'application/json',
            "RaptorWCFKey" : appsSetting.passwordAuth
          }
        );
      } else {
        response = await client.get(
          Uri.encodeFull(appsSetting.apiUrl+appsSetting.endpointGetModifier)
        );
      }
      if(response.statusCode == 200){
        var res = _decoder.convert(response.body);
        var jsonRes = json.decode(res);
        if(jsonRes[0]['Success'] == 0){
          throw Exception(response.body);
        } else {
          blocError.clearError();
          return Modifier.fromJson(jsonRes[0]);
        }
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      if(e.message != ""){
        throw Exception(e);
      } else {
        throw Exception('1');
      }
    }
  }
}