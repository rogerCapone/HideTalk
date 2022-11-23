import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/pages/pinPage/setUpPin.dart';
import 'package:hide_talk/pages/user_profile/components/profile_menu.dart';
import 'package:hide_talk/pages/user_profile/myAccount/myAccount.dart';
import 'package:hide_talk/pages/user_profile/myAccount/myQr/myQR.dart';
import 'package:hide_talk/pages/user_profile/myAccount/settings/changePin/changePin.dart';
import 'package:hide_talk/pages/user_profile/myAccount/settings/security.dart';
import 'package:hide_talk/pages/user_profile/myAccount/settings/userName/updateUserName.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';

import 'userName/updateUserName.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;
    final transitionType = ContainerTransitionType.fadeThrough;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // AvProfiles(),
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
                  openBuilder: (context, _) => UpdateUserName(),
                  closedBuilder: (context, openContainer) => ProfileMenu(
                      text: AppLocalizations.of(context).changeUserName,
                      icon: "assets/icons/User.svg",
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
                  openBuilder: (context, _) => ChangePin(),
                  closedBuilder: (context, openContainer) => ProfileMenu(
                      text: AppLocalizations.of(context).changePin,
                      icon: "assets/icons/pin.svg",
                      press: openContainer),
                )),
            SizedBox(height: getProportionateScreenHeight(0.5)),
          ],
        ),
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
