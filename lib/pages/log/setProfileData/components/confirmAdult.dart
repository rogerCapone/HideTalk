import 'package:flutter/material.dart';
import 'package:hide_talk/pages/log/register/register_screen.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hide_talk/widgets/animations/bottomTrans.dart';

import 'uploadPicture.dart';

class ConfirmAdultScreen extends StatelessWidget {
  const ConfirmAdultScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 12.5),
        color: kSecondaryColor,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            AppLocalizations.of(context).oldEnough,
            textScaleFactor: 1.0,
            style: kTextStyleWhiteBodyMediumCursiva,
          ),
          SizedBox(
            height: 55,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final auth = Provider.of(context).auth;
                  // await auth.delelteAccount();
                  await auth.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).no,
                      textScaleFactor: 0.8,
                      textAlign: TextAlign.center,
                      style: kTextStyleWhiteBodyMediumCursiva,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 45,
              ),
              GestureDetector(
                onTap: () async {
                  final uid = await Provider.of(context).auth.getCurrentUID();
                  await DatabaseMethods().oldEnough(uid: uid);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PictureUploadScreen()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryColor),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).yes,
                      textScaleFactor: 0.75,
                      textAlign: TextAlign.center,
                      style: kTextStyleBodyMedium,
                    ),
                  ),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
