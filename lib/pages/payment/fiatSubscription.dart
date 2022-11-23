import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FiatSubscripton extends StatefulWidget {
  FiatSubscripton({Key key}) : super(key: key);

  @override
  _FiatSubscriptonState createState() => _FiatSubscriptonState();
}

class _FiatSubscriptonState extends State<FiatSubscripton> {
  //!Es one time ever payment --> regular subscription

  // final List<String> iapId = ['com.n3d.monthly', 'com.n3d.year'];
  // final iapId = 'android.test.purchased';
  final month = 'monthly';
  final year = 'year';
  List<IAPItem> _items = [];
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  String _prod;
  String _id;
  String _pageState = 'non';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void dispose() async {
    super.dispose();
    // _purchaseUpdatedSubscription.cancel();
    // _purchaseUpdatedSubscription = null;
    // _purchaseErrorSubscription.cancel();
    // _purchaseErrorSubscription = null;
    cancelSubs();
    await FlutterInappPurchase.instance.endConnection;
  }

  void cancelSubs() {
    _purchaseUpdatedSubscription.cancel();
    _purchaseErrorSubscription.cancel();
  }

  Future<void> payCheck(dynamic data) async {
    try {
      setState(() {
        _pageState = 'loading';
      });
      final uid = await Provider.of(context).auth.getCurrentUID();
      print(_id);
      final result = await DatabaseMethods().checkFiatPay(
        uid: uid,
        data: data,
        prod: _prod,
      );
      print(result.toString());
      if (result) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MenuApp()),
            (Route<dynamic> route) => false);
      } else {
        //!ALERT DIALOG
        CoolAlert.show(context: context, type: CoolAlertType.error);
        setState(() {
          _pageState = 'non';
        });
      }
    } catch (e) {
      print(e.toString());
      CoolAlert.show(context: context, type: CoolAlertType.error);
      setState(() {
        _pageState = 'non';
      });
    }
  }

  Future<void> initPlatformState() async {
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: ' + result.toString());
    if (!mounted) return;

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      // print('\n\n');
      // print(productItem.purchaseStateAndroid);
      // print(productItem.purchaseStateAndroid);
      // print(productItem.purchaseStateAndroid);
      // print('\n\n');
      // var data = productItem.purchaseStateAndroid;
      // print(data);
      // print(data);
      // print(data);
      await payCheck(productItem.purchaseStateAndroid);
      // print('purchase-updated: $productItem');

      //! CF TO VALIDATE THE INDEX --> GENERATE FACTURA --> RETURN STATE OR BOOL TO ALLOW USER PASS
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
    // String msg = await FlutterInappPurchase.instance.consumeAllItems;
    // print('consumeAllItems: ' + msg);
    await _getProduct();

    // print('SHIT');
  }

  Future<Null> _getProduct() async {
    List<String> platformProds = [month, year];
    //ios year --> 1557030474 // monthly --> 1557030176
    List<IAPItem> items;
    // if (Platform.isAndroid) {

    items = await FlutterInappPurchase.instance.getProducts(platformProds);
    // } else {
    // items = await FlutterInappPurchase.instance
    //     .getAppStoreInitiatedProducts(); // Get list of products

    // }
    print(items.toString());

    items.forEach((element) {
      print(element.toString());
    });

    // for (var item in items) {
    //   print('${item.toString()}');
    //   this._items.add(item);
    // }
    // print(items.toString());
    // for (var item in items) {
    //   print(item.toString());
    //   this._items.add(item);
    // }
    setState(() {
      this._items = items;
    });
  }

  Future<void> _buyProduct(IAPItem item) async {
    try {
      await FlutterInappPurchase.instance.requestPurchase(item.productId);
    } catch (e) {
      print(e.toString());
    }
  }

  List<Widget> _showProducts() {
    List<Widget> widgets = this
        ._items
        .map(
          (item) => GestureDetector(
            onTap: () async {
              setState(() {
                // print('this is plan:  ');
                // print(_id.toString());
                _id = item.productId;
                _prod =
                    item.productId + '||' + item.price + '||' + item.currency;
              });
              await _buyProduct(item);
            },
            child: Container(
              height: getProportionateScreenHeight(245),
              width: getProportionateScreenWidth(180),
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
                      item.productId == 'monthly'
                          ? AppLocalizations.of(context).packMonth
                          : AppLocalizations.of(context).packYear,
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
                    ),
                    SizedBox(
                      height: 8.5,
                    ),
                    Text(
                        item.productId == 'monthly'
                            ? '4 x 🍫 ' +
                                AppLocalizations.of(context).ofTwentyOneDays
                            : '8 x 🍫 ' +
                                AppLocalizations.of(context).ofTwentyOneDays,
                        style:
                            kTextStyleBodyMediumCursiva.copyWith(fontSize: 14)),
                    Text(
                        item.productId == 'monthly'
                            ? '2 x 🍫 ' +
                                AppLocalizations.of(context).ofThreeDays
                            : '4 x 🍫 ' +
                                AppLocalizations.of(context).ofThreeDays,
                        style:
                            kTextStyleBodyMediumCursiva.copyWith(fontSize: 14)),
                    SizedBox(height: 3.5),
                    SizedBox(
                      height: 8.5,
                    ),
                    Text(item.price + ' ' + item.currency,
                        style: kTextStyleBodyMediumCursiva.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18.5)),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageState != 'loading'
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: kSecondaryColor,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  TextsComboStack(),
                  Text(
                    AppLocalizations.of(context).choosePlan,
                    style: kTextStyleWhiteBodyMediumCursiva,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _showProducts()
                      // [
                      //   GestureDetector(
                      //     onTap: () => pay(choosenPlan: 'sixMonth'),
                      //     child: Container(
                      //       height: getProportionateScreenHeight(245),
                      //       width: getProportionateScreenWidth(180),
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: getProportionateScreenHeight(10),
                      //           horizontal: getProportionateScreenWidth(15)),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30),
                      //         gradient: kPrimaryGradientColor,
                      //       ),
                      //       child: Align(
                      //         alignment: Alignment.topCenter,
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               '6 Months',
                      //               textAlign: TextAlign.center,
                      //               textScaleFactor: 0.85,
                      //               style: kTextStyleBodyMedium.copyWith(
                      //                   fontWeight: FontWeight.w800),
                      //             ),
                      //             SizedBox(
                      //               height: getProportionateScreenHeight(10),
                      //             ),
                      //             Text(
                      //               'Includes:',
                      //               style: kTextStyleBodyMediumCursiva.copyWith(
                      //                   fontSize: 14.5),
                      //             ),
                      //             SizedBox(
                      //               height: 8.5,
                      //             ),
                      //             Text('10 Hashes 🍫',
                      //                 style: kTextStyleBodyMediumCursiva.copyWith(
                      //                     fontSize: 14)),
                      //             SizedBox(height: 2.5),
                      //             Text('7 🍫 x 21 days',
                      //                 style: kTextStyleBodyMediumCursiva.copyWith(
                      //                     fontSize: 14)),
                      //             SizedBox(height: 2.5),
                      //             Text('7 🍫 x 3 days',
                      //                 style: kTextStyleBodyMediumCursiva.copyWith(
                      //                     fontSize: 14)),
                      //             SizedBox(height: 2.5),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      //   GestureDetector(
                      //     onTap: () => pay(choosenPlan: 'oneYear'),
                      //     child: Container(
                      //       height: getProportionateScreenHeight(245),
                      //       width: getProportionateScreenWidth(180),
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: getProportionateScreenHeight(20),
                      //           horizontal: getProportionateScreenWidth(20)),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(30),
                      //         gradient: kPrimaryGradientColor,
                      //       ),
                      //       child: Align(
                      //         alignment: Alignment.topCenter,
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               '1 Year',
                      //               textAlign: TextAlign.center,
                      //               textScaleFactor: 0.85,
                      //               style: kTextStyleBodyMedium.copyWith(
                      //                   fontWeight: FontWeight.w800),
                      //             ),
                      //             SizedBox(
                      //               height: getProportionateScreenHeight(10),
                      //             ),
                      //             Text(
                      //               'Includes:',
                      //               style: kTextStyleBodyMediumCursiva.copyWith(
                      //                   fontSize: 14.5),
                      //             ),
                      //             SizedBox(
                      //               height: 8.5,
                      //             ),
                      //             Text('10 Hashes 🍫',
                      //                 style: kTextStyleBodyMediumCursiva.copyWith(
                      //                     fontSize: 14)),
                      //             SizedBox(height: 2.5),
                      //             Text('7 🍫 x 21 days',
                      //                 style: kTextStyleBodyMediumCursiva.copyWith(
                      //                     fontSize: 14)),
                      //             SizedBox(height: 2.5),
                      //             Text('7 🍫 x 3 days',
                      //                 style: kTextStyleBodyMediumCursiva.copyWith(
                      //                     fontSize: 14)),
                      //             SizedBox(height: 2.5),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      ),
                  Container(
                    width: getProportionateScreenWidth(180),
                    height: getProportionateScreenHeight(100),
                    child: SvgPicture.asset(
                      'assets/icons/credit-card.svg',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: kSecondaryColor,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 0.5,
                    )
                  ])),
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
