class UserChat {
  String? publicKey;
  String? image;
  String? name;
  String? lastActive;
  bool? isOnline;
  String? id;
  String? email;
  String? pushToken;

  UserChat(
      {this.publicKey,
        this.image,
        this.name,
        this.lastActive,
        this.isOnline,
        this.id,
        this.email,
        this.pushToken});

  UserChat.fromJson(Map<String, dynamic> json) {
    publicKey = json['public_key'];
    image = json['image']?? '';
    name = json['name'];
    lastActive = json['last_active'];
    isOnline = json['is_online']?? false;
    id = json['id']?? '';
    email = json['email']?? '';
    pushToken = json['push_token']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =Map<String, dynamic>();
    data['public_key'] = this.publicKey;
    data['image'] = this.image;
    data['name'] = this.name;
    data['last_active'] = this.lastActive;
    data['is_online'] = this.isOnline;
    data['id'] = this.id;
    data['email'] = this.email;
    data['push_token'] = this.pushToken;
    return data;
  }
}