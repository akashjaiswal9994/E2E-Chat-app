class Messages {
  String? send;
  String? toId;
  String? read;
  String? fromID;
  String? msg;
  String? type;

  Messages({this.send, this.toId, this.read, this.fromID, this.msg, this.type});

  Messages.fromJson(Map<String, dynamic> json) {
    send = json['send'].toString();
    toId = json['toId'].toString();
    read = json['read'].toString();
    fromID = json['fromID'].toString();
    msg = json['msg'].toString();
    type = (json['type'] == Type.image.name ? Type.image:Type.text).toString() ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['send'] = send;
    data['toId'] = toId;
    data['read'] = read;
    data['fromID'] = fromID;
    data['msg'] = msg;
    data['type'] = type;
    return data;
  }

}
enum Type{text,image}