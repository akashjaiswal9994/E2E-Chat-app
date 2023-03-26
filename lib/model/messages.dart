class Messages {
  String? send;
  String? told;
  String? read;
  String? fromID;
  String? msg;
  String? type;

  Messages({this.send, this.told, this.read, this.fromID, this.msg, this.type});

  Messages.fromJson(Map<String, dynamic> json) {
    send = json['send'];
    told = json['told'];
    read = json['read'];
    fromID = json['fromID'];
    msg = json['msg'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['send'] = this.send;
    data['told'] = this.told;
    data['read'] = this.read;
    data['fromID'] = this.fromID;
    data['msg'] = this.msg;
    data['type'] = this.type;
    return data;
  }
}
