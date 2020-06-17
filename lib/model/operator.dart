import 'dart:convert' as prefix0;

class Operator {
  int success;
  List<Message> message;

  Operator({this.success, this.message});

  Operator.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    if (json['Message'] != null) {
      var jsonMessage = prefix0.json.decode(json['Message']);
      message = new List<Message>();
      jsonMessage.forEach((v) {
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
  int operatorNo;
  String operatorName;

  Message({this.operatorNo, this.operatorName});

  Message.fromJson(Map<String, dynamic> json) {
    operatorNo = json['OperatorNo'];
    operatorName = json['OperatorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OperatorNo'] = this.operatorNo;
    data['OperatorName'] = this.operatorName;
    return data;
  }
}
