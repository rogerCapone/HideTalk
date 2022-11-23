import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'globals.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:tuple/tuple.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';

class MyEncryption {
  static final keyFernet =
      encrypt.Key.fromUtf8('MaxIsAndW@sTheBestDogEver&Neever');
  static final iv = IV.fromLength(16);

  static final fernet = encrypt.Fernet(keyFernet);
  static final encrypterFernet = encrypt.Encrypter(fernet);
  static final katrina = Global.roboID;

  static encryptFernet(text) {
    final encrypted = encrypterFernet.encrypt(text.toString(), iv: iv);

    return encrypted.base64.toString();
  }

  static decryptFernet(String text) {
    return encrypterFernet.decrypt(Encrypted.fromBase64(text));
  }

  // static final coolKey =
  //     encrypt.Key.fromUtf8('TheBestDogEver&NeeverMaxIs&ItW@s');
  // static final ivy = IV.fromLength(16);

  // static final algorithm = encrypt.Fernet(coolKey);
  // static final encrypterAlgo = encrypt.Encrypter(algorithm);

  // static encryptChatAlgo(text) {
  //   final encrypted = encrypterAlgo.encrypt(text.toString(), iv: ivy);

  //   return encrypted.base16.toString();
  // }

  // static decryptChatAlgo(String text) {
  //   return encrypterAlgo.decrypt(Encrypted.fromBase16(text));
  // }
//YULL8nerCN2bDeAD4ufMlV3hNxRvsP3s
  static final String passphrase = katrina + gTraffic + kBoobie;
  //!Cal ocultarla en diferentes variables per ofuscar-la

  static String encryptAESCryptoJS(String plainText) {
    print(passphrase);
    try {
      final salt = genRandomWithNonZero(8);
      var keyndIV = deriveKeyAndIV(passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      Uint8List encryptedBytesWithSalt = Uint8List.fromList(
          createUint8ListFromString("Salted__") + salt + encrypted.bytes);
      return base64.encode(encryptedBytesWithSalt);
    } catch (error) {
      throw error;
    }
  }

  static String decryptAESCryptoJS(String encrypted) {
    try {
      Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

      Uint8List encryptedBytes =
          encryptedBytesWithSalt.sublist(16, encryptedBytesWithSalt.length);
      final salt = encryptedBytesWithSalt.sublist(8, 16);
      var keyndIV = deriveKeyAndIV(passphrase, salt);
      final key = encrypt.Key(keyndIV.item1);
      final iv = encrypt.IV(keyndIV.item2);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final decrypted =
          encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
      return decrypted;
    } catch (error) {
      throw error;
    }
  }

  static Tuple2<Uint8List, Uint8List> deriveKeyAndIV(
      String passphrase, Uint8List salt) {
    var password = createUint8ListFromString(passphrase);
    Uint8List concatenatedHashes = Uint8List(0);
    Uint8List currentHash = Uint8List(0);
    bool enoughBytesForKey = false;
    Uint8List preHash = Uint8List(0);

    while (!enoughBytesForKey) {
      int preHashLength = currentHash.length + password.length + salt.length;
      if (currentHash.length > 0)
        preHash = Uint8List.fromList(currentHash + password + salt);
      else
        preHash = Uint8List.fromList(password + salt);

      currentHash = md5.convert(preHash).bytes;
      concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
      if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
    }

    var keyBtyes = concatenatedHashes.sublist(0, 32);
    var ivBtyes = concatenatedHashes.sublist(32, 48);
    return new Tuple2(keyBtyes, ivBtyes);
  }

  static Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  static Uint8List genRandomWithNonZero(int seedLength) {
    final random = Random.secure();
    const int randomMax = 245;
    final Uint8List uint8list = Uint8List(seedLength);
    for (int i = 0; i < seedLength; i++) {
      uint8list[i] = random.nextInt(randomMax) + 1;
    }
    return uint8list;
  }

  // static final keyAES =
  //     encrypt.Key.fromUtf8('');
  // static final aes = encrypt.AES(keyAES,mode: encrypt.AESMode.cbc, padding: "PKCS7");
  // static final aesIv = encrypt.IV.(32);
  // static final aesEncrypter = encrypt.Encrypter(aes);

  // static encrypterAes(text) {
  //   print(text);
  //   final encrypted = aesEncrypter.encrypt(text.toString(),);
  //   print(encrypted.bytes);
  //   return encrypted.base64.toString();
  // }

  // static decryptAes(text) {
  //   return aesEncrypter.decrypt(encrypt.Encrypted.from64(text));
  // }
}
