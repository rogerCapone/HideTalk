import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/pages/contacts/contacts_body.dart';
import 'package:hide_talk/pages/legal/privacyPolicy.dart';
import 'package:hide_talk/pages/legal/termsAndConditions.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/pages/user_profile/myAccount/myHashes/invites/gift.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHashes extends StatefulWidget {
  final String uid;

  const MyHashes({Key key, this.uid}) : super(key: key);
  @override
  _MyHashesState createState() => _MyHashesState();
}

class _MyHashesState extends State<MyHashes> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;
    double rect = MediaQuery.of(context).size.width;
    final n_invites1Month = 50;
    final n_invites3Month = 15;
    final n_invitesYear = 5;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 25, right: 35, left: 35),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child: FutureBuilder<DocumentSnapshot>(
            future: DatabaseMethods()
                .getHashes(auth: auth), //DatabaseMethods.getHashes(uid: uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 10,
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
                          SizedBox(
                            width: 5,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                              future: Global.appRef.getAppDataDoc(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return TextsComboStack(
                                      text: snapshot.data.data()['userName']);
                                } else {
                                  return CircularProgressIndicator();
                                }
                              }),
                          SizedBox(
                            width: getProportionateScreenHeight(40),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).oneMonthHash,
                            style: kTextStyleWhiteBodyMedium.copyWith(
                                fontWeight: FontWeight.w600),
                            textScaleFactor: 1.0,
                          ),
                          Text(
                            snapshot.data.data()['invites1Month'].toString() +
                                ' / ' +
                                snapshot.data
                                    .data()['offered1Month']
                                    .toString(),
                            style: kTextStyleWhiteBodyMediumCursiva,
                            textScaleFactor: 1.0,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5.5,
                      ),
                      snapshot.data.data()['invites1Month'] != 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: 50,
                                    width: getProportionateScreenWidth(300) *
                                        (snapshot.data.data()['invites1Month'] /
                                            snapshot.data
                                                .data()['offered1Month']),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.orange),
                                    child: Center(
                                      child: Text(
                                          (snapshot.data.data()[
                                                          'invites1Month'] /
                                                      snapshot.data.data()[
                                                          'offered1Month'] *
                                                      100)
                                                  .toStringAsFixed(2) +
                                              ' %',
                                          style: kTextStyleBodyMediumCursiva,
                                          textScaleFactor: 0.65),
                                    )),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).twoMonthHash,
                            style: kTextStyleWhiteBodyMedium.copyWith(
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            snapshot.data.data()['invites3Month'].toString() +
                                ' / ' +
                                snapshot.data
                                    .data()['offered3Month']
                                    .toString(),
                            style: kTextStyleWhiteBodyMediumCursiva,
                            textScaleFactor: 1.0,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5.5,
                      ),
                      snapshot.data.data()['invites3Month'] != 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    height: 50,
                                    width: getProportionateScreenWidth(300) *
                                        (snapshot.data.data()['invites3Month'] /
                                            snapshot.data
                                                .data()['offered3Month']),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.orange),
                                    child: Center(
                                      child: Text(
                                          (snapshot.data.data()[
                                                          'invites3Month'] /
                                                      snapshot.data.data()[
                                                          'offered3Month'] *
                                                      100)
                                                  .toStringAsFixed(2) +
                                              ' %',
                                          style: kTextStyleBodyMediumCursiva,
                                          textScaleFactor: 0.65),
                                    )),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 18,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       '🍫 x 1 MES:  ',
                      //       style: kTextStyleWhiteBodyMedium.copyWith(
                      //           fontWeight: FontWeight.w600),
                      //       textScaleFactor: 1.0,
                      //     ),
                      //     Text(
                      //       snapshot.data.data()['invites1Month'].toString() +
                      //           ' / $n_invites1Month.',
                      //       style: kTextStyleWhiteBodyMediumCursiva,
                      //       textScaleFactor: 1.0,
                      //     )
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 18,
                      // ),
                      // Container(
                      //     height: 50,
                      //     width: getProportionateScreenWidth(300) *
                      //         (snapshot.data.data()['invites1Month'] /
                      //             n_invites1Month),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30),
                      //         color: Colors.orange),
                      //     child: Center(
                      //       child: Text(
                      //           (snapshot.data.data()['invites1Month'] /
                      //                       n_invites1Month *
                      //                       100)
                      //                   .toStringAsFixed(2) +
                      //               ' %',
                      //           style: kTextStyleBodyMediumCursiva),
                      //     )),
                      SizedBox(
                        height: 45,
                      ),
                      //TODO: Regalar subs
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (snapshot.data.data()['invites1Month'] > 0) {
                                final uid = await Provider.of(context)
                                    .auth
                                    .getCurrentUID();
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GiftHash(uid: uid, subType: 1)));
                                if (result == true) {
                                  setState(() {});
                                }
                              } else {}
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: getProportionateScreenHeight(40),
                              width: getProportionateScreenWidth(185),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      snapshot.data.data()['invites1Month'] > 0
                                          ? Colors.white.withOpacity(0.3)
                                          : kSecondaryColor,
                                  gradient:
                                      snapshot.data.data()['invites1Month'] > 0
                                          ? kPrimaryGradientColor
                                          : null),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).giftOneMonth,
                                  style: kTextStyleWhiteBodyMedium.copyWith(
                                      fontWeight: FontWeight.w600),
                                  textScaleFactor: 0.75,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).stillHave +
                                snapshot.data
                                    .data()['invites1Month']
                                    .toString(),
                            style: kTextStyleWhiteSmallLetter,
                            textScaleFactor: 1.0,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (snapshot.data.data()['invites3Month'] > 0) {
                                final uid = await Provider.of(context)
                                    .auth
                                    .getCurrentUID();
                                var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GiftHash(uid: uid, subType: 2)));
                                if (result == true) {
                                  setState(() {});
                                }
                              } else {}
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: getProportionateScreenHeight(40),
                              width: getProportionateScreenWidth(185),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      snapshot.data.data()['invites3Month'] > 0
                                          ? Colors.white.withOpacity(0.3)
                                          : kSecondaryColor,
                                  gradient:
                                      snapshot.data.data()['invites3Month'] > 0
                                          ? kPrimaryGradientColor
                                          : null),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).giftTwoMonth,
                                  style: kTextStyleWhiteBodyMedium.copyWith(
                                      fontWeight: FontWeight.w600),
                                  textScaleFactor: 0.75,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).stillHave +
                                snapshot.data
                                    .data()['invites3Month']
                                    .toString(),
                            style: kTextStyleWhiteSmallLetter,
                            textScaleFactor: 1.0,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () async {
                      //         final uid =
                      //             await Provider.of(context).auth.getCurrentUID();
                      //         var result = await Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     GiftHash(uid: uid, subType: 3)));
                      //         if (result == true) {
                      //           setState(() {});
                      //         }
                      //       },
                      //       child: Container(
                      //         padding: EdgeInsets.symmetric(horizontal: 10),
                      //         height: getProportionateScreenHeight(40),
                      //         width: getProportionateScreenWidth(185),
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20),
                      //             color: Colors.white.withOpacity(0.3),
                      //             gradient: kPrimaryGradientColor),
                      //         child: Center(
                      //           child: Text(
                      //             'Regala 🍫 x 1 AÑO:  ',
                      //             style: kTextStyleWhiteBodyMedium.copyWith(
                      //                 fontWeight: FontWeight.w600),
                      //             textScaleFactor: 0.8,
                      //             textAlign: TextAlign.center,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Text(
                      //       'Aun te quedan: ' +
                      //           snapshot.data.data()['invitesYear'].toString(),
                      //       style: kTextStyleWhiteSmallLetter,
                      //       textScaleFactor: 1.0,
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      // floatingActionButton: Container(
      //   margin: EdgeInsets.symmetric(vertical: 20),
      //   child: FloatingActionButton(
      //     onPressed: () => Navigator.pop(context),
      //     backgroundColor: kSecondaryColor,
      //     child: CustomSurffixIcon(
      //       svgIcon: 'assets/icons/Back ICon.svg',
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
    );
  }
}

class TextsComboStack extends StatelessWidget {
  const TextsComboStack({Key key, this.text}) : super(key: key);
  final text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(200),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Text(
          //   this.text,
          //   overflow: TextOverflow.ellipsis,
          //   textScaleFactor: 1.0,
          //   textAlign: TextAlign.center,
          //   style: kTextStyleBodyBig.copyWith(
          //       fontSize: 32.5, fontWeight: FontWeight.w600),
          // ),
          // Text(
          //   this.text,
          //   overflow: TextOverflow.ellipsis,
          //   textScaleFactor: 1.0,
          //   textAlign: TextAlign.center,
          //   style:
          //       kTextStyleBodyBig.copyWith(fontSize: 32.8, color: Colors.white),
          // ),
          // Text(
          //   this.text,
          //   overflow: TextOverflow.ellipsis,
          //   textScaleFactor: 1.0,
          //   textAlign: TextAlign.center,
          //   style: kTextStyleBodyBig.copyWith(
          //       fontSize: 33.1, fontWeight: FontWeight.w600),
          // ),
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
      ),
    );
  }
}
