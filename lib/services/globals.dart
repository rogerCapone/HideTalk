import 'package:hide_talk/models/userAppData.dart';
import 'package:hide_talk/models/userInbox.dart';
import 'package:hide_talk/services/db.dart';

class Global {
  //* App Data
  static final String title = 'Hide Talk';
  //* Data Models
  static final Map models = {
    // !Atenció:
    // !Cada cop que afegim un model cal instanciarlo per fer-lo servir
    // ! Fent aixo podem instanciarlo a traves de la class Models/global/...

    UserAppData: (data) => UserAppData.fromMap(data),
    UserInbox: (data) => UserInbox.fromMap(data)
    // Chats: (data) => Chats.fromMap(data)
    // UserData: (data) => UserData.fromMap(data),
    // UserInfo: (data) => UserInfo.fromMap(data),
    // Devices: (data) => Devices.fromMap(data),
    // DeviceInfo: (data) => DeviceInfo.fromMap(data),
    // AppData: (data) => AppData.fromMap(data),

    // ! Example: (Once we have a class FOR THE FIREBASE DOC)--> PARSE IT
    // Topic:(data)=> Topic.fromMap(data),
    // Quiz:(data)=> Quiz.fromMap(data),
    // Report:(data)=> Report.fromMap(data),
  };

  static final String roboID = 'YULL8ner';
  //* Firestore Reference for writes

  // static final UserDoc<UserData> userRef =
  //     UserDoc<UserData>(collection: 'Users');

  static final UserDoc<UserAppData> appRef =
      UserDoc<UserAppData>(collection: 'Users');
  static final UserDoc<UserInbox> userRef =
      UserDoc<UserInbox>(collection: 'Users');
  static final UserDoc<UserInbox> hashRef =
      UserDoc<UserInbox>(collection: 'HideHash');

  // static final Collection<Shit> topicRef = Collection<Shit>(path: 'Shit');

  // ! Example
  // static final Collection<Topic> topicRef = Collection<Topic>(path: 'topics');
  // static final UserData<Report> reportRef = UserData<Report>(collection: 'Users');

}
