import 'package:flutter/material.dart';
import 'package:hide_talk/pages/log/register/register_screen.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).dontHaveAccount,
          style: kTextStyleWhiteSmallLetter,
        ),
        GestureDetector(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen())),
          child: Text(AppLocalizations.of(context).register,
              textScaleFactor: 1.0,
              style: kTextStyleBodyMediumCursiva.copyWith(
                  fontWeight: FontWeight.w600, color: kPrimaryColor)),
        ),
      ],
    );
  }
}
