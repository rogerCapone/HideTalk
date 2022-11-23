import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hide_talk/pages/log/register/register_screen.dart';
import 'package:hide_talk/pages/log/setProfileData/completeProfile.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hide_talk/shared/size_config.dart';

class VerifyScreen extends StatefulWidget {
  VerifyScreen({Key key}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    //* Send user verification
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 3), (time) {
      checkEmailVerified();
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).verifyEmailSent,
              textScaleFactor: 0.95,
              style: kTextStyleWhiteBodyMedium,
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              user.email,
              textScaleFactor: 0.75,
              style: kTextStyleWhiteBodyMediumCursiva,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              AppLocalizations.of(context).visitMailForVerification,
              textScaleFactor: 0.75,
              style: kTextStyleWhiteBodyMedium,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              AppLocalizations.of(context).dontCloseAppSecondLayer,
              textScaleFactor: 0.75,
              style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                  color: kPrimaryColor),
            ),
            SizedBox(
              height: getProportionateScreenHeight(120),
            ),
            GestureDetector(
              onTap: () async {
                final auth = Provider.of(context).auth;
                final uid = await auth.getCurrentUID();
                // final rest = await DatabaseMethods().deleteAnAccount(uid: uid);
                // print(rest.toString());
                await auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                    gradient: kPrimaryGradientColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  AppLocalizations.of(context).iCantVerify,
                  textScaleFactor: 0.75,
                  style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;

    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CompleteProfileScreen()));
    }
  }
}
