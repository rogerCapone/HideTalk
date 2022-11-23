import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/services/encryption.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Face2FaceHash extends StatelessWidget {
  final int subType;

  const Face2FaceHash({Key key, this.subType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox(
            height: 5,
          ),
          Row(
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
                      child: SvgPicture.asset(
                    'assets/icons/Back ICon.svg',
                    color: Colors.white,
                  )),
                ),
              ),
              TextsComboStack(text: AppLocalizations.of(context).share),
              SizedBox(
                width: getProportionateScreenHeight(40),
              )
            ],
          ),
          Text(
            AppLocalizations.of(context).inviteIncludes,
            style: kTextStyleWhiteBodyMedium,
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
          ),
          Text(
            subType == 1
                ? AppLocalizations.of(context).oneMonthHash
                : subType == 2
                    ? AppLocalizations.of(context).twoMonthHash
                    : '🍫 x 1 AÑO',
            textScaleFactor: 1.4,
            style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          FutureBuilder<DocumentSnapshot>(
              future: Global.appRef.getAppDataDoc(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var d3Po = snapshot.data.data()['inviteLink'] +
                      '-|||-' +
                      subType.toString();
                  final hideHash = MyEncryption.encryptFernet(d3Po);
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    height: getProportionateScreenHeight(355),
                    width: getProportionateScreenWidth(355),
                    child: PrettyQr(
                        elementColor: Colors.white,
                        typeNumber: 10,
                        size: 250,
                        data: hideHash,
                        roundEdges: true),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          SizedBox(
            height: 2.5,
          ),
          Text(
            AppLocalizations.of(context).showQRinPaymentPage,
            style: kTextStyleWhiteBodyMedium,
            textAlign: TextAlign.center,
            textScaleFactor: 0.9,
          ),
          Text(
            AppLocalizations.of(context).hasHash,
            style: kTextStyleWhiteBodyMediumCursiva,
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
          ),
        ]),
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
        Text(
          this.text,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 34.5, fontWeight: FontWeight.w600),
        ),
        Text(
          this.text,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
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
