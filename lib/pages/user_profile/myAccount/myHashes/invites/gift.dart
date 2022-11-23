import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/encryption.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';

import 'face2face.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GiftHash extends StatelessWidget {
  final String uid;
  final int subType;

  const GiftHash({Key key, this.uid, this.subType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
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
              ],
            ),
            Text(
              AppLocalizations.of(context).howToShareIt,
              textScaleFactor: 1.0,
              style: kTextStyleWhiteBodyMediumCursiva,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).gift,
                  textScaleFactor: 1.4,
                  style: kTextStyleWhiteBodyMediumCursiva,
                ),
                Text(
                  '🍫',
                  textScaleFactor: 1.4,
                  style: kTextStyleWhiteBodyMediumCursiva,
                ),
              ],
            ),
            Text(
              subType == 1
                  ? AppLocalizations.of(context).forOneMonth
                  : subType == 2
                      ? AppLocalizations.of(context).forTwoMonth
                      : ' x 1 AÑO',
              textScaleFactor: 1.25,
              style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Face2FaceHash(
                                subType: subType,
                              ))),
                  child: Container(
                    height: getProportionateScreenHeight(50),
                    width: getProportionateScreenWidth(150),
                    decoration: BoxDecoration(
                      gradient: kPrimaryGradientColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            AppLocalizations.of(context).faceToFace,
                            textScaleFactor: 1.005,
                            style: kTextStyleWhiteBodyMediumCursiva,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context).faceToFace,
                            textScaleFactor: 1.0,
                            style: kTextStyleBodyMediumCursiva,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Builder(
                    builder: (context) => GestureDetector(
                          onTap: () async {
                            final doc = await Global.appRef.getAppDataDoc();
                            if (doc.data() != null) {
                              var d3Po = doc.data()['inviteLink'] +
                                  '-|||-' +
                                  subType.toString();
                              final hideHash = MyEncryption.encryptFernet(d3Po);

                              Clipboard.setData(
                                      new ClipboardData(text: hideHash))
                                  .then((result) {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    AppLocalizations.of(context).sendInviteHash,
                                    style: kTextStyleSmallLetter.copyWith(),
                                    textAlign: TextAlign.center,
                                  ),
                                  // action: SnackBarAction(
                                  //   label: 'Undo',
                                  //   onPressed: () {},
                                  // ),
                                );
                                return Scaffold.of(context)
                                    .showSnackBar(snackBar);
                              });
                            } else {}
                          },
                          child: Container(
                            height: getProportionateScreenHeight(50),
                            width: getProportionateScreenWidth(150),
                            decoration: BoxDecoration(
                              gradient: kPrimaryGradientColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    AppLocalizations.of(context).withHashCode,
                                    textScaleFactor: 1.005,
                                    style: kTextStyleWhiteBodyMediumCursiva,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    AppLocalizations.of(context).withHashCode,
                                    textScaleFactor: 1.0,
                                    style: kTextStyleBodyMediumCursiva,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
              ],
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
