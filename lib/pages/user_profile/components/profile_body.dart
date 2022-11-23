import 'package:animations/animations.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:hide_talk/pages/legal/termsAndConditions.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/pages/user_profile/hideTalkInfo/HideTalkInfo.dart';
import 'package:hide_talk/pages/user_profile/myAccount/myAccount.dart';
import 'package:hide_talk/pages/user_profile/myAccount/settings/settings.dart';
import 'package:hide_talk/pages/user_profile/notifications/notifications_body.dart';
import 'package:hide_talk/pages/user_profile/plans/plans.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //! canviar el provider per el Global amb stream
    final auth = Provider.of(context).auth;
    final transitionType = ContainerTransitionType.fadeThrough;

    return Container(
      height: getProportionateScreenHeight(MediaQuery.of(context).size.height),
      width: MediaQuery.of(context).size.width,
      color: kSecondaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfilePic(),
          SizedBox(height: 25),
          // AvProfiles(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: OpenContainer(
                openColor: Colors.white,
                closedColor: kSecondaryColor,
                transitionType: transitionType,
                openElevation: 0.0,
                closedElevation: 0.0,
                closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                openShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                transitionDuration: Duration(seconds: 1),
                openBuilder: (context, _) => MyAccount(),
                closedBuilder: (context, openContainer) => ProfileMenu(
                    text: AppLocalizations.of(context).myAccount,
                    icon: "assets/icons/User Icon.svg",
                    press: openContainer),
              )),
          SizedBox(height: getProportionateScreenHeight(0.5)),

          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: OpenContainer(
                openColor: kSecondaryColor,
                closedColor: kSecondaryColor,
                transitionType: ContainerTransitionType.fadeThrough,
                openElevation: 0.0,
                closedElevation: 0.0,
                closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                openShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                transitionDuration: Duration(milliseconds: 600),
                openBuilder: (context, _) => NotificationsBody(),
                closedBuilder: (context, openContainer) => ProfileMenu(
                    text: AppLocalizations.of(context).notifications,
                    icon: "assets/icons/Bell.svg",
                    press: openContainer),
              )),
          SizedBox(height: getProportionateScreenHeight(0.5)),
          // Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //     child: OpenContainer(
          //       openColor: Colors.white,
          //       closedColor: kSecondaryColor,
          //       transitionType: transitionType,
          //       openElevation: 0.0,
          //       closedShape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(30.0))),
          //       openShape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(30.0))),
          //       transitionDuration: Duration(seconds: 1),
          //       openBuilder: (context, _) => MyAccount(),
          //       closedBuilder: (context, openContainer) => ProfileMenu(
          //           text: "Configuración",
          //           icon: "assets/icons/Settings.svg",
          //           press: openContainer),
          //     )),

          // SizedBox(height: getProportionateScreenHeight(0.5)),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: OpenContainer(
                openColor: Colors.white,
                closedColor: kSecondaryColor,
                transitionType: transitionType,
                openElevation: 0.0,
                closedElevation: 0.0,
                closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                openShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                transitionDuration: Duration(seconds: 1),
                openBuilder: (context, _) => HideTalkInfo(),
                closedBuilder: (context, openContainer) => ProfileMenu(
                    text: AppLocalizations.of(context).hideTalk,
                    icon: "assets/icons/Conversation.svg",
                    press: openContainer),
              )),
          SizedBox(height: getProportionateScreenHeight(10.5)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: ProfileMenu(
                text: AppLocalizations.of(context).logOut,
                icon: "assets/icons/Log out.svg",
                type: 0,
                press: () {}),
          ),
        ],
      ),
    );
  }
}
