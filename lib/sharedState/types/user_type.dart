class UserType {
  String ID;
  String authProvider;
  String userName;
  String? profilePictureURL;
  String? UID, email;
  String? loginType;
  String? createdAt;
  String? updatedAt;

  UserType({
    required this.ID,
    required this.authProvider,
    required this.userName,
    this.profilePictureURL,
    this.UID,
    this.email,
    this.loginType,
    this.createdAt,
    this.updatedAt,
  });

  static UserType mapToClass(Map mapObj) {
    print(mapObj);
    return UserType(
      ID: mapObj["_id"],
      authProvider: mapObj["auth_provider"],
      userName: mapObj["username"],
      profilePictureURL: mapObj["profile_pic_url"],
      UID: mapObj["uid"],
      email: mapObj["email"],
      loginType: mapObj["login_type"],
      createdAt: mapObj["createdAt"],
      updatedAt: mapObj["updatedAt"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "_id": ID,
      "auth_provider": authProvider,
      "username": userName,
      "profile_pic_url": profilePictureURL,
      "uid": UID,
      "email": email,
      "login_type": loginType,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
