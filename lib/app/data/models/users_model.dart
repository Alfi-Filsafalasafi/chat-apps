class UserModel {
  String? uid;
  String? name;
  String? email;
  String? status;
  String? creationTime;
  String? lastSignInTime;
  String? updatedTime;
  String? photoURL;

  UserModel(
      {this.uid,
      this.name,
      this.email,
      this.status,
      this.creationTime,
      this.lastSignInTime,
      this.updatedTime,
      this.photoURL});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    status = json['status'];
    creationTime = json['creationTime'];
    lastSignInTime = json['lastSignInTime'];
    updatedTime = json['updatedTime'];
    photoURL = json['photoURL'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['status'] = status;
    data['creationTime'] = creationTime;
    data['lastSignInTime'] = lastSignInTime;
    data['updatedTime'] = updatedTime;
    data['photoURL'] = photoURL;
    return data;
  }
}
