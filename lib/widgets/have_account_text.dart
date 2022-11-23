import 'package:flutter/material.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HaveAccountText extends StatelessWidget {
  const HaveAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).haveAnAccount,
          style: kTextStyleWhiteSmallLetter,
        ),
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())),
          child: Text(AppLocalizations.of(context).enter,
              textScaleFactor: 1.0,
              style: kTextStyleBodyMediumCursiva.copyWith(
                  fontWeight: FontWeight.w600, color: kPrimaryColor)),
        ),
      ],
    );
  }
}
