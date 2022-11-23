import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/pages/legal/privacyPolicy.dart';
import 'package:hide_talk/pages/legal/termsAndConditions.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
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
import 'package:hide_talk/widgets/social_card.dart';
import 'package:hide_talk/widgets/have_account_text.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'a_signUp_form.dart';
import 'dart:io';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;
    return Container(
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
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      '🎈',
                      style: headingStyle,
                      textScaleFactor: 1.0,
                    ),
                    Text(
                      AppLocalizations.of(context).createAccount,
                      style: kTextStyleWhiteTitleBig,
                      textScaleFactor: 1.0,
                    ),
                    Text(
                      '🎈',
                      style: headingStyle,
                      textScaleFactor: 1.0,
                    ),
                  ]),
                  Text(
                    // '',
                    AppLocalizations.of(context).createAccountSubInfo,
                    style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                        fontWeight: FontWeight.w300),
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  HaveAccountText(),
                  SizedBox(height: 15),
                  SignUpForm(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            //! EVALUAR -> Already registered

                            var result = await auth.googleSignIn();
                            // final mail = result.email;

                            if (result != null) {
                              final uid = result.uid;

                              final subResult = await DatabaseMethods()
                                  .checkSubscription(
                                      uid: uid, today: DateTime.now());
                              if (subResult == true) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuApp()));
                              } else {
                                final String stage = await DatabaseMethods()
                                    .userRegisterStage(uid: uid);
                                print('\N\N\N\N');
                                print('\N\N\N\N');
                                print('\N\N\N\N');
                                print('\N\N\N\N');
                                print(stage);
                                print(stage);
                                print(stage);
                                print('\N\N\N\N');
                                print('\N\N\N\N');
                                if (stage == 'allDone') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PinPage()));
                                } else if (stage == 'userName' ||
                                    stage == 'complete') {
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
                                } else if (stage == 'pin') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SetPersonalPin()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChoosePayment()));
                                }
                                print('NPTHING WAS SELECTED... SHIT');
                                // // print('\nregistered INSTANCE \n');
                                // // final bool resgistered = await DatabaseMethods()
                                // //     .isEmailRegistered(email: mail);

                                // // print('\nregistered INSTANCE \n');
                                // // print('\n$resgistered \n');
                                // // if (resgistered == false) {
                                // return Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             CompleteProfileScreen()));
                                // // } else {
                                // //   //!Procediment de login
                                // //   //? Google Login
                                // //   // setState(() {
                                // //   print('Should Consider Login Procedure');
                                // //   return Navigator.push(
                                // //       context,
                                // //       MaterialPageRoute(
                                // //           builder: (context) => LoginScreen()));
                                // //   //   // emailInUse = true;
                                // //   // });
                                // // }

                                // // Navigator.pushReplacement(
                                // //     context,
                                // //     MaterialPageRoute(
                                // //         builder: (context) =>
                                // //             ()));
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor.withOpacity(0.8)),
                            child: SocialCard(
                              google: true,
                              icon: "assets/icons/google-icon.svg",
                            ),
                          )),
                      // AppleSignInButton(),
                      Platform.isIOS
                          ? GestureDetector(
                              onTap: () async {
                                // print(Scope.email.value);
                                // print(Scope.fullName.value);
                                //! EVALUAR -> Already registered

                                var result = await auth.signInWithApple(
                                    scopes: [Scope.email, Scope.fullName]);

                                if (result != null) {
                                  // print('\nregistered INSTANCE \n');
                                  // final bool resgistered = await DatabaseMethods()
                                  //     .isEmailRegistered(email: result.email);
                                  // print('\n$resgistered \n');

                                  // if (resgistered == false) {
                                  return Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CompleteProfileScreen()));
                                  // } else {
                                  //   //!Procediment de login
                                  //   //? Google Login
                                  //   // setState(() {
                                  //   print('Should Consider Login Procedure');
                                  //   return Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => LoginScreen()));
                                  //   //   // emailInUse = true;
                                  //   // });
                                  // }

                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ()));
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPrimaryColor.withOpacity(0.8)),
                                child: SocialCard(
                                  google: false,
                                  icon: "assets/icons/apple.svg",
                                ),
                              ))
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(24)),
                  Text(
                    AppLocalizations.of(context).startAccept,
                    textAlign: TextAlign.center,
                    style: kTextStyleWhiteSmallLetter.copyWith(
                        fontWeight: FontWeight.w200),
                    textScaleFactor: 1.0,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditions())),
                        child: Text(
                          AppLocalizations.of(context).termsAndCo,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: kTextStyleWhiteSmallLetter.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        )),
                    Text(
                      AppLocalizations.of(context).and,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.0,
                      style: kTextStyleWhiteSmallLetter,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicy())),
                      child: Text(AppLocalizations.of(context).privacyPolicy,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: kTextStyleWhiteSmallLetter.copyWith(
                            decoration: TextDecoration.underline,
                          )),
                    )
                  ])
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
