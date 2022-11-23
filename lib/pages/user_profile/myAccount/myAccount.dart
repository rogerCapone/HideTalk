import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/pages/user_profile/components/profile_menu.dart';
import 'package:hide_talk/pages/user_profile/myAccount/myAccount.dart';
import 'package:hide_talk/pages/user_profile/myAccount/myQr/myQR.dart';
import 'package:hide_talk/pages/user_profile/myAccount/settings/security.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'myHashes/myHashes.dart';
import 'myInfo/myInfo.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;
    final transitionType = ContainerTransitionType.fadeThrough;
    String uid;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AvProfiles(),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: getProportionateScreenHeight(45),
                    width: getProportionateScreenHeight(45),
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
            SizedBox(height: getProportionateScreenHeight(50)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: OpenContainer(
                  openColor: Colors.white,
                  closedColor: kSecondaryColor,
                  transitionType: transitionType,
                  openElevation: 0.0,
                  closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  openShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  transitionDuration: Duration(seconds: 1),
                  openBuilder: (context, _) => MyInformation(),
                  closedBuilder: (context, openContainer) => ProfileMenu(
                      text: AppLocalizations.of(context).myInfo,
                      icon: "assets/icons/info.svg",
                      press: openContainer),
                )),
            SizedBox(height: getProportionateScreenHeight(0.5)),

            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: OpenContainer(
                  openColor: Colors.white,
                  closedColor: kSecondaryColor,
                  transitionType: transitionType,
                  openElevation: 0.0,
                  closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  openShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  transitionDuration: Duration(seconds: 1),
                  openBuilder: (context, _) => SecurityPage(),
                  closedBuilder: (context, openContainer) => ProfileMenu(
                      text: AppLocalizations.of(context).myContact,
                      icon: "assets/icons/guy.svg",
                      press: openContainer),
                )),
            SizedBox(height: getProportionateScreenHeight(0.5)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: OpenContainer(
                  openColor: Colors.white,
                  closedColor: kSecondaryColor,
                  transitionType: transitionType,
                  openElevation: 0.0,
                  closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  openShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  transitionDuration: Duration(seconds: 1),
                  openBuilder: (context, _) => MyQR(),
                  closedBuilder: (context, openContainer) => ProfileMenu(
                      text: AppLocalizations.of(context).myQr,
                      icon: "assets/icons/qr.svg",
                      press: openContainer),
                )),
            SizedBox(height: getProportionateScreenHeight(0.5)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: OpenContainer(
                  openColor: Colors.white,
                  closedColor: kSecondaryColor,
                  transitionType: transitionType,
                  openElevation: 0.0,
                  closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  openShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  transitionDuration: Duration(seconds: 1),
                  openBuilder: (context, _) => MyHashes(uid: uid),
                  closedBuilder: (context, openContainer) => ProfileMenu(
                      text: AppLocalizations.of(context).myHashes,
                      icon: "assets/icons/xoco.svg",
                      press: openContainer),
                )),

            SizedBox(height: getProportionateScreenHeight(65)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container(
                  height: getProportionateScreenHeight(60),
                  width: getProportionateScreenWidth(200),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: GestureDetector(
                    onTap: () async {
                      //! Abans fer que entri el pin
                      await auth.delelteAccount();
                      await auth.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red.withOpacity(0.75),
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).deleteAccount,
                          style: kTextStyleWhiteBodyMediumCursiva,
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
