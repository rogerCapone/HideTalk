import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({Key key, this.text, this.text1, this.image, this.index})
      : super(key: key);
  final String text, text1, image;
  final int index;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(25)),
            child: Text(
              text,
              textScaleFactor: 0.85,
              textAlign: TextAlign.center,
              style: kTextStyleWhiteBodyMedium,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(25)),
            child: Text(
              text1,
              textScaleFactor: 0.65,
              textAlign: TextAlign.center,
              style: kTextStyleWhiteBodyMediumCursiva,
            ),
          ),
          Container(
            height: getProportionateScreenHeight(400),
            width: getProportionateScreenWidth(400),
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(
                image,
              ),
            )),
          )
        ],
      ),
    );
  }
}
