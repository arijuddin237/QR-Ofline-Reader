import 'dart:convert' as prefix0;
class Modifier{
  int success;
  List<Message> message;

  Modifier({this.success, this.message});

  Modifier.fromJson(Map<String, dynamic> json){
    success = json['Success'];
    if (json['Message'] != null){
      var jsonMessage = prefix0.json.decode(json['Message']);
      message = new List<Message>();
      jsonMessage.forEach((v) {
        message.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    if(this.message != null){
      data['Message'] = this.message.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  double msgid;
  String message;

  Message({this.msgid, this.message});

  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    msgid = json['msgid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msgid'] = this.msgid;
    data['message'] = this.message;
    return data;
  }
}