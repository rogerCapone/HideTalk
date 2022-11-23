import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/encryption.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';

class MyHide extends StatefulWidget {
  final String image;
  final String userUid;
  final String userName;
  final bool fav;

  const MyHide({Key key, this.image, this.userUid, this.userName, this.fav})
      : super(key: key);
  @override
  _MyHideState createState() => _MyHideState();
}

class _MyHideState extends State<MyHide> {
  final myController = TextEditingController();
  bool turned = false;
  List<dynamic> msgDisplay = [];
  List<dynamic> msgShown = [];
  int itemLength = 0;
  bool buttonPressed = false;
  ScrollController _controller = ScrollController();
  List<dynamic> hides;
  // Future<void> secureScreen() async {
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.all(14.5),
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
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1.0,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Stack(
                fit: StackFit.passthrough,
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
                ],
              ),
              GestureDetector(
                onLongPress: () async {
                  final uid = await Provider.of(context).auth.getCurrentUID();
                  await DatabaseMethods()
                      .deleteAllHides(uid: uid, hides: hides);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.delete_forever_sharp,
                        color: Colors.orange,
                        size: 27,
                      ),
                      Icon(
                        Icons.delete_outline_sharp,
                        color: Colors.orange,
                        size: 27,
                      ),
                      Icon(
                        Icons.delete_outline_sharp,
                        color: Colors.black,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
              stream: Global.userRef.userAppData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.data()['myHide'].isNotEmpty) {
                    hides = snapshot.data.data()['myHide'];
                    return ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data.data()['myHide'].length,
                      padding: EdgeInsets.only(
                          top: 10, bottom: getProportionateScreenHeight(80)),
                      // physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        String payload = MyEncryption.decryptAESCryptoJS(
                            snapshot.data.data()['myHide'][index]['payload']);
                        msgDisplay = snapshot.data.data()['myHide'];
                        return GestureDetector(
                            onLongPress: () async {
                              final userUid = await Provider.of(context)
                                  .auth
                                  .getCurrentUID();
                              await DatabaseMethods().deleteHide(
                                  uid: userUid,
                                  hide: snapshot.data.data()['myHide'][index]);
                            },
                            // onTap: () {
                            //   //! Change hide visibility
                            //   //? Al estar en un array, el problema es que he de treure'l i tornar-lo a posar de forma que
                            //   //? No apareixerà en la mateixa posició...
                            //   setState(() {
                            //     tapped = !tapped;
                            //   });
                            // },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 12.5,
                                  right: 12.5,
                                  top: 3.5,
                                  bottom: 3.5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.black.withOpacity(0.3),
                                        gradient: kPrimaryGradientColor),
                                    padding: EdgeInsets.all(13.5),
                                    child: Text(
                                      payload,
                                      style:
                                          kTextStyleBodyMediumCursiva.copyWith(
                                        fontSize: 15.5,
                                      ),
                                      textScaleFactor: 0.95,
                                    ),
                                  ),
                                  // Text(
                                  //   difference > 1440
                                  //       ? '> 1 Dia'
                                  //       : difference > 60
                                  //           ? '> 1 hora'
                                  //           : difference >= 1
                                  //               ? difference.toString() +
                                  //                   ' minutos'
                                  //               : '< 1 minuto',
                                  //   style: kTextStyleBodyMediumCursiva
                                  //       .copyWith(fontSize: 12.5),
                                  // )
                                ],
                              ),
                            ));
                      },
                    );
                    // : Container(
                    //     child: Center(
                    //       child: Text(
                    //         'Escribe tus Hides 🤐',
                    //         style: kTextStyleBodyMediumCursiva,
                    //       ),
                    //     ),
                    //   );
                  } else {
                    //! Aqui aniria la animació de MY HIDES BUIT!
                    return SizedBox();
                  }
                } else {
                  return Container();
                }
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16, bottom: 10),
              height: getProportionateScreenHeight(75),
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  // GestureDetector(
                  //   onLongPress: () {
                  //     print('THIS IS A LONG PRESS');
                  //     setState(() {
                  //       turned = true;
                  //       buttonPressed = !buttonPressed;
                  //     });
                  //     //!ACTIVAR LA ANIMACIÓ PER A QUE GIRIN ELS TEXTOS
                  //   },
                  //   onLongPressEnd: (details) async {
                  //     //!FER QUE S'ACTIVI LA FUNCIÓ D'ELIMINACIÓ DELS CHATS QUE ACABA DE LLEGIR
                  //     final uid =
                  //         await Provider.of(context).auth.getCurrentUID();
                  //     print('DELETING MSGS:');
                  //     print(msgDisplay.toString());
                  //     await DatabaseMethods()
                  //         .deleteMsg(mails: msgDisplay, uid: uid);
                  //     print(details.globalPosition);
                  //     msgDisplay.clear();
                  //     setState(() {
                  //       turned = false;
                  //       buttonPressed = !buttonPressed;
                  //     });
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     width: 50,
                  //     decoration: BoxDecoration(
                  //       color: Colors.black,
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     child: Icon(
                  //       Icons.remove_red_eye_outlined,
                  //       color: Colors.white,
                  //       size: 30,
                  //     ),
                  //   ),
                  // ),
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
              padding: EdgeInsets.only(right: 30, bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    //!COMENÇAR LA ANIMACIÓ DE ENVIAR MISSATGE
                    onPressed: () async {
                      //Encrypt
                      String encryptedData =
                          MyEncryption.encryptAESCryptoJS(myController.text);
                      print(encryptedData);
                      final uid =
                          await Provider.of(context).auth.getCurrentUID();
                      Timer(
                          Duration(milliseconds: 185),
                          () => _controller.jumpTo(
                              _controller.position.maxScrollExtent + 45));
                      await DatabaseMethods()
                          .addMyHide(uid: uid, msg: myController.text);

                      myController.clear();
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
            ),
          )
        ],
      ),
    );
  }
}
