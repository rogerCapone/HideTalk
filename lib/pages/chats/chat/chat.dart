import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'dart:math';

import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hide_talk/pages/chats/chat/chatSettings.dart';
import 'package:hide_talk/widgets/important/camera/camera_screen.dart';
import 'package:image_picker/image_picker.dart';

import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/encryption.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'hideImage.dart';

enum MessageType {
  Sender,
  Receiver,
}

class ChatDetailPage extends StatefulWidget {
  final String image;
  final String userUid;
  final String userName;
  final bool fav;

  const ChatDetailPage(
      {Key key, this.image, this.userUid, this.userName, this.fav})
      : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with SingleTickerProviderStateMixin {
  final myController = TextEditingController();
  bool turned = false;
  List<dynamic> msgDisplay = [];
  int itemLength = 0;
  bool buttonPressed = false;
  bool sending = false;
  // AnimationController _animationController;
  // Animation curvedAnimation;
  ScrollController _controller = ScrollController();
  List willDeleteList = [];
  List deletingMsgs = [];
  int counter = 0;
  String sendingText;
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    secureScreen();
    super.initState();
    // _animationController =
    //     AnimationController(duration: Duration(seconds: 5), vsync: this);
    // curvedAnimation =
    //     CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    // _animationController.forward();
  }

  @override
  void dispose() async {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    setState(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;
    void getAnotherShot() {
      if (counter == 0) {
        counter++;
      } else {
        setState(() {});
        counter++;
      }
    }

    //////////////////
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(getProportionateScreenHeight(250)),
        child: Container(
          padding: EdgeInsets.only(top: getProportionateScreenHeight(35)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: getProportionateScreenHeight(40),
                  width: getProportionateScreenHeight(40),
                  padding: EdgeInsets.all(getProportionateScreenWidth(10.5)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: SvgPicture.asset('assets/icons/Back ICon.svg')),
                ),
              ),
              Container(
                width: getProportionateScreenWidth(140),
                child: Text(
                  widget.userName,
                  style: kTextStyleBodyMediumCursiva.copyWith(
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1.0,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Stack(
                children: [
                  Container(
                    height: getProportionateScreenHeight(95),
                    width: getProportionateScreenHeight(95),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Hero(
                      tag: widget.image,
                      child: ExtendedImage.network(
                        widget.image,
                        height: getProportionateScreenHeight(95),
                        width: getProportionateScreenHeight(95),

                        fit: BoxFit.cover,
                        cache: true,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        //cancelToken: cancellationToken,
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: widget.fav == true
                  //       ? Icon(
                  //           Icons.favorite_rounded,
                  //           color: Colors.red,
                  //           size: 22,
                  //         )
                  //       : Icon(
                  //           Icons.favorite_outline_outlined,
                  //           color: Colors.black,
                  //           size: 22,
                  //         ),
                  // ),
                  // Positioned(
                  //   bottom: 1,
                  //   right: 0,
                  //   child: widget.fav == true
                  //       ? Icon(
                  //           Icons.favorite_outline_outlined,
                  //           color: Colors.black,
                  //           size: 22,
                  //         )
                  //       : Icon(
                  //           Icons.favorite_outline_outlined,
                  //           color: Colors.white,
                  //           size: 22,
                  //         ),
                  // ),
                ],
              ),
              SizedBox(
                width: 22,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatSettingsPage(
                              fav: widget.fav,
                              image: widget.image,
                              userName: widget.userName,
                              userUid: widget.userUid,
                            ))),
                child: Transform.rotate(
                  angle: pi,
                  child: Container(
                    height: getProportionateScreenHeight(40),
                    width: getProportionateScreenHeight(40),
                    padding: EdgeInsets.all(getProportionateScreenWidth(9.5)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: SvgPicture.asset('assets/icons/options.svg')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
              stream: Global.userRef.inboxStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (!buttonPressed) {
                    msgDisplay.clear();

                    if (counter == 0) {
                      getAnotherShot();
                    } // print(willDeleteList.toString());

                    for (int i = 0;
                        i < snapshot.data.data()['inbox'].length;
                        i++) {
                      //! AQUI HE DE PARSEJAR LA DATA PER PODER-LA INTERPRETAR
                      var firstDecrypt = MyEncryption.decryptAESCryptoJS(
                          snapshot.data.data()['inbox'][i]);
                      List<dynamic> decrypted = firstDecrypt.split('|||');
                      // print(decrypted.toString());
                      if (decrypted[0] == widget.userUid) {
                        if (decrypted[2] == 'true') {
                          print(decrypted[2]);
                        } else {
                          willDeleteList.add(snapshot.data.data()['inbox'][i]);
                        }
                        msgDisplay.add({
                          'sendBy': decrypted[0], //! (string) senderUID;
                          'myUid': decrypted[1], //! (string) reciverUID;
                          'image': decrypted[2], //! (bool)   image;
                          'imageUrl': decrypted[3], //! (string)   imageUrl;
                          'msg': decrypted[4], //! (string)  msg;
                          'sendAt':
                              int.parse(decrypted[5]), //! (string)  sendAt;
                          'sendByName': decrypted[6], //! (string) SendByName;
                          'senderPic': decrypted[7],
                          'payload': snapshot.data.data()['inbox'][i]
                        });
                      } else {
                        // willDeleteList.remove(snapshot.data.data()['inbox'][i]);
                      }
                      // print(msgDisplay.toString());
                      // if (snapshot.data.data()['inbox'][i]['sendBy'] ==
                      //     widget.userUid) {
                      //   if (msgDisplay
                      //       .contains(snapshot.data.data()['inbox'][i])) {
                      //     //? Aleshores no facis res, ja esta
                      //   } else {
                      //     msgDisplay.add(snapshot.data.data()['inbox'][i]);
                      //   }
                      // }
                    }
                    //? Ara tenim msgDisplay = [{sendy:uidsender, myUid:uid, image:false,imageUrl:'',msg:'This is a message',}]
                  }
                  // print('\n\n\n\n');
                  // print(msgDisplay.length.toString());
                  // print('\n\n\n\n');
                  final jsonList =
                      msgDisplay.map((item) => jsonEncode(item)).toList();
                  final uniqueJsonList = jsonList.toSet().toList();
                  print(uniqueJsonList);
                  deletingMsgs = willDeleteList.toSet().toList();

                  msgDisplay = msgDisplay.toSet().toList();

                  print(deletingMsgs.length);
                  print(willDeleteList.length);

                  return snapshot.data.data()['inbox'].length != 0
                      ? ListView.builder(
                          itemCount: uniqueJsonList.length,
                          padding: EdgeInsets.only(
                              left: 8.5,
                              right: 25,
                              top: 10,
                              bottom: getProportionateScreenHeight(80)),
                          // physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // if (snapshot.data.data()['inbox'][index]
                            //         ['sendBy'] ==
                            //     widget.userUid) {
                            //the birthday's date
                            final sendAt = DateTime.fromMillisecondsSinceEpoch(
                                msgDisplay[index]['sendAt']);
                            final date2 = DateTime.now();
                            final difference =
                                date2.difference(sendAt).inMinutes;
                            String payload = msgDisplay[index]['msg'];

                            return msgDisplay[index]['imageUrl'] != ''
                                ? Container(
                                    height: getProportionateScreenHeight(120),
                                    width: getProportionateScreenHeight(120),
                                    padding: EdgeInsets.only(
                                        left: 12.5,
                                        right: 12.5,
                                        top: 3.5,
                                        bottom: 3.5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            var navResult =
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => HideImage(
                                                          imgUrl:
                                                              msgDisplay[index]
                                                                  ['imageUrl'],
                                                          userName: msgDisplay[index]
                                                              ['sendByName'],
                                                          sendAt: DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  msgDisplay[index]
                                                                      [
                                                                      'sendAt']),
                                                          senderPic:
                                                              msgDisplay[index]
                                                                  ['senderPic'],
                                                          payload:
                                                              msgDisplay[index]
                                                                  ['payload']),
                                                    ));

                                            print(msgDisplay.length);
                                            print(msgDisplay.length);
                                            print(msgDisplay.length);
                                            if (navResult == true) {
                                              setState(() {
                                                msgDisplay =
                                                    msgDisplay.toSet().toList();
                                              });
                                            } else {
                                              setState(() {
                                                msgDisplay =
                                                    msgDisplay.toSet().toList();
                                              });
                                            }
                                          },
                                          child: Container(
                                            height:
                                                getProportionateScreenHeight(
                                                    110),
                                            width: getProportionateScreenHeight(
                                                110),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                gradient:
                                                    kPrimaryGradientColor),
                                            padding: EdgeInsets.all(28),
                                            child: Container(
                                              height:
                                                  getProportionateScreenHeight(
                                                      45),
                                              width:
                                                  getProportionateScreenHeight(
                                                      45),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                      'assets/images/hideTalk0.png',
                                                    ),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.only(
                                        left: 12.5,
                                        right: 12.5,
                                        top: 3.5,
                                        bottom: 3.5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              gradient: kPrimaryGradientColor),
                                          padding: EdgeInsets.all(13.5),
                                          child: Text(
                                            payload,
                                            style: turned == false
                                                ? kTextStyleBodyMediumCursiva
                                                    .copyWith(
                                                        color:
                                                            Colors.transparent)
                                                : kTextStyleBodyMediumCursiva,
                                            textScaleFactor: 0.95,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 12.5,
                                            ),
                                            Text(
                                              difference > 1440
                                                  ? AppLocalizations.of(context)
                                                      .moreThanDay
                                                  : difference > 60
                                                      ? AppLocalizations.of(
                                                              context)
                                                          .moreThanHour
                                                      : difference > 1
                                                          ? difference
                                                                  .toString() +
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .minutes
                                                          : AppLocalizations.of(
                                                                  context)
                                                              .lessThanMinute,
                                              style: kTextStyleBodyMediumCursiva
                                                  .copyWith(fontSize: 12.5),
                                              textScaleFactor: 0.65,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                            // } else {
                            //   return SizedBox();
                            // }
                          },
                        )
                      : sending == false
                          ? Container(
                              //! PLACE THE APP ANIMATION (NO MESSAGES)
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).noMessages,
                                      style: kTextStyleBodyMediumCursiva,
                                      textScaleFactor: 1.0,
                                    ),
                                    Text(
                                      '\n',
                                      style: kTextStyleBodyMediumCursiva,
                                      textScaleFactor: 1.0,
                                    ),
                                    Text(
                                      AppLocalizations.of(context).sendOne,
                                      style: kTextStyleBodyMediumCursiva,
                                      textScaleFactor: 1.0,
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(80),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox();
                } else {
                  return Container();
                }
              }),
          // sending

          AnimatedPositioned(
            duration: Duration(milliseconds: 1250),
            curve: Curves.linear,
            bottom: sending ? MediaQuery.of(context).size.height + 80 : 0,
            child: Container(
              width: getProportionateScreenWidth(220),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: sending
                        ? Colors.black.withOpacity(0.3)
                        : Colors.transparent,
                    gradient: kPrimaryGradientColor),
                padding: EdgeInsets.all(13.5),
                child: Text(
                  sendingText != null
                      ? sendingText.length > 20
                          ? sendingText.substring(15)
                          : sendingText
                      : '',
                  overflow: TextOverflow.fade,
                  style: kTextStyleBodyMediumCursiva.copyWith(
                      color: Colors.transparent),
                  textScaleFactor: 0.65,
                ),
              ),
            ),
          ),
          //     //!ANIMATION NOT WORKING
          //     ? AnimatedPositioned(
          //         duration: Duration(seconds: 6),
          //         bottom:
          //             sending ? MediaQuery.of(context).size.height + 100 : 0,
          //         top: sending ? -100 : MediaQuery.of(context).size.height,
          //         onEnd: () {
          //           setState(() {
          //             sending = false;
          //           });
          //         },
          //         child: Container(
          //           height: getProportionateScreenHeight(30),
          //           width: getProportionateScreenHeight(100),
          //           color: Colors.red,
          //           padding: EdgeInsets.only(
          //               left: 16, right: 16, top: 10, bottom: 10),
          //           child: Container(
          //             decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(30),
          //                 color: Colors.red),
          //             padding: EdgeInsets.all(16),
          //             child: Text(
          //               myController.value.text,
          //               style: kTextStyleBodyMediumCursiva.copyWith(
          //                   color: Colors.transparent),
          //               textScaleFactor: 0.65,
          //             ),
          //           ),
          //         ),
          //       )
          //     : SizedBox(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              height: getProportionateScreenHeight(75),
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () {
                      print('THIS IS A LONG PRESS');
                      setState(() {
                        turned = true;
                        buttonPressed = !buttonPressed;
                      });
                      //!ACTIVAR LA ANIMACIÓ PER A QUE GIRIN ELS TEXTOS
                    },
                    onLongPressEnd: (details) async {
                      //!FER QUE S'ACTIVI LA FUNCIÓ D'ELIMINACIÓ DELS CHATS QUE ACABA DE LLEGIR
                      final uid =
                          await Provider.of(context).auth.getCurrentUID();
                      print('DELETING MSGS:');
                      print('Lenght: ');
                      print(willDeleteList.length);
                      await DatabaseMethods()
                          .deleteMsg(mails: deletingMsgs, uid: uid);
                      // print(details.globalPosition);
                      msgDisplay.clear();
                      willDeleteList.clear();
                      setState(() {
                        turned = false;
                        buttonPressed = !buttonPressed;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: getProportionateScreenWidth(35),
                        // bottom: getProportionateScreenWidth(2.5),
                      ),
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 0.85),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          style: kTextStyleBodySmall,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.5, horizontal: 9.5),
                              isDense: true,
                              hintText: "Escribe tu mensaje...",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              border: InputBorder.none),
                          controller: myController,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 15, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        //!COMENÇAR LA ANIMACIÓ DE ENVIAR MISSATGE
                        onPressed: () async {
                          if (sending == true) {
                            print('WAS SENDING SOMETHING, SHOULD BE DELTED');
                          } else {
                            setState(() {
                              sending = false;
                            });
                            //Encrypt
                            var spaceContent =
                                myController.text.replaceAll(' ', '');

                            if (myController.text != ' ' &&
                                myController.text != '  ' &&
                                myController.text != '' &&
                                myController.text.isNotEmpty &&
                                spaceContent.length > 0) {
                              var payload = myController.text;
                              sendingText = payload;
                              setState(() {
                                sending = true;
                              });
                              myController.clear();

                              final uid = await Provider.of(context)
                                  .auth
                                  .getCurrentUID();
                              final DocumentSnapshot userDoc =
                                  await DatabaseMethods()
                                      .lookForMyContactData(uid);
                              Timer(
                                  Duration(milliseconds: 320),
                                  () => _controller.jumpTo(
                                      _controller.position.maxScrollExtent +
                                          45));
                              await DatabaseMethods().sendMessage(
                                payload: payload,
                                sendAt: DateTime.now().millisecondsSinceEpoch,
                                sendTo: widget.userUid,
                                image: false,
                                imageUrl: '',
                                sendBy: uid,
                                sendByName: userDoc.data()['userName'],
                                senderPic: userDoc.data()['photoUrl'],
                              );
                              setState(() {
                                sending = false;
                              });
                            } else {
                              myController.clear();
                            }
                          }
                        },
                        child: Transform.rotate(
                          angle: -0.5 * pi,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: kPrimaryColor.withOpacity(0.45),
                        elevation: 10,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(45),
                          width: getProportionateScreenHeight(45),
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                msgDisplay.clear();
                              });
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CameraScreen(
                                            userName: widget.userName,
                                            senderPic: widget.image,
                                            userUid: widget.userUid,
                                          )));
                              if (result == true) {
                                setState(() {});
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenWidth(12.5),
                                  horizontal:
                                      getProportionateScreenWidth(12.5)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xFFF5F6F9).withOpacity(0.6),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/Camera Icon.svg",
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
