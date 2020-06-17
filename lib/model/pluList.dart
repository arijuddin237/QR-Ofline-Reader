import 'dart:convert' as prefix0;
class PluList {
  int success;
  List<Message> message;

  PluList({this.success, this.message});

  PluList.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    if (json['Message'] != null) {
      var jsonMesage = prefix0.json.decode(json['Message']);
      message = new List<Message>();
      jsonMesage.forEach((v) {
        message.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Success'] = this.success;
    if (this.message != null) {
      data['Message'] = this.message.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String plunumber;
  String pluname;
  double sell1;

  Message({this.plunumber, this.pluname, this.sell1});

  Message.fromJson(Map<String, dynamic> json) {
    plunumber = json['plunumber'];
    pluname = json['pluname'];
    sell1 = json['sell1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plunumber'] = this.plunumber;
    data['pluname'] = this.pluname;
    data['sell1'] = this.sell1;
    return data;
  }
}
