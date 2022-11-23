import 'package:flutter/material.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentVerification extends StatefulWidget {
  final String uid;
  final String coin;
  final String address;

  const PaymentVerification({Key key, this.uid, this.coin, this.address})
      : super(key: key);

  @override
  _PaymentVerificationState createState() => _PaymentVerificationState();
}

class _PaymentVerificationState extends State<PaymentVerification> {
  String state = 'non';

  Future<bool> payCheck() async {
    try {
      final result = await DatabaseMethods().checkPayment(
          uid: widget.uid, coin: widget.coin, address: widget.address);
      print(result.toString());
      if (result == 'ok') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final resp = await payCheck();
        if (resp == true) {
          return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MenuApp()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
          body: state == 'non'
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: kSecondaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //?Mostrar tots els detalls de la transacció per comprovar
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Container(
                            height: getProportionateScreenHeight(60),
                            width: getProportionateScreenWidth(200),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  state = 'loading';
                                });
                                final result = await payCheck();
                                if (result == true) {
                                  return Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MenuApp()),
                                      (Route<dynamic> route) => false);
                                } else {
                                  setState(() {
                                    state = 'non';
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.orange.withOpacity(0.75),
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context).checkPayment,
                                    style: kTextStyleWhiteBodyMediumCursiva,
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      //?Butto que quan l'apreti executi la f(payCheck)
                    ],
                  ),
                )
              : state == 'loading'
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: kSecondaryColor,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.2,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              AppLocalizations.of(context).checkingPayment,
                              style: kTextStyleWhiteBodyMedium.copyWith(
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                              textScaleFactor: 1.35,
                            ),
                          ],
                        ),
                      ),
                    )
                  : //*State == 'error'
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: kSecondaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //?Mostrar tots els detalls de la transacció per comprovar
                          Text(
                            AppLocalizations.of(context).paymentFail,
                            style: kTextStyleBodyMediumCursiva,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.0,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Container(
                                height: getProportionateScreenHeight(60),
                                width: getProportionateScreenWidth(200),
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      state = 'loading';
                                    });
                                    payCheck();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.orange.withOpacity(0.75),
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .checkPayment,
                                        style: kTextStyleWhiteBodyMediumCursiva,
                                        textScaleFactor: 1.0,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          //?Butto que quan l'apreti executi la f(payCheck)
                        ],
                      ),
                    )),
    );
  }
}
