import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hide_talk/services/encryption.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'dart:async';
import 'package:async/async.dart';

class QrShow extends StatefulWidget {
  const QrShow({Key key}) : super(key: key);

  @override
  _QrShowState createState() => _QrShowState();
}

class _QrShowState extends State<QrShow> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  // AsyncMemoizer _memorizer = AsyncMemoizer<List<bool>>();

  DocumentSnapshot snapshot;

  Future<dynamic> _fetchData() {
    return this._memoizer.runOnce(() async {
      print('ONE SHOT');

      snapshot = await Global.appRef.getAppDataDoc();
      return snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: this._fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final String uid =
                snapshot.data.id.substring(0, snapshot.data.id.length - 2);
            String data = 'iOOi|||' +
                uid +
                '||' +
                snapshot.data.data()['userName'] +
                '||' +
                snapshot.data.data()['photoUrl'];

            String encryptedData = MyEncryption.encryptFernet(data);
            encryptedData = encryptedData;

            return Center(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  height: getProportionateScreenHeight(355),
                  width: getProportionateScreenWidth(355),
                  child: PrettyQr(
                      elementColor: Colors.black,
                      typeNumber: 19,
                      size: 350,
                      data: encryptedData.toString(),
                      roundEdges: true)),
            );
          } else {
            return Container();
          }
        });
  }
}
