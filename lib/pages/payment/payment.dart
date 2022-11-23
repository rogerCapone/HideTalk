import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/pages/payment/address.dart';
import 'package:hide_talk/widgets/month_anual_switch.dart';

import 'hideHash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool monthly = true;
  final List<double> doge = [100.0, 1000.0];
  final List<double> ltc = [0.005, 0.036];
  final List<double> btc = [0.000015, 0.00012];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 5,
            ),
            TextsComboStack(),
            SizedBox(
              height: 5,
            ),
            Text(
              AppLocalizations.of(context).choosePlan,
              style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                  fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
              textScaleFactor: 1.0,
            ),
            Text(
              AppLocalizations.of(context).rememberComissions,
              style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                  color: kPrimaryColor, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
              textScaleFactor: 0.75,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressPage(
                              coin: 'doge',
                              amount: doge[0],
                              subscription: 'monthly'))),
                  child: Container(
                    height: getProportionateScreenHeight(265),
                    width: getProportionateScreenWidth(160),
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10),
                        horizontal: getProportionateScreenWidth(15)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: kPrimaryGradientColor,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            AppLocalizations.of(context).packMonth,
                            textAlign: TextAlign.center,
                            textScaleFactor: 0.85,
                            style: kTextStyleBodyMedium.copyWith(
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            AppLocalizations.of(context).includes,
                            style: kTextStyleBodyMediumCursiva.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 14.5),
                            textScaleFactor: 0.75,
                          ),
                          SizedBox(
                            height: 8.5,
                          ),
                          Text(
                            '4 x 🍫 ' +
                                AppLocalizations.of(context).ofTwentyOneDays,
                            style: kTextStyleBodyMediumCursiva.copyWith(
                                fontSize: 14),
                            textScaleFactor: 0.8,
                          ),
                          Text(
                              '2 x 🍫 ' +
                                  AppLocalizations.of(context).ofThreeDays,
                              style: kTextStyleBodyMediumCursiva.copyWith(
                                  fontSize: 14),
                              textScaleFactor: 0.8),
                          SizedBox(height: 3.5),
                          SizedBox(
                            height: 8.5,
                          ),
                          Text(
                            '100.0 DOGE',
                            style: kTextStyleBodyMediumCursiva.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18.5),
                            textAlign: TextAlign.center,
                            textScaleFactor: 0.85,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressPage(
                              coin: 'doge',
                              amount: doge[1],
                              subscription: 'yearly'))),
                  child: Container(
                    height: getProportionateScreenHeight(265),
                    width: getProportionateScreenWidth(160),
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10),
                        horizontal: getProportionateScreenWidth(15)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: kPrimaryGradientColor,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            AppLocalizations.of(context).packYear,
                            textAlign: TextAlign.center,
                            textScaleFactor: 0.85,
                            style: kTextStyleBodyMedium.copyWith(
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            AppLocalizations.of(context).includes,
                            style: kTextStyleBodyMediumCursiva.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 14.5),
                            textScaleFactor: 0.75,
                          ),
                          SizedBox(
                            height: 8.5,
                          ),
                          Text(
                              '8 x 🍫 ' +
                                  AppLocalizations.of(context).ofTwentyOneDays,
                              style: kTextStyleBodyMediumCursiva.copyWith(
                                  fontSize: 14),
                              textScaleFactor: 0.8),
                          Text(
                              '4 x 🍫 ' +
                                  AppLocalizations.of(context).ofThreeDays,
                              style: kTextStyleBodyMediumCursiva.copyWith(
                                  fontSize: 14),
                              textScaleFactor: 0.8),
                          SizedBox(height: 3.5),
                          SizedBox(
                            height: 8.5,
                          ),
                          Text(
                            '1000.0 DOGE',
                            style: kTextStyleBodyMediumCursiva.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 18.5),
                            textAlign: TextAlign.center,
                            textScaleFactor: 0.85,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // MonthAnualSwitch(
            //   activeColor: Colors.orange,
            //   value: monthly,
            //   onChanged: (value) {
            //     print("VALUE : $value");
            //     setState(() {
            //       monthly = !monthly;
            //     });
            //   },
            // ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // GestureDetector(
                //   onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => AddressPage(
                //               coin: 'btc',
                //               amount: monthly ? btc[0] : btc[1],
                //               subscription: monthly ? 'monthly' : 'yearly'))),
                //   child: CoinShow(
                //       icon: 'assets/icons/btc.svg',
                //       main: false,
                //       amount: monthly ? btc[0] : btc[1],
                //       coinName: 'Bitcoin'),
                // ),
                GestureDetector(
                  child: CoinShow(
                      icon: 'assets/icons/doge.svg',
                      main: true,
                      // amount: monthly ? doge[0] : doge[1],
                      coinName: 'Doge'),
                ),
                // GestureDetector(
                //   onTap: () => Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => AddressPage(
                //               coin: 'ltc',
                //               amount: monthly ? ltc[0] : ltc[1],
                //               subscription: monthly ? 'monthly' : 'yearly'))),
                //   child: Container(
                //     child: CoinShow(
                //         icon: 'assets/icons/ltc.svg',
                //         main: false,
                //         amount: monthly ? ltc[0] : ltc[1],
                //         coinName: 'Litecoin'),
                //   ),
                // ),
              ],
            ),
            Text(
              AppLocalizations.of(context).paymentAgreement,
              style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                  fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
              textScaleFactor: 0.75,
            ),
            SizedBox(
              height: getProportionateScreenHeight(5),
            ),
          ],
        ),
      ),
    );
  }
}

class CoinShow extends StatelessWidget {
  final String icon;
  final bool main;
  final String coinName;
  final double amount;

  const CoinShow({Key key, this.icon, this.main, this.coinName, this.amount})
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
              // SizedBox(
              //   height: 8,
              // ),
              Container(
                height: getProportionateScreenWidth(80),
                width: getProportionateScreenWidth(80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  icon,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              // Row(
              //   children: [
              //     // Text(
              //     //   amount
              //     //       .toString(), //"Sign in with your email and password  \nor continue with social media",
              //     //   style: kTextStyleWhiteTitleBig.copyWith(
              //     //       fontWeight: FontWeight.w300),
              //     //   textAlign: TextAlign.center,
              //     //   textScaleFactor: 0.9,
              //     // ),
              //     Text(
              //       'DOGE', //"Sign in with your email and password  \nor continue with social media",
              //       style: kTextStyleWhiteBodyMedium.copyWith(
              //           fontWeight: FontWeight.w300),
              //       textAlign: TextAlign.center,
              //       textScaleFactor: 0.85,
              //     ),
              //   ],
              // ),
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
              // SizedBox(
              //   height: 8,
              // ),
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
              Text(
                amount
                    .toString(), //"Sign in with your email and password  \nor continue with social media",
                style: kTextStyleWhiteTitleBig.copyWith(
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
                textScaleFactor: 0.9,
              ),
              Text(
                coinName == 'Bitcoin'
                    ? ' BTC'
                    : ' LTC', //"Sign in with your email and password  \nor continue with social media",
                style: kTextStyleWhiteBodyMedium.copyWith(
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
                textScaleFactor: 0.85,
              ),
            ],
          );
  }
}

class TextsComboStack extends StatelessWidget {
  final index;

  const TextsComboStack({Key key, this.index}) : super(key: key);

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // Text(
        //   "Subscripción",
        //   textScaleFactor: 0.95,
        //   style: kTextStyleBodyBig.copyWith(
        //       fontSize: 32.5, fontWeight: FontWeight.w600),
        // ),
        Text(
          AppLocalizations.of(context).subscription,
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(fontSize: 33, color: Colors.white),
        ),
        // Text(
        //   "Subscripción",
        //   textScaleFactor: 0.95,
        //   style: kTextStyleBodyBig.copyWith(
        //       fontSize: 33.5, fontWeight: FontWeight.w600),
        // ),
        // Text(
        //   "Subscripción",
        //   textScaleFactor: 0.95,
        //   style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        // ),
        // Text(
        //   "Subscripción",
        //   textScaleFactor: 0.95,
        //   style: kTextStyleBodyBig.copyWith(
        //       fontSize: 34.5, fontWeight: FontWeight.w600),
        // ),
        // Text(
        //   "Subscripción",
        //   textScaleFactor: 0.95,
        //   style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        // ),
        // Text(
        //   "Subscripción",
        //   textScaleFactor: 0.95,
        //   style: kTextStyleBodyBig.copyWith(
        //       fontSize: 35, fontWeight: FontWeight.w600),
        // ),
        // Text(
        //   "Subscripción",
        //   textScaleFactor: 0.95,
        //   style:
        //       kTextStyleBodyBig.copyWith(fontSize: 35.5, color: Colors.white),
        // ),
      ],
    );
  }
}
