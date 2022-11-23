import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:hide_talk/services/encryption.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'auth.dart';

class DatabaseMethods {
  final db = FirebaseFirestore.instance;

// TODO: MyHides
  Future<void> addMyHide({String uid, String msg}) async {
    String encryptedData = MyEncryption.encryptAESCryptoJS(msg);
    print(encryptedData.toString());
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'myHide': FieldValue.arrayUnion([
        {
          'payload': encryptedData,
          'sendAt': DateTime.now().millisecondsSinceEpoch,
          'visible': true
        }
      ])
    });
  }

  Future<void> deleteHide({String uid, dynamic hide}) async {
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'myHide': FieldValue.arrayRemove([hide])
    });
  }

  Future<void> deleteAllHides({String uid, List<dynamic> hides}) async {
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({'myHide': FieldValue.arrayRemove(hides)});
  }

// TODO: Chats
  Future<void> deleteMsg({List<dynamic> mails, String uid}) async {
    print('Iam gonna deletee this messages');
    print(mails.toString());
    return db
        .collection('Users')
        .doc(uid)
        .update({'inbox': FieldValue.arrayRemove(mails)});
  }

  Future<void> deleteHotImage(
      {List<dynamic> mails,
      String imgPath,
      String uid,
      String otherUid}) async {
    print('Iam gonna deletee this messages');
    // final refPath = '/HideTalk/HotImg/';
    print(mails.toString());
    await db
        .collection('Users')
        .doc(uid)
        .update({'inbox': FieldValue.arrayRemove(mails)});
    print(imgPath);
    String filePath = imgPath
        .replaceAll(
            new RegExp(
                r'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FHotImg%2F'),
            '')
        .split('?')[0];
    print(filePath);
    try {
      return firebase_storage.FirebaseStorage.instance
          .ref()
          .child('/HideTalk/HotImg/' + filePath)
          .delete()
          .then((_) => print('Successfully deleted $filePath storage item'));

      // print(ref.bucket);
      // print(ref.fullPath);
      // print(ref.getDownloadURL());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendMessage(
      {String payload,
      int sendAt,
      String sendBy,
      bool image,
      String imageUrl,
      String sendByName,
      String sendTo,
      String senderPic}) async {
    String msg =
        '$sendBy|||$sendTo|||$image|||$imageUrl|||$payload|||$sendAt|||$sendByName|||$senderPic';

    String encryptedData = MyEncryption.encryptAESCryptoJS(msg);

    // ?  decrypted.split('|||');
    //  ? decrypted[0]; //! (string) senderUID;
    //   ?decrypted[1]; //! (string) reciverUID;
    //   ?decrypted[2]; //! (bool)   image;
    // ?  decrypted[3]; //! (string)   imageUrl;
    //  ? decrypted[4]; //! (string)  msg;
    //   ?decrypted[5]; //! (string)  sendAt;
    //   ?decrypted[6]; //! (string)  sendByName;
    //   ?decrypted[7]; //! (string)  senderPic;
    await db
        .collection('Users')
        .doc(sendBy)
        .collection('appData')
        .doc(sendBy + sendBy.length.toString())
        .update({
      "sendedMsg": FieldValue.increment(1),
    });
    return db.collection('HotInbox').doc().set({
      "payload": encryptedData,
    });
  }

// COMMS
  Future<void> sendHideImg(
      {String payload,
      int sendAt,
      String sendBy,
      bool image,
      String imageUrl,
      String sendByName,
      String sendTo,
      String senderPic}) async {
    String msg =
        '$sendBy|||$sendTo|||$image|||$imageUrl|||$payload|||$sendAt|||$sendByName|||$senderPic';

    String encryptedData = MyEncryption.encryptAESCryptoJS(msg);

    // ?  decrypted.split('|||');
    //  ? decrypted[0]; //! (string) senderUID;
    //   ?decrypted[1]; //! (string) reciverUID;
    //   ?decrypted[2]; //! (bool)   image;
    // ?  decrypted[3]; //! (string)   imageUrl;
    //  ? decrypted[4]; //! (string)  msg;
    //   ?decrypted[5]; //! (string)  sendAt;
    //   ?decrypted[6]; //! (string)  sendByName;
    //   ?decrypted[7]; //! (string)  senderPic;
    await db
        .collection('Users')
        .doc(sendBy)
        .collection('appData')
        .doc(sendBy + sendBy.length.toString())
        .update({
      "sendedMsg": FieldValue.increment(1),
    });
    return db.collection('HotInbox').doc().set({
      "payload": encryptedData,
    });
  }
// COMMS

//Todo: APP SETTINGS

  Future<void> changeNotiSettings({String uid, bool value}) async {
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({'sendNotifications': value});
  }

// Todo: USERS

  Future<void> oldEnough({String uid}) async {
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({'oldEnough': true});
  }

//?Used for seing if the userHas an account or not
  Future<void> updateUserName({String uid, String newName}) async {
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({'userName': newName});
  }

  Future<bool> checkUserName({String uid}) async {
    final userDoc = await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .get();

    if (userDoc.data()['userName'] != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addToFavorite(
      {String uid, Map<dynamic, dynamic> contact}) async {
    await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'contacts': FieldValue.arrayRemove([
        {
          'fav': contact['fav'],
          'photoUrl': contact['photoUrl'],
          'uid': contact['uid'],
          'userName': contact['userName']
        }
      ])
    });
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'contacts': FieldValue.arrayUnion([
        {
          'fav': !contact['fav'],
          'photoUrl': contact['photoUrl'],
          'uid': contact['uid'],
          'userName': contact['userName']
        }
      ])
    });
  }

  Future<void> hideContact({String uid, Map<dynamic, dynamic> contact}) async {
    await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'contacts': FieldValue.arrayRemove([
        {
          'fav': contact['fav'],
          'photoUrl': contact['photoUrl'],
          'uid': contact['uid'],
          'userName': contact['userName']
        }
      ])
    });
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'hideContacts': FieldValue.arrayUnion([
        {
          'fav': contact['fav'],
          'photoUrl': contact['photoUrl'],
          'uid': contact['uid'],
          'userName': contact['userName']
        }
      ])
    });
  }

  Future<void> showContact({String uid, Map<dynamic, dynamic> contact}) async {
    await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'hideContacts': FieldValue.arrayRemove([
        {
          'fav': contact['fav'],
          'photoUrl': contact['photoUrl'],
          'uid': contact['uid'],
          'userName': contact['userName']
        }
      ])
    });

    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'contacts': FieldValue.arrayUnion([
        {
          'fav': contact['fav'],
          'photoUrl': contact['photoUrl'],
          'uid': contact['uid'],
          'userName': contact['userName']
        }
      ])
    });
  }

  Future<void> removeHideContact(
      {String uid, Map<dynamic, dynamic> contact}) async {
    await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'hideContacts': FieldValue.arrayRemove([
        {
          'fav': contact['fav'],
          'photoUrl': contact['photoUrl'],
          'uid': contact['uid'],
          'userName': contact['userName']
        }
      ])
    });
  }

  Future<void> removeContact(
      {String uid, Map<dynamic, dynamic> contact}) async {
    await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({
      'contacts': FieldValue.arrayRemove([
        {
          'fav': contact['fav'],
          'photoUrl': contact['photoUrl'],
          'uid': contact['uid'],
          'userName': contact['userName']
        }
      ])
    });
  }

  Future<bool> updateContactName(
      {String uid,
      String contactUid,
      bool fav,
      String photoUrl,
      String userName,
      String newName}) async {
    //! Eliminar de contactes, el antic contacte
    //*Que vindra per parametres
    final contacts = await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .get();
    bool trobat = false;
    for (var i = 0; i < contacts.data()['contacts'].length; i++) {
      if (contacts.data()['contacts'][i]['uid'] == contactUid) {
        trobat = true;
      }
    }

    if (trobat == true) {
      await db
          .collection('Users')
          .doc(uid)
          .collection('appData')
          .doc(uid + uid.length.toString())
          .update({
        'contacts': FieldValue.arrayRemove([
          {
            'uid': contactUid,
            'fav': fav,
            'photoUrl': photoUrl,
            'userName': userName,
          }
        ])
      });
      await db
          .collection('Users')
          .doc(uid)
          .collection('appData')
          .doc(uid + uid.length.toString())
          .update({
        'contacts': FieldValue.arrayUnion([
          {
            'uid': contactUid,
            'fav': fav,
            'photoUrl': photoUrl,
            'userName': newName,
          }
        ])
      });
      return true;
    } else {
      for (var i = 0; i < contacts.data()['contacts'].length; i++) {
        if (contacts.data()['hideContacts'][i]['uid'] == contactUid) {
          trobat = true;
        }
      }
      if (trobat == true) {
        await db
            .collection('Users')
            .doc(uid)
            .collection('appData')
            .doc(uid + uid.length.toString())
            .update({
          'hideContacts': FieldValue.arrayRemove([
            {
              'uid': contactUid,
              'fav': fav,
              'photoUrl': photoUrl,
              'userName': userName,
            }
          ])
        });
        await db
            .collection('Users')
            .doc(uid)
            .collection('appData')
            .doc(uid + uid.length.toString())
            .update({
          'hideContacts': FieldValue.arrayUnion([
            {
              'uid': contactUid,
              'fav': fav,
              'photoUrl': photoUrl,
              'userName': newName,
            }
          ])
        });
        return true;
      }
    }
    return false;
  }

  Future<bool> changeContactImage(
      {String uid,
      String contactUid,
      bool fav,
      String oldImg,
      String userName,
      String imgUrl}) async {
    //! Eliminar de contactes, el antic contacte
    //*Que vindra per parametres
    final contacts = await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .get();
    bool trobat = false;
    for (var i = 0; i < contacts.data()['contacts'].length; i++) {
      if (contacts.data()['contacts'][i]['uid'] == contactUid) {
        trobat = true;
      }
    }

    if (trobat == true) {
      await db
          .collection('Users')
          .doc(uid)
          .collection('appData')
          .doc(uid + uid.length.toString())
          .update({
        'contacts': FieldValue.arrayRemove([
          {
            'uid': contactUid,
            'fav': fav,
            'photoUrl': oldImg,
            'userName': userName,
          }
        ])
      });
      await db
          .collection('Users')
          .doc(uid)
          .collection('appData')
          .doc(uid + uid.length.toString())
          .update({
        'contacts': FieldValue.arrayUnion([
          {
            'uid': contactUid,
            'fav': fav,
            'photoUrl': imgUrl,
            'userName': userName,
          }
        ])
      });
      return true;
    } else {
      for (var i = 0; i < contacts.data()['contacts'].length; i++) {
        if (contacts.data()['hideContacts'][i]['uid'] == contactUid) {
          trobat = true;
        }
      }
      if (trobat == true) {
        await db
            .collection('Users')
            .doc(uid)
            .collection('appData')
            .doc(uid + uid.length.toString())
            .update({
          'hideContacts': FieldValue.arrayRemove([
            {
              'uid': contactUid,
              'fav': fav,
              'photoUrl': oldImg,
              'userName': userName,
            }
          ])
        });
        await db
            .collection('Users')
            .doc(uid)
            .collection('appData')
            .doc(uid + uid.length.toString())
            .update({
          'hideContacts': FieldValue.arrayUnion([
            {
              'uid': contactUid,
              'fav': fav,
              'photoUrl': imgUrl,
              'userName': userName,
            }
          ])
        });
        return true;
      }
    }
    return false;
  }

  Future<void> setPin({String uid, int pin}) async {
    print('TRYING TO SET $pin');
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .update({"pinCode": pin});
  }

  //!Check which is the stage in the register
  Future<String> userRegisterStage({String uid}) async {
    final DocumentSnapshot doc = await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .get();
    // print(doc.data().toString());
    if (doc.data() != null) {
      if (doc.data().keys.contains('pinCode') == true) {
        return 'allDone';
      } else if (doc.data().keys.contains('userName') == false) {
        return 'userName';
      } else if (doc.data()['oldEnough'] == false) {
        return 'oldEnough';
      } else if (doc.data()['photoUrl'] == '') {
        return 'photoUrl';
      } else {
        return 'pin';
      }
    } else {
      return 'userName';
    }
  }

  Future<String> pinAndPayCheck({String uid, int pin}) async {
    final DocumentSnapshot doc = await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .get();
    final DocumentSnapshot hideMem = await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .collection('HideMember')
        .doc('lastInvoice')
        .get();
    if (hideMem.exists) {
      if (hideMem.data().isEmpty) {
        print(hideMem.data());
        return 'not_pay';
      }
    } else {
      return 'not_pay';
    }
    print(hideMem.data());
    //!WILL DELETE
    print(hideMem.data().toString());
    final paymentDate =
        DateTime.fromMillisecondsSinceEpoch(hideMem.data()['subcriptionStart']);
    final endDate =
        DateTime.fromMillisecondsSinceEpoch(hideMem.data()['subcriptionEnd']);
    print('\n\n');
    print('Start: ' + paymentDate.toString());
    print('End: ' + endDate.toString());
    print('\n\n');

    //! End Will delete
    final subEnd =
        DateTime.fromMillisecondsSinceEpoch(hideMem.data()['subcriptionEnd']);
    final dateToday = DateTime.now();
    final difference = dateToday.difference(subEnd).inDays;
    print('difference:');
    print(difference.toString());

    if (doc.data()['pinCode'] == pin && difference <= 0) {
      return 'ok';
    } else if (doc.data()['pinCode'] != pin && difference <= 0) {
      return 'bad_pin';
    } else {
      return 'not_pay';
    }
  }

  //?look for my userName
  Future<DocumentSnapshot> lookForMyContactData(String uid) async {
    return db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .get();
  }

  Future<DocumentSnapshot> getLegalPrivacy() async {
    DocumentSnapshot docu =
        await db.collection('Legal').doc('privacyPolicy').get();
    print(docu.data());
    return docu;
  }

  Future<DocumentSnapshot> getLegalTerms() async {
    return db.collection('Legal').doc('termsAndConditions').get();
  }

  Future<void> userLogin(User user) async {
    PackageInfo packageInfo;
    packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);
    final userRef = db.collection('Users').doc(user.uid);
    final appRef = db
        .collection('Users')
        .doc(user.uid)
        .collection('appData')
        .doc(user.uid + user.uid.length.toString());
    if ((await userRef.get()).exists) {
      await userRef.update({"buildNumber": buildNumber});
      await appRef.update({
        "lastLogin": user.metadata.lastSignInTime.microsecondsSinceEpoch,
      });
    } else {
      print('User reference does not exist in Firebase :_(');
    }

    // await _saveDevice(user);
  }

  // _saveDevice(User user) async {
  //   DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
  //   String deviceId;
  //   Map<String, dynamic> deviceData;
  //   if (Platform.isAndroid) {
  //     final deviceInfo = await devicePlugin.androidInfo;
  //     deviceId = deviceInfo.id;
  //     deviceData = {
  //       "os_version": deviceInfo.version.sdkInt.toString(),
  //       "platform": "android",
  //       "model": deviceInfo.model,
  //       "device": deviceInfo.device
  //     };
  //   }
  //   if (Platform.isIOS) {
  //     final deviceInfo = await devicePlugin.iosInfo;
  //     deviceId = deviceInfo.identifierForVendor;
  //     deviceData = {
  //       "os_version": deviceInfo.systemVersion,
  //       "platform": "ios",
  //       "model": deviceInfo.model,
  //       "device": deviceInfo.name
  //     };
  //   }
  //   final nowMs = DateTime.now().microsecondsSinceEpoch;

  //   final deviceRef = db
  //       .collection("Users")
  //       .doc(user.uid)
  //       .collection("devices")
  //       .doc(deviceId);
  //   if ((await deviceRef.get()).exists) {
  //     await deviceRef.update({"updated_at": nowMs, "uninstalled": false});
  //   } else {
  //     await deviceRef.set({
  //       "created_at": nowMs,
  //       "updated_at": nowMs,
  //       "uninstalled": false,
  //       "id": deviceId,
  //       "deviceInfo": deviceData
  //     });

  //     print('SHOULD HAVE DONE EVERYTHING');
  //   }
  // }

  Future<void> uploadUserData(
      {String uid, String userName, String tokenId, String sex}) async {
    try {
      await db
          .collection("Users")
          .doc(uid)
          .collection("appData")
          .doc(uid + uid.length.toString())
          .update({'userName': userName, 'tokenId': tokenId, 'sex': sex});
    } catch (e) {
      print(e.toString().toUpperCase());
    }
  }

//!AIXO ES PER LA PRIMERA VEGADA QUE EL USER ES REGISTRA
  Future<void> uploadUserImg({String uid, String imgUrl}) async {
    String encryptedData = MyEncryption.encryptAESCryptoJS(
        //AppLocalizations.of(context).myHidesFirstMessage,
        'Aqui puedes escribir tus HIDES (notas)\Estas notas se encriptan y sólo son visibles para ti\nClick largo: Eliminalo definitivamente');
    print('AT LEAST TRYING');
    try {
      await db
          .collection("Users")
          .doc(uid)
          .collection("appData")
          .doc(uid + uid.length.toString())
          .update({
        'myHide': [
          {
            'payload': encryptedData,
            'sendAt': DateTime.now().millisecondsSinceEpoch,
            // 'visible': true
          }
        ]
      });
      return db
          .collection("Users")
          .doc(uid)
          .collection("appData")
          .doc(uid + uid.length.toString())
          .update({'photoUrl': imgUrl});
    } catch (e) {
      print(e.toString().toUpperCase());
    }
  }

//!AIXO ES PER QUAN VOL CANVIAR L'IMATGE DE PERFIL
//! ATENCIO AFEGIR EL ELIMINAR-LA DEL STORAGE
  Future<void> changeUserImg({String uid, String imgUrl}) async {
    try {
      if (imgUrl != null) {
        return db
            .collection("Users")
            .doc(uid)
            .collection("appData")
            .doc(uid + uid.length.toString())
            .update({'photoUrl': imgUrl});
      } else {
        print('NULL IMG 😥');
      }
    } catch (e) {
      print(e.toString().toUpperCase());
    }
  }

// QR

  Future<void> addNewContact({String uid, String contactQr}) async {
    try {
      //! Parsejar a través del UID la info o fer request per reclamar la info?
      List<String> iOOut = contactQr.split('|||');
      String info = iOOut[1];
      List<String> all = info.split('||');
      //* all[0]= uid
      //* all[1]= userName
      //* all[2]= photoUrl

      print('IAM GOING TO ADD A CONTACT!!!');
      print('\n\n\n');
      if (db.collection('Users').doc(all[0]).get() != null && uid != all[0]) {
        return db
            .collection('Users')
            .doc(uid)
            .collection('appData')
            .doc(uid + uid.length.toString())
            .update({
          'qrScanned': FieldValue.increment(1),
          'contacts': FieldValue.arrayUnion([
            {
              "uid": all[0].toString(),
              "userName": all[1].toString(),
              "photoUrl": all[2].toString(),
              "fav": false
            }
          ])
        });
      } else {
        print('It is your QR...');
        return;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> whiteList({String uid, String hideHash}) async {
    try {
      //! Atenció aixo s'ha de canviar, sino es una gran fuita de informació
      //! Per a obtenir contes gratis
      //? Hide Hash --> conté la informació de docId
      if (db.collection('HideHash').doc(hideHash).get() != null) {
        final DocumentSnapshot list = await db
            .collection('HideHash')
            .doc(hideHash)
            .get(); //?Codi generat de forma random, que només coneix el disp que "Paga" (uid+userId+HashDealgo)
        //! Tenir present que despres hauria de poder montar-lo
        //! CF que on Update analitzi el val.change().before && after i delete if(needed)
        if (list.data()['invites'] > 0) {
          await db
              .collection('HideHash')
              .doc(hideHash)
              .update({'invites': FieldValue.increment(-1)});
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> startHide({String uid, String scannedHash}) async {
    final nowDate = DateTime.now();
    final now = nowDate.millisecondsSinceEpoch;
    // final subEnd = nowDate;
    // final endSub = subEnd.add(new Duration(days: 30));
    var hideHaSh;
    try {
      hideHaSh = MyEncryption.decryptFernet(scannedHash);
      print(hideHaSh);
    } catch (e) {
      return false;
    }
    // final array = hideHaSh.split('-|||-');
    // final hh = array[0];
    // final sub = array[1];
    final hideHash = MyEncryption.encryptAESCryptoJS(hideHaSh);
    //! Crides a la Cf de generar una factura ?? (false)
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('newHideMember');
    final result = await callable
        .call(<String, dynamic>{'uid': uid, 'hideHash': hideHash});
    if (result.data == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkSubscription({String uid, DateTime today}) async {
    final lastInvoice = await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .collection('HideMember')
        .doc('lastInvoice')
        .get();
    if (lastInvoice.data() != null) {
      if (lastInvoice.data().isNotEmpty) {
        print('\n\n');
        print(lastInvoice.data().toString());
        print('\n\n');
        final endSub = DateTime.fromMillisecondsSinceEpoch(
            lastInvoice.data()['subcriptionEnd']);
        print(endSub.toString());
        print(today.toString());
        if (endSub.isAfter(today)) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> checkIfFirstTime({String uid}) async {
    final lastInvoice = await db
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .collection('HideMember')
        .doc('lastInvoice')
        .get();
    print(lastInvoice.data().toString());
    if (lastInvoice.data() != null) {
      if (lastInvoice.data().isNotEmpty) {
        return false;
      } else {
        print('TRUE');
        return true;
      }
    } else {
      return false;
    }
  }

  //TODO: HideHash
  Future<DocumentSnapshot> getHashes({AuthService auth}) async {
    final uid = await auth.getCurrentUID();
    final DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('appData')
        .doc(uid + uid.length.toString())
        .get();
    // print(result.data()['inviteLink']);
    if (result.data()['inviteLink'] != null) {
      return db.collection('HideHash').doc(result.data()['inviteLink']).get();
    } else {
      return Future<DocumentSnapshot>.value(null);
    }
  }
  //TODO: Cloud Functions

  Future<String> checkPayment({String uid, String coin, String address}) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('paymentCheck');
    final result = await callable
        .call(<String, dynamic>{'uid': uid, 'coin': coin, 'address': address});
    if (result.data != null) {
      print(result.data);
      if (result.data == 'ok') {
        return result.data;
      } else {
        return result.data;
      }
    }
    return 'false';
  }

  Future<dynamic> checkFiatPay(
      {String uid, dynamic data, dynamic data1, dynamic prod}) async {
    // print(uid);
    // print(data);
    // print(prod);
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('paymentFiatCheck');
    final result = await callable.call(<String, dynamic>{
      'uid': uid,
      'data': data.toString(),
      // 'id': data1.toString(),
      'data1': prod.toString()
    });

    if (result.data == 'ok') {
      return true;
    } else {
      print(result.data);
      return false;
    }
    // return false;
  }

  Future<bool> deleteAnAccount({String uid}) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('deleteAccount');
    final result = await callable.call(<String, dynamic>{
      'uid': uid,
    });
    print(result.data.toString());

    if (result.data == 'ok') {
      return true;
    } else {
      print(result.data);
      return false;
    }
    // return false;
  }

  Future<bool> isEmailRegistered({String email}) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('emailRegistered');
    final result = await callable.call(<String, dynamic>{
      'email': email,
    });
    if (result.data == 'true') {
      return false;
    } else {
      return true;
    }
    // return result.data;

    /////////
    //   final QuerySnapshot result = await db
    //       .collection('Users')
    //       .where('userEmail', isEqualTo: email)
    //       .limit(1)
    //       .get();
    //   final List<DocumentSnapshot> documents = result.docs;
    //   if (documents.length > 0) {
    //     print('Email is in Use');
    //     return true;
    //   } else {
    //     print('Email is not in Use');
    //     return false;
    //   }
  }
}
