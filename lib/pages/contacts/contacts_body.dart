import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hide_talk/pages/chats/chat/chat.dart';
import 'package:hide_talk/pages/myHide/myHide.dart';
import 'package:hide_talk/pages/qrShow/qrShow.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/encryption.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:async';
import 'package:async/async.dart';

import 'contact_item.dart';

class ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final transitionType = ContainerTransitionType.fadeThrough;
    final color = Colors.green.value;
    print(color.toString());
    TextEditingController addUserString = TextEditingController();
    // ScrollController scroll = ScrollController();
    Future<void> scanQRCode(String uid) async {
      try {
        final encryptedScan = await FlutterBarcodeScanner.scanBarcode(
          '#f88f01',
          AppLocalizations.of(context).back,
          false,
          ScanMode.QR,
        );

        String qrCode = MyEncryption.decryptFernet(encryptedScan);

        if (qrCode.startsWith('iOOi||')) {
          qrCode.replaceAll('iOOi||', '');
          await DatabaseMethods().addNewContact(uid: uid, contactQr: qrCode);
          print('Should have a new Contact');
        } else {
          //// Pot ser que escanegi un QR que no sigui de la app que passa!?
        }
      } on PlatformException {
        print('Failed to get platform version.');
      }
    }

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: kSecondaryColor,
        ),
        ListView(
          children: [
            SizedBox(
              height: 12.5,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: TextsComboStack(),
            ),
            SizedBox(
              height: 9.5,
            ),
            StreamBuilder(
              stream: Global.appRef.userAppData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<dynamic> listDip = snapshot.data.data()['contacts'];
                  bool hasFav = false;
                  for (var i = 0; i < listDip.length; i++) {
                    if (snapshot.data.data()['contacts'][i]['fav'] == true) {
                      hasFav = true;
                    }
                  }

                  if (listDip.length > 0 && hasFav != false) {
                    print(listDip.toString());

                    return Container(
                      height: getProportionateScreenHeight(80),
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: listDip.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          if (listDip[i]['fav'] == true) {
                            return Container(
                              padding: EdgeInsets.all(1.5),
                              height: getProportionateScreenHeight(100),
                              width: getProportionateScreenHeight(100),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kPrimaryColor.withOpacity(0.5)),
                              child: InkWell(
                                onTap: () {
                                  // print(snapshot.data.data()['contacts'][i]
                                  //     ['fav']);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatDetailPage(
                                              image: listDip[i]['photoUrl'],
                                              userName: listDip[i]['userName'],
                                              userUid: listDip[i]['uid'],
                                              fav: listDip[i]['fav'])));
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            getProportionateScreenHeight(11),
                                        vertical:
                                            getProportionateScreenHeight(1)),
                                    height: getProportionateScreenHeight(100),
                                    width: getProportionateScreenHeight(100),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.75)),
                                    child: ExtendedImage.network(
                                      listDip[i]['photoUrl'],
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                      cache: true,

                                      //cancelToken: cancellationToken,
                                    )),

                                ///???
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                } else {
                  return SizedBox();
                }
              },
            ),
            Container(
              height: getProportionateScreenHeight(90),
              width: getProportionateScreenWidth(350),
              margin: EdgeInsets.symmetric(vertical: 12.5, horizontal: 30),
              decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Container(
                height: getProportionateScreenHeight(2),
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<DocumentSnapshot>(
                    future: Global.appRef.getAppDataDoc(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHide(
                                        image: snapshot.data.data()['photoUrl'],
                                        userName:
                                            snapshot.data.data()['userName'],
                                        userUid: snapshot.data.data()['uid'],
                                        fav: snapshot.data.data()['fav']))),
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: kPrimaryGradientColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width:
                                                  getProportionateScreenWidth(
                                                      120),
                                              child: Text(
                                                  snapshot.data
                                                      .data()['userName'],
                                                  textScaleFactor: 0.85,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: kTextStyleBodyMedium
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                            Text(' Hide',
                                                textScaleFactor: 1.0,
                                                style: kTextStyleBodyMedium
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500)),

                                            // Container(
                                            //   color: Colors.red,
                                            //   child:
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // padding: EdgeInsets.only(
                                        //     right: getProportionateScreenWidth(
                                        //         40)),
                                        child: Hero(
                                          tag: snapshot.data.data()['photoUrl'],
                                          child: ExtendedImage.network(
                                            snapshot.data.data()['photoUrl'],
                                            height:
                                                getProportionateScreenHeight(
                                                    60),
                                            width: getProportionateScreenHeight(
                                                60),

                                            fit: BoxFit.cover,
                                            cache: true,
                                            shape: BoxShape.circle,
                                            //cancelToken: cancellationToken,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )));
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
            ),

            //? Candidat per a fer de buscador de contactes 🕵🏻‍♂️🕵🏻‍♂️
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 30),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: "Search...",
            //       hintStyle: TextStyle(color: Colors.grey.shade400),
            //       prefixIcon: Icon(
            //         Icons.search,
            //         color: Colors.grey.shade400,
            //         size: 20,
            //       ),
            //       filled: true,
            //       fillColor: Colors.grey.shade100,
            //       contentPadding: EdgeInsets.all(8),
            //       enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(30),
            //           borderSide: BorderSide(color: Colors.grey.shade100)),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: getProportionateScreenHeight(2.5),
            ),
            ContactListDisplay(),
          ],
        ),
        DraggableScrollableSheet(
          expand: true,
          initialChildSize: 0.15,
          minChildSize: 0.12,
          maxChildSize: 0.6,
          builder: (context, sc) {
            return Container(
                decoration: BoxDecoration(
                  gradient: kPrimaryGradientColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
                child: ListView(
                  controller: sc,
                  children: [
                    Container(
                      height: 27,
                      padding: EdgeInsets.symmetric(horizontal: 12.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () async {
                                  final uid = await Provider.of(context)
                                      .auth
                                      .getCurrentUID();
                                  await scanQRCode(uid);
                                  final snackBar = SnackBar(
                                    backgroundColor: Colors.black,
                                    content: Text(
                                      AppLocalizations.of(context).newContact,
                                      style: kTextStyleWhiteSmallLetter,
                                      textAlign: TextAlign.center,
                                    ),
                                    // action: SnackBarAction(
                                    //   label: 'Undo',
                                    //   onPressed: () {},
                                    // ),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                },
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    child: SvgPicture.asset(
                                      'assets/icons/qr-code.svg',
                                      color: Colors.black.withOpacity(0.65),
                                    )),
                              )),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context).privateQr,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: ClipBoard()

                              ///TODO:
                              )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(padding: EdgeInsets.all(15), child: QrShow()),
                    SizedBox(
                      height: 5.5,
                    ),
                    MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaleFactor: 0.85),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style:
                            kTextStyleBodySmall.copyWith(color: Colors.white),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14.5, horizontal: 9.5),
                            isDense: true,
                            hintText: AppLocalizations.of(context).copyContact,
                            hintStyle: kTextStyleBodySmall.copyWith(
                                color: Colors.white),
                            border: InputBorder.none),
                        controller: addUserString,
                        onChanged: (string) async {
                          if (string.length > 200) {
                            final uid =
                                await Provider.of(context).auth.getCurrentUID();
                            String qrCode = MyEncryption.decryptFernet(string);
                            if (qrCode.startsWith('iOOi||')) {
                              qrCode.replaceAll('iOOi||', '');
                              await DatabaseMethods()
                                  .addNewContact(uid: uid, contactQr: qrCode);
                              print('Should have a new Contact');
                              final snackBar = SnackBar(
                                backgroundColor: Colors.black,
                                content: Text(
                                  'Tienes un nuevo contacto 😊',
                                  style: kTextStyleWhiteSmallLetter,
                                  textAlign: TextAlign.center,
                                ),
                                // action: SnackBarAction(
                                //   label: 'Undo',
                                //   onPressed: () {},
                                // ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                              addUserString.clear();
                            } else {
                              //// Pot ser que escanegi un QR que no sigui de la app que passa!?
                            }
                          } else {}
                        },
                        onSubmitted: (string) async {
                          final uid =
                              await Provider.of(context).auth.getCurrentUID();
                          String qrCode = MyEncryption.decryptFernet(string);
                          if (qrCode.startsWith('iOOi||')) {
                            qrCode.replaceAll('iOOi||', '');
                            await DatabaseMethods()
                                .addNewContact(uid: uid, contactQr: qrCode);
                            print('Should have a new Contact');

                            final snackBar = SnackBar(
                              backgroundColor: Colors.black,
                              content: Text(
                                'Tienes un nuevo contacto 😊',
                                style: kTextStyleWhiteSmallLetter,
                                textAlign: TextAlign.center,
                              ),
                              // action: SnackBarAction(
                              //   label: 'Undo',
                              //   onPressed: () {},
                              // ),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                            addUserString.clear();
                          } else {
                            addUserString.clear();

                            //// Pot ser que escanegi un QR que no sigui de la app que passa!?
                          }
                        },
                      ),
                    ),
                  ],
                ));
          },
        ),
      ],
    );
  }
}

class ClipBoard extends StatefulWidget {
  const ClipBoard({
    Key key,
  }) : super(key: key);

  @override
  _ClipBoardState createState() => _ClipBoardState();
}

class _ClipBoardState extends State<ClipBoard> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  DocumentSnapshot snapshot;

  Future<dynamic> _fetchData() {
    return this._memoizer.runOnce(() async {
      snapshot = await Global.appRef.getAppDataDoc();
      return snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      child: FutureBuilder<dynamic>(
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

              return GestureDetector(
                onTap: () {
                  Clipboard.setData(new ClipboardData(text: encryptedData))
                      .then((result) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.black,
                      content: Text(
                        'Tu contacto se ha copiado en el porta papeles', //AppLocalizations.of(context).copiedClipboard,
                        style:
                            kTextStyleSmallLetter.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      // action: SnackBarAction(
                      //   label: 'Undo',
                      //   onPressed: () {},
                      // ),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  });
                },
                child: Container(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset('assets/icons/clipBoard.svg')),
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }
}

class TextsComboStack extends StatelessWidget {
  const TextsComboStack({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          "Hidden",
          style: kTextStyleBodyBig.copyWith(
              fontSize: 32.5, fontWeight: FontWeight.w600),
        ),
        Text(
          "Hidden",
          style: kTextStyleBodyBig.copyWith(fontSize: 33, color: Colors.white),
        ),
        Text(
          "Hidden",
          style: kTextStyleBodyBig.copyWith(
              fontSize: 33.5, fontWeight: FontWeight.w600),
        ),
        Text(
          "Hidden",
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          "Hidden",
          style: kTextStyleBodyBig.copyWith(
              fontSize: 34.5, fontWeight: FontWeight.w600),
        ),
        Text(
          "Hidden",
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          "Hidden",
          style: kTextStyleBodyBig.copyWith(
              fontSize: 35, fontWeight: FontWeight.w600),
        ),
        Text(
          "Hidden",
          style:
              kTextStyleBodyBig.copyWith(fontSize: 35.5, color: Colors.white),
        ),
      ],
    );
  }
}

class ContactListDisplay extends StatelessWidget {
  const ContactListDisplay({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Global.userRef.userAppData,
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData) {
          List<dynamic> listDip = snap.data.data()['contacts'];
          if (listDip.length == 0) {
            return SizedBox();
          } else {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              height: getProportionateScreenHeight(500) - 45,
              width: double.infinity,
              child: GridView.builder(
                reverse: false,
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                primary: true,
                padding: const EdgeInsets.all(12.5),
                itemCount: listDip.length + 3,
                itemBuilder: (context, i) {
                  if (i < listDip.length) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                            padding: EdgeInsets.all(5),
                            child: ContactItem(contact: listDip[i])),
                        Positioned(
                          top: 2.5,
                          right: 2.5,
                          child: InkWell(
                              onTap: () async {
                                print('TAPPED');
                                final uid = await Provider.of(context)
                                    .auth
                                    .getCurrentUID();
                                await DatabaseMethods().addToFavorite(
                                    uid: uid, contact: listDip[i]);
                              },
                              child:
                                  snap.data.data()['contacts'][i]['fav'] == true
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            ),
                                            Icon(
                                              Icons.favorite_border_outlined,
                                              color: Colors.black,
                                            ),
                                          ],
                                        )
                                      : Icon(
                                          Icons.favorite_border_outlined,
                                          color: Colors.white,
                                        )),
                        ),
                        Positioned(
                          top: -1.5,
                          left: 0.5,
                          child: InkWell(
                              onTap: () async {
                                print('TAPPED');
                                final uid = await Provider.of(context)
                                    .auth
                                    .getCurrentUID();
                                await DatabaseMethods()
                                    .hideContact(uid: uid, contact: listDip[i]);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/hide.svg',
                                      height: 22.8,
                                      width: 22.8,
                                      color: Colors.white),
                                  SvgPicture.asset('assets/icons/hide.svg',
                                      height: 21,
                                      width: 21,
                                      color: Colors.black),
                                  SvgPicture.asset(
                                    'assets/icons/hide.svg',
                                    height: 19,
                                    width: 19,
                                    color: Colors.white,
                                  ),
                                ],
                              )),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                              height: getProportionateScreenHeight(20),
                              width: getProportionateScreenWidth(80),
                              margin: EdgeInsets.symmetric(vertical: 2.5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                child: Text(
                                  snap.data.data()['contacts'][i]['userName'],
                                  style: kTextStyleBodyContact,
                                  textScaleFactor: 0.95,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )),
                      ],
                    );
                  } else {
                    //!Show 3 fake items (not visible for user)
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          height: getProportionateScreenWidth(95),
                          width: getProportionateScreenWidth(95),
                        )
                      ],
                    );
                  }
                },
              ),
            );
          }
        } else {
          return SizedBox();
        }
      },
    );
  }
}
