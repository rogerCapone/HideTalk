import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'globals.dart';

//! AIXO REEMPLAÇARIA database.dart
//! AIXO REEMPLAÇARIA database.dart
//! AIXO REEMPLAÇARIA database.dart
//! AIXO REEMPLAÇARIA database.dart

class Document<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  DocumentReference ref;

  Document({this.path}) {
    //* setUp a regular document reference to to Firestore
    ref = _db.doc(path);
  }

  //! Only fetches data ONCE
  Future<T> getData() {
    //*Desirialize FirestoreData
    return ref.get().then((v) => Global.models[T](v.data) as T);
  }

  //! Only fetches data ONCE
  Stream<T> streamData() {
    //*Desirialize FirestoreData
    return ref.snapshots().map((v) => Global.models[T](v.data) as T);
  }
}

class Collection<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  CollectionReference ref;

  Collection({this.path}) {
    //* setUp a regular document reference to to Firestore
    ref = _db.collection(path);
  }

  //! Only fetches data ONCE
  Future<List<T>> getData() async {
    //*Desirialize FirestoreData
    var snapshots = await ref.get();
    return snapshots.docs
        .map((doc) => Global.models[T](doc.data) as T)
        .toList();
  }

  //! Only fetches data ONCE
  Stream<List<T>> streamData() {
    //*Desirialize FirestoreData
    return ref
        .snapshots()
        .map((list) => list.docs.map((doc) => Global.models[T](doc.data) as T));
  }
}

class UserDoc<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;
  // Stream<int> profile;

  UserDoc({this.collection});

  //* Retrives a Stream based on a document from a Collection with a user.uid
  Stream<DocumentSnapshot> get inboxStream {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        // Document<T> doc = Document<T>(path: '$collection/${user.uid}');
        // return doc.streamData();
        print(user.uid);
        return _db.collection(collection).doc(user.uid).snapshots();
      } else {
        return Stream<DocumentSnapshot>.value(null);
      }
    });
  }

  Stream<DocumentSnapshot> get userAppData {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        // Document<T> doc = Document<T>(path: '$collection/${user.uid}');
        // return doc.streamData();
        print(user.uid);
        return _db
            .collection(collection)
            .doc(user.uid)
            .collection('appData')
            .doc(user.uid + user.uid.length.toString())
            .snapshots();
      } else {
        return Stream<DocumentSnapshot>.value(null);
      }
    });
  }

  // Stream<DocumentSnapshot> get myHashes {
  //   return _auth.authStateChanges().switchMap((user) async* {
  //     if (user != null) {
  //       // Document<T> doc = Document<T>(path: '$collection/${user.uid}');
  //       // return doc.streamData();
  //       print(user.uid);
  //       final DocumentSnapshot result = await _db
  //           .collection(collection)
  //           .doc(user.uid)
  //           .collection('appData')
  //           .doc(user.uid + user.uid.length.toString())
  //           .get();
  //       yield _db
  //           .collection('HideHash')
  //           .doc(result.data()['inviteLink'])
  //           .snapshots();
  //     } else {
  //       yield Stream<DocumentSnapshot>.value(null);
  //     }
  //   });
  // }

  Future<DocumentSnapshot> getAppDataDoc() async {
    User user = _auth.currentUser;
    print(user.uid);
    print(collection);
    if (user != null) {
      DocumentSnapshot data = await _db
          .collection(collection)
          .doc(user.uid)
          .collection('appData')
          .doc(user.uid + user.uid.length.toString())
          .get();
      return data;
    } else {
      return null;
    }
  }

  Future<DocumentSnapshot> getUserGlobalData() async {
    User user = _auth.currentUser;
    print(user.uid);
    print(collection);
    if (user != null) {
      DocumentSnapshot data =
          await _db.collection(collection).doc(user.uid).get();
      return data;
    } else {
      return null;
    }
  }

  // //* Retrives a Future based on a document from a Collection with a user.uid
  // Future<T> getDocument() async {
  //   User user = _auth.currentUser;
  //   print(user.uid);
  //   if (user != null) {
  //     Document doc = Document<T>(path: '$collection/${user.uid}');
  //     return doc.getData();
  //   } else {
  //     return null;
  //   }
  // }

  // //! TRY 1 CAUTION EL DE ADALT ES EL """BO"""
  // Future<DocumentSnapshot> getDocument() async {
  //   User user = _auth.currentUser;
  //   print(user.uid);
  //   print(collection);
  //   if (user != null) {
  //     DocumentSnapshot data =
  //         await _db.collection(collection).doc(user.uid).get();
  //     return data;
  //   } else {
  //     return null;
  //   }
  // }

  // // //* Allows you to update a document with a user.uid
  // // Future<void> upsert(Map data) async {
  // //   User user =  _auth.currentUser;
  // //   Document<T> ref = Document(path: '$collection/${user.uid}');
  // //   return ref.update(data);
  // // }
}
