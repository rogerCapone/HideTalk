import 'package:apple_sign_in/scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/pages/log/setProfileData/completeProfile.dart';
import 'package:hide_talk/pages/log/setProfileData/components/confirmAdult.dart';
import 'package:hide_talk/pages/log/setProfileData/components/uploadPicture.dart';
import 'package:hide_talk/pages/payment/choosePayment.dart';
import 'package:hide_talk/pages/pinPage/pinPage.dart';
import 'package:hide_talk/pages/pinPage/setUpPin.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/no_account_text.dart';
import 'package:hide_talk/widgets/social_card.dart';
import 'a_sign_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;

    return WillPopScope(
      onWillPop: () async {
        return CoolAlert.show(
          context: context,
          type: CoolAlertType.confirm,
          text: AppLocalizations.of(context).sureExit,
          confirmBtnText: AppLocalizations.of(context).no,
          cancelBtnText: AppLocalizations.of(context).yes,
          confirmBtnColor: kPrimaryColor,
          backgroundColor: kPrimaryColor.withOpacity(0.85),
          showCancelBtn: true,
          onConfirmBtnTap: () {
            Navigator.pop(context);
          },
          onCancelBtnTap: () {
            SystemNavigator.pop();
          },
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child: SafeArea(
            child: Center(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04),
                    Text(
                      AppLocalizations.of(context).welcome,
                      style: kTextStyleWhiteTitleBig,
                      textScaleFactor: 1.0,
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Text(
                      AppLocalizations.of(context).loginMailOrGoogle,
                      style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.0,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.08),
                    SignForm(),
                    SizedBox(height: SizeConfig.screenHeight * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryColor.withOpacity(0.8)),
                          child: SocialCard(
                            google: true,
                            icon: "assets/icons/google-icon.svg",
                            press: () async {
                              var result = await auth.googleSignIn();
                              final uid = result.uid;
                              final subResult = await DatabaseMethods()
                                  .checkSubscription(
                                      uid: uid, today: DateTime.now());
                              if (subResult == true) {
                                return Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuApp()),
                                    (Route<dynamic> route) => false);
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => MenuApp()));
                              } else {
                                final String stage = await DatabaseMethods()
                                    .userRegisterStage(uid: uid);
                                print(stage);
                                if (stage == 'allDone') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PinPage()));
                                } else if (stage == 'userName') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CompleteProfileScreen()));
                                } else if (stage == 'oldEnough') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ConfirmAdultScreen()));
                                } else if (stage == 'photoUrl') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PictureUploadScreen()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SetPersonalPin()));
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChoosePayment()));
                              }
                            },
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(25)),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryColor.withOpacity(0.8)),
                          child: SocialCard(
                            google: false,
                            icon: "assets/icons/apple.svg",
                            press: () async {
                              print(Scope.email);
                              print(Scope.fullName);
                              var result = await auth.signInWithApple(
                                  scopes: [Scope.email, Scope.fullName]);
                              final uid = result.uid;
                              final subResult = await DatabaseMethods()
                                  .checkSubscription(
                                      uid: uid, today: DateTime.now());
                              if (subResult == true) {
                                return Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuApp()),
                                    (Route<dynamic> route) => false);

                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => MenuApp()));
                              } else {
                                final String stage = await DatabaseMethods()
                                    .userRegisterStage(uid: uid);
                                print(stage);
                                if (stage == 'allDone') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PinPage()));
                                } else if (stage == 'userName') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CompleteProfileScreen()));
                                } else if (stage == 'oldEnough') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ConfirmAdultScreen()));
                                } else if (stage == 'photoUrl') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PictureUploadScreen()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SetPersonalPin()));
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChoosePayment()));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    NoAccountText(),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
