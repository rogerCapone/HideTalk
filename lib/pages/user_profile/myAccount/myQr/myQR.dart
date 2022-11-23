import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_talk/pages/contacts/contacts_body.dart';
import 'package:hide_talk/pages/legal/privacyPolicy.dart';
import 'package:hide_talk/pages/legal/termsAndConditions.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyQR extends StatefulWidget {
  @override
  _MyQRState createState() => _MyQRState();
}

class _MyQRState extends State<MyQR> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;
    double rect = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 25, right: 35, left: 35),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child: StreamBuilder<DocumentSnapshot>(
            stream: Global.appRef.userAppData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    TextsComboStack(text: snapshot.data.data()['userName']),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).sendedMessages,
                          style: kTextStyleWhiteBodyMedium.copyWith(
                              fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                        Text(
                          snapshot.data.data()['sendedMsg'].toString(),
                          style: kTextStyleWhiteBodyMediumCursiva,
                          textScaleFactor: 1.0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).recivedMessages,
                          style: kTextStyleWhiteBodyMedium.copyWith(
                              fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                        Text(
                          snapshot.data.data()['recivedMsgs'].toString(),
                          style: kTextStyleWhiteBodyMediumCursiva,
                          textScaleFactor: 1.0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).scannedQrs,
                          style: kTextStyleWhiteBodyMedium.copyWith(
                              fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                        Text(
                          snapshot.data.data()['qrScanned'].toString(),
                          style: kTextStyleWhiteBodyMediumCursiva,
                          textScaleFactor: 1.0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).nContacts,
                          style: kTextStyleWhiteBodyMedium.copyWith(
                              fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                        Text(
                          snapshot.data.data()['contacts'].length.toString(),
                          style: kTextStyleWhiteBodyMediumCursiva,
                          textScaleFactor: 1.0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).hideContacts,
                          style: kTextStyleWhiteBodyMedium.copyWith(
                              fontWeight: FontWeight.w600),
                          textScaleFactor: 1.0,
                        ),
                        Text(
                          snapshot.data
                              .data()['hideContacts']
                              .length
                              .toString(),
                          style: kTextStyleWhiteBodyMediumCursiva,
                          textScaleFactor: 1.0,
                        )
                      ],
                    ),
                  ],
                );
              } else {
                return SizedBox();
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () => Navigator.pop(context),
          child: CustomSurffixIcon(svgIcon: 'assets/icons/Back ICon.svg'),
        ),
      ),
    );
  }
}

class TextsComboStack extends StatelessWidget {
  const TextsComboStack({Key key, this.text}) : super(key: key);
  final text;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 1.0,
          textAlign: TextAlign.center,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 32.5, fontWeight: FontWeight.w600),
        ),
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 1.0,
          textAlign: TextAlign.center,
          style:
              kTextStyleBodyBig.copyWith(fontSize: 32.8, color: Colors.white),
        ),
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 1.0,
          textAlign: TextAlign.center,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 33.1, fontWeight: FontWeight.w600),
        ),
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 1.0,
          textAlign: TextAlign.center,
          style:
              kTextStyleBodyBig.copyWith(fontSize: 33.4, color: Colors.white),
        ),
        // Text(
        //   this.text,
        //   style: kTextStyleBodyBig.copyWith(
        //       fontSize: 34.5, fontWeight: FontWeight.w600),
        // ),
        // Text(
        //   this.text,
        //   style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        // ),
        // Text(
        //   this.text,
        //   style: kTextStyleBodyBig.copyWith(
        //       fontSize: 35, fontWeight: FontWeight.w600),
        // ),
        // Text(
        //   this.text,
        //   style:
        //       kTextStyleBodyBig.copyWith(fontSize: 35.5, color: Colors.white),
        // ),
      ],
    );
  }
}
