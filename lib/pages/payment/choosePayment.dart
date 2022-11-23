import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/pages/payment/payment.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/locale_provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:provider/provider.dart';

import '../components.dart';
import 'fiatSubscription.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'hideHash.dart';

class ChoosePayment extends StatefulWidget {
  final uid;

  const ChoosePayment({Key key, this.uid}) : super(key: key);
  @override
  _ChoosePaymentState createState() => _ChoosePaymentState();
}

class _ChoosePaymentState extends State<ChoosePayment> {
  // Future<void> initPlatformState() async {
  //   appData.isClient = false;

  //   await Purchases.setDebugLogsEnabled(true);
  //   await Purchases.setup("doxpeiDcIgiuqCMFQJjWAFwxJsTSrqbJ",
  //       appUserId: widget.uid);

  //   PurchaserInfo purchaserInfo;
  //   try {
  //     purchaserInfo = await Purchases.getPurchaserInfo();
  //     print(purchaserInfo.toString());
  //     if (purchaserInfo.entitlements.all['all_features'] != null) {
  //       appData.isClient =
  //           purchaserInfo.entitlements.all['all_features'].isActive;
  //       //!if is client --> appMenu !!
  //     } else {
  //       appData.isClient = false;
  //     }
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   print(appData.isClient.toString());
  //   print('#### is user client? ${appData.isClient}');
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;
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
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: kSecondaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 2.5,
              ),
              Text(
                AppLocalizations.of(context).subscription,
                textScaleFactor: 0.95,
                style: kTextStyleBodyBig.copyWith(
                    fontSize: 33, color: Colors.white),
              ),
              SizedBox(
                height: getProportionateScreenHeight(5),
              ),
              Text(
                AppLocalizations.of(context).selectPaymentMethod,
                style: kTextStyleWhiteBodyMediumCursiva,
              ),
              SizedBox(
                height: getProportionateScreenHeight(3),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Platform.isIOS
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FiatSubscripton()))
                              // }
                              ,
                              child: CoinShow(
                                coinName: 'EUR/USD',
                                icon: 'assets/icons/credit-card.svg',
                                main: true,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FiatSubscripton()))
                              // }
                              ,
                              child: CoinShow(
                                coinName: 'EUR/USD',
                                icon: 'assets/icons/credit-card.svg',
                                main: true,
                              ),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(35),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentPage())),
                              child: CoinShow(
                                coinName: 'CRYPTO',
                                main: true,
                                icon: 'assets/icons/wallet.svg',
                              ),
                            ),
                          ],
                        )),
              SizedBox(
                height: getProportionateScreenHeight(4.5),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HideHash()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).haveHideHash,
                      style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.0,
                    ),
                    Text(
                      "🍫",
                      style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              GestureDetector(
                onTap: () {
                  if (locale.toString() == 'en') {
                    print('LOCALE IS IN ${locale.toString()}');
                    print('Converting to ESPA');
                    provider.setLocale(Locale('es'));
                  } else {
                    provider.setLocale(Locale('en'));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(30),
                      gradient: kPrimaryGradientColor),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                  child: Text(
                    AppLocalizations.of(context).changeLanguage,
                    style: kTextStyleBodyMediumCursiva,
                  ),
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(35),
              ),
              SizedBox(
                width: getProportionateScreenWidth(35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoinShow extends StatelessWidget {
  final String icon;
  final bool main;
  final String coinName;

  const CoinShow({Key key, this.icon, this.main, this.coinName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return main
        ? Column(
            children: [
              // Text(
              //   coinName, //"Sign in with your email and password  \nor continue with social media",
              //   style: kTextStyleWhiteBodyMedium.copyWith(
              //       fontWeight: FontWeight.w300),
              //   textAlign: TextAlign.center,
              //   textScaleFactor: 1.0,
              // ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: getProportionateScreenWidth(150),
                width: getProportionateScreenWidth(150),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: kPrimaryGradientColor,
                ),
                child: Container(
                  height: getProportionateScreenWidth(80),
                  width: getProportionateScreenWidth(80),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: coinName != 'CRYPTO'
                      ? SvgPicture.asset(
                          icon,
                          fit: BoxFit.contain,
                        )
                      : Image(
                          image: AssetImage('assets/images/walletDoge.png')),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  // Text(
                  //   amount
                  //       .toString(), //"Sign in with your email and password  \nor continue with social media",
                  //   style: kTextStyleWhiteTitleBig.copyWith(
                  //       fontWeight: FontWeight.w300),
                  //   textAlign: TextAlign.center,
                  //   textScaleFactor: 0.9,
                  // ),
                  Text(
                    coinName, //"Sign in with your email and password  \nor continue with social media",
                    style: kTextStyleWhiteBodyMedium.copyWith(
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                    textScaleFactor: 0.85,
                  ),
                ],
              ),
            ],
          )
        : Column(
            children: [
              // Text(
              //   coinName, //"Sign in with your email and password  \nor continue with social media",
              //   style: kTextStyleWhiteBodyMedium.copyWith(
              //       fontWeight: FontWeight.w300),
              //   textAlign: TextAlign.center,
              //   textScaleFactor: 1.0,
              // ),
              SizedBox(
                height: 8,
              ),
              Container(
                height: getProportionateScreenWidth(90),
                width: getProportionateScreenWidth(90),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: kPrimaryGradientColor,
                ),
                child: Container(
                  height: getProportionateScreenWidth(100),
                  width: getProportionateScreenWidth(100),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    icon,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              // Text(
              //   amount
              //       .toString(), //"Sign in with your email and password  \nor continue with social media",
              //   style: kTextStyleWhiteTitleBig.copyWith(
              //       fontWeight: FontWeight.w300),
              //   textAlign: TextAlign.center,
              //   textScaleFactor: 0.9,
              // ),
              Text(
                coinName == 'USD'
                    ? ' USD'
                    : ' EUR', //"Sign in with your email and password  \nor continue with social media",
                style: kTextStyleWhiteBodyMedium.copyWith(
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
                textScaleFactor: 0.85,
              ),
            ],
          );
  }
}
