import 'dart:core';

class UserAppData {
  final String userEmail;
  final String tokenId;
  String photoUrl;
  int deleteOpt;
  List<Contact> contacts;

  UserAppData(
      {this.userEmail,
      this.tokenId,
      this.photoUrl,
      this.deleteOpt,
      this.contacts});

  factory UserAppData.fromMap(Map data) {
    print('this is the data I am getting :');
    print(data.toString());
    return UserAppData(
        userEmail: data['userEmail'],
        tokenId: data['tokenId'],
        contacts: (data['contacts'] as List ?? [])
            .map((v) => Contact.fromMap(v))
            .toList());
  }
}

class Contact {
  final String uid;
  String photoUrl;
  String contactName;

  Contact({this.photoUrl, this.uid, this.contactName});

  factory Contact.fromMap(Map data) {
    return Contact(
      uid: data['uid'],
      photoUrl: data['photoUrl'],
      contactName: data['contactName'],
    );
  }
}
