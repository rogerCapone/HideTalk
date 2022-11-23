import 'package:flutter/material.dart';
import 'package:hide_talk/pages/legal/privacyPolicy.dart';
import 'package:hide_talk/pages/legal/termsAndConditions.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';

import 'complete_profile_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).whatName,
                        style: kTextStyleWhiteTitleBig,
                        textScaleFactor: 1.0,
                      ),
                      SizedBox(height: getProportionateScreenHeight(15)),
                      Text(
                        AppLocalizations.of(context).whatNameInfo,
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.06),
                      CompleteProfileForm(),
                      SizedBox(height: getProportionateScreenHeight(30)),
                      SizedBox(height: getProportionateScreenHeight(24)),
                      Text(AppLocalizations.of(context).startAccept,
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: kTextStyleWhiteSmallLetter.copyWith(
                              fontWeight: FontWeight.w200)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TermsAndConditions())),
                                child: Text(
                                  AppLocalizations.of(context).termsAndCo,
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
                                  style: kTextStyleWhiteSmallLetter.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                )),
                            Text(
                              AppLocalizations.of(context).and,
                              textAlign: TextAlign.center,
                              style: kTextStyleWhiteSmallLetter,
                              textScaleFactor: 1.0,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PrivacyPolicy())),
                              child: Text(
                                  AppLocalizations.of(context).privacyPolicy,
                                  textScaleFactor: 1.0,
                                  textAlign: TextAlign.center,
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
          ),
        ),
      ),
    );
  }
}
