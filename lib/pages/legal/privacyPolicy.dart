import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              AppLocalizations.of(context).privacyPolicy,
              style: kTextStyleTitleBig,
              textScaleFactor: 0.9,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.0,
            ),
            FutureBuilder<DocumentSnapshot>(
                future: DatabaseMethods().getLegalPrivacy(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.data()['allText'],
                      style: kTextStyleBodyMedium,
                      textScaleFactor: 0.9,
                      textAlign: TextAlign.justify,
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.orange,
                      strokeWidth: 0.4,
                    ));
                    ;
                  }
                })
          ])),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent.withOpacity(0.15),
          onPressed: () => Navigator.pop(context),
          child: CustomSurffixIcon(svgIcon: 'assets/icons/Back ICon.svg'),
        ),
      ),
    );
  }
}
