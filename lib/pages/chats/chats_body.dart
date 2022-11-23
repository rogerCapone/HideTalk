import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/encryption.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';

import 'chat/chat.dart';

class ChatsBody extends StatefulWidget {
  @override
  _ChatsBodyState createState() => _ChatsBodyState();
}

class _ChatsBodyState extends State<ChatsBody>
    with SingleTickerProviderStateMixin {
  String qrScanned;
  bool qr_opened;

  AnimationController _animationController;
  Animation curvedAnimation;

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 4), vsync: this);
    curvedAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.elasticInOut);
    _animationController.repeat();
  }

  @override
  void dispose() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: kSecondaryColor,
          ),
          child: ListView(
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Text(
                            "Hiddes",
                            style: kTextStyleBodyBig.copyWith(
                                fontSize: 31, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Hiddes",
                            style: kTextStyleBodyBig.copyWith(
                                fontSize: 33.5, color: Colors.white),
                          ),
                          Text(
                            "Hiddes",
                            style: kTextStyleBodyBig.copyWith(
                                fontSize: 32, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Hiddes",
                            style: kTextStyleBodyBig.copyWith(
                                fontSize: 32.5, color: Colors.white),
                          ),
                          Text(
                            "Hiddes",
                            style: kTextStyleBodyBig.copyWith(
                                fontSize: 33, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Hiddes",
                            style: kTextStyleBodyBig.copyWith(
                                fontSize: 34, color: Colors.white),
                          ),
                          Text(
                            "Hiddes",
                            style: kTextStyleBodyBig.copyWith(
                                fontSize: 35, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Hiddes",
                            style: kTextStyleBodyBig.copyWith(
                                fontSize: 35.5, color: Colors.white),
                          ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () async {
                      //     // String uid =
                      //     //     await Provider.of(context).auth.getCurrentUID();
                      //     // return scanQRCode(uid);
                      //   },
                      //   child: Container(
                      //     height: 51.5,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(30),
                      //       color: Colors.white,
                      //     ),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 1.5, vertical: 1.5),
                      //     child: Container(
                      //       height: 50,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30),
                      //         color: kPrimaryColor,
                      //       ),
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 2.5, vertical: 2.5),
                      //       child: Container(
                      //         padding: EdgeInsets.only(
                      //             left: 8, right: 15, top: 2, bottom: 2),
                      //         height: 40,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(30),
                      //           color: Colors.black,
                      //         ),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: <Widget>[
                      //             Icon(
                      //               Icons.add,
                      //               color: Colors.white,
                      //               size: 25,
                      //             ),
                      //             SizedBox(
                      //               width: 2,
                      //             ),
                      //             Stack(
                      //               alignment: Alignment.center,
                      //               children: [
                      //                 Text(
                      //                   "SCAN",
                      //                   style: TextStyle(
                      //                       color: Colors.white,
                      //                       fontSize: 14.5,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //                 Text(
                      //                   "SCAN",
                      //                   style: TextStyle(
                      //                       color: Colors.orange,
                      //                       fontSize: 15,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Container(
                    height: getProportionateScreenHeight(500),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(getProportionateScreenHeight(125)),
                    child: RotationTransition(
                      turns: Tween<double>(begin: 0, end: 1)
                          .animate(_animationController),
                      child: Container(
                        height: getProportionateScreenHeight(250),
                        width: getProportionateScreenHeight(200),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image:
                                    AssetImage('assets/images/hideTalk.png'))),
                      ),
                    ),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: Global.userRef.inboxStream,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          List<dynamic> dispList = [];
                          List<dynamic> allMsgs = [];
                          List<Map<String, dynamic>> uidCounter = [];
                          bool found = false;
                          String notContained;

                          //! CREAR UNA FORMA DE VISUALITZAR ELS MISSATGES
                          //! ONLY ONE TIME X USER

                          //?PROCEDIMENT:
                          for (var i = 0;
                              i < snapshot.data.data()['inbox'].length;
                              i++) {
                            String firstDecrypt =
                                MyEncryption.decryptAESCryptoJS(
                                    snapshot.data.data()['inbox'][i]);
                            print(firstDecrypt.toString());

                            List<dynamic> decrypted = firstDecrypt.split('|||');
                            // print(decrypted.toString());
                            if (uidCounter.length == 0) {
                              uidCounter.add({
                                'uid': decrypted[0],
                                'counter': 1,
                              });
                            } else {
                              for (var z = 0; z < uidCounter.length; z++) {
                                if (uidCounter[z].containsValue(decrypted[0])) {
                                  print(decrypted[0]);
                                  print('==');
                                  print(uidCounter[z]['uid']);
                                  print(uidCounter[z]['counter']);
                                  uidCounter[z].update(
                                      'counter', (dynamic count) => ++count);
                                  // ['counter'] =
                                  //     uidCounter[z]['counter'] + 1;
                                  // print(uidCounter[z]['counter']);
                                  found = true;
                                  print('es');
                                } else {
                                  print('No es');
                                }
                              }
                              if (found == false) {
                                uidCounter.add({
                                  'uid': decrypted[0],
                                  'counter': 1,
                                });
                              }

                              found = false;
                            }

                            allMsgs.add({
                              'sendBy': decrypted[0], //! (string) senderUID;
                              'myUid': decrypted[1], //! (string) reciverUID;
                              'image': decrypted[2], //! (bool)   image;
                              'imageUrl': decrypted[3], //! (string)   imageUrl;
                              'msg': decrypted[4], //! (string)  msg;
                              'sendAt':
                                  int.parse(decrypted[5]), //! (string)  sendAt;
                              'sendByName': decrypted[6],
                              'senderPic': decrypted[7]
                            });
                          }
                          //* Recorre'ls tots i crear una llista amb tots els decrypted payloads
                          for (var i = 0; i < allMsgs.length; i++) {
                            if (dispList.length == 0) {
                              dispList.add(allMsgs[i]);
                            } else {
                              bool trobat = false;
                              for (var j = 0; j < dispList.length; j++) {
                                if (dispList[j]['sendBy'] ==
                                    allMsgs[i]['sendBy']) {
                                  trobat = true;
                                } else {}
                              }
                              if (trobat == true) {
                              } else {
                                dispList.add(allMsgs[i]);
                              }
                            }
                          }

                          //* Recorre aquesta newList i crear una altre que s'ha de recorrer per veure si ja hi es
                          //* Si ja esta, no es fa res, sino esta, s'insereix

                          //* Aquesta llista es la que fa que es mostri a CHATS

                          // print(snapshot.data.data()['inbox']);
                          // if (snapshot.data.data().length == 0) {
                          // } else {
                          //   int n_pdtHiddes =
                          //       snapshot.data.data()['inbox'].length;
                          //   List<dynamic> allMsgs =
                          //       snapshot.data.data()['inbox'];

                          //   for (var i = 0; i < allMsgs.length; i++) {
                          //     if (dispList.length == 0) {
                          //       dispList.add(allMsgs[0]);
                          //     }
                          //     for (var j = 0; j < dispList.length; j++) {
                          //       if (dispList[j]
                          //           .containsValue(allMsgs[i]['sendBy'])) {
                          //       } else {
                          //         dispList.add(allMsgs[i]);
                          //       }
                          //     }
                          //   }
                          // }
                          return snapshot.data.data()['inbox'].length == 0
                              ? SizedBox()
                              : Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.builder(
                                    itemCount: dispList.length,
                                    itemBuilder: (context, i) {
                                      int sendAt = dispList[i]['sendAt'];
                                      int counter;
                                      for (var r = 0;
                                          r < uidCounter.length;
                                          r++) {
                                        if (uidCounter[r]['uid'] ==
                                            dispList[i]['sendBy']) {
                                          counter = uidCounter[r]['counter'];
                                        }
                                      }
                                      print(uidCounter.toString());
                                      final sa =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              sendAt);

                                      final date2 = DateTime.now();
                                      final difference =
                                          date2.difference(sa).inMinutes;

                                      String sendBy = dispList[i]['sendBy'];

                                      // String sendByName =
                                      //     dispList[i]['sendByName'];
                                      // String senderPic =
                                      //     dispList[i]['senderPic'];

                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatDetailPage(
                                                          image: dispList[i][
                                                              'senderPic'], //'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2Fano.jpeg?alt=media&token=5cbca437-88c8-4448-8548-ff958da006da', //
                                                          userName: dispList[i][
                                                              'sendByName'], //'Hide User', //sendByName,
                                                          userUid: sendBy,
                                                        ))),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.5,
                                                  horizontal: 1.5),
                                              height:
                                                  getProportionateScreenHeight(
                                                      85),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  getProportionateScreenWidth(
                                                      30),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        85),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    getProportionateScreenWidth(
                                                        30),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient:
                                                      kPrimaryGradientColor,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10,
                                                                left: 15),
                                                        child: Text(
                                                          dispList[i][
                                                                  'sendByName'] ??
                                                              "", //  'Hide User',
                                                          style: kTextStyleBodyMedium
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          textScaleFactor: 0.9,
                                                        )),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                                getProportionateScreenHeight(
                                                                    20),
                                                            left:
                                                                getProportionateScreenWidth(
                                                                    15)),
                                                        child: Text(
                                                          difference > 1440
                                                              ? '> 1 Dia'
                                                              : difference > 60
                                                                  ? '> 1 hora'
                                                                  : difference >=
                                                                          1
                                                                      ? difference
                                                                              .toString() +
                                                                          ' minutos'
                                                                      : '< 1 minuto',
                                                          textScaleFactor: 0.75,
                                                          style:
                                                              kTextStyleBodyMediumCursiva
                                                                  .copyWith(
                                                                      fontSize:
                                                                          15),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: getProportionateScreenHeight(
                                                40),
                                            right: getProportionateScreenHeight(
                                                    75) +
                                                10,
                                            child: Container(
                                              height:
                                                  getProportionateScreenHeight(
                                                      30),
                                              width:
                                                  getProportionateScreenHeight(
                                                      30),
                                              decoration: BoxDecoration(
                                                color: kSecondaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  counter.toString(),
                                                  textScaleFactor: 1.0,
                                                  style:
                                                      kTextStyleWhiteSmallLetter,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 2,
                                            child: Container(
                                              height:
                                                  getProportionateScreenHeight(
                                                      75),
                                              width:
                                                  getProportionateScreenHeight(
                                                      75),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.95,
                                                  horizontal: 0.95),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black),
                                              child: Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        75),
                                                width:
                                                    getProportionateScreenHeight(
                                                        75),
                                                child: Hero(
                                                  tag: dispList[i]['senderPic'],
                                                  child: ExtendedImage.network(
                                                    dispList[i]['senderPic'],
                                                    height:
                                                        getProportionateScreenHeight(
                                                            75),
                                                    width:
                                                        getProportionateScreenHeight(
                                                            75),
                                                    fit: BoxFit.cover,
                                                    cache: true,
                                                    shape: BoxShape.circle,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30.0)),
                                                    //cancelToken: cancellationToken,
                                                  ),
                                                ),
                                                // decoration: BoxDecoration(
                                                //   shape: BoxShape.circle,
                                                //   image: DecorationImage(
                                                //     fit: BoxFit.cover,
                                                //     image: NetworkImage(
                                                //         dispList[i][
                                                //             'senderPic'] //'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2Fano.jpeg?alt=media&token=5cbca437-88c8-4448-8548-ff958da006da'
                                                //         ),
                                                //   ),
                                                // ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                        } else {
                          return SizedBox();
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
