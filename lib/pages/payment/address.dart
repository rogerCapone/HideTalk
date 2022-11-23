import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/pages/payment/paymentVerification.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressPage extends StatelessWidget {
  final String coin;
  final double amount;
  final String subscription;

  const AddressPage({Key key, this.coin, this.amount, this.subscription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String address = coin + 'Address';
    //!DELETE
    final uid = Provider.of(context).auth.getCurrentUID();
    print('senderUID');
    print(uid);
    //!END DELETE
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallCoinShow(icon: 'assets/icons/$coin.svg', coinName: coin),
                SizedBox(
                  width: getProportionateScreenWidth(15),
                ),
                TextsComboStack(
                    coin: coin == 'btc'
                        ? 'Bitcoin'
                        : coin == 'ltc'
                            ? 'Litecoin'
                            : 'Dogecoin'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).subSelected,
                  style: kTextStyleWhiteSmallLetter.copyWith(
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,
                ),
                Text(
                  subscription == 'monthly'
                      ? ' ' + AppLocalizations.of(context).monthly
                      : ' ' + AppLocalizations.of(context).anual,
                  style: kTextStyleWhiteBodyMedium.copyWith(
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  AppLocalizations.of(context).transferToWallet,
                  style: kTextStyleWhiteSmallLetter.copyWith(
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                  textScaleFactor: 0.85,
                ),
                SizedBox(
                  height: 5,
                ),
                SelectableText(
                  " $amount ${coin.toUpperCase()}",
                  style: kTextStyleWhiteBodyMedium.copyWith(
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.15,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(context).rememberComissions,
                  style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                      color: Colors.orange, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                  textScaleFactor: 0.65,
                ),
              ],
            ),
            FutureBuilder(
              future: Global.appRef.getAppDataDoc(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: getProportionateScreenHeight(500),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          height: getProportionateScreenHeight(355),
                          width: getProportionateScreenWidth(355),
                          child: PrettyQr(
                              elementColor: Colors.white,
                              typeNumber: 3,
                              size: 300,
                              data: snapshot.data.data()[address].toString(),
                              roundEdges: true),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(15),
                        ),
                        Container(
                          height: getProportionateScreenHeight(45),
                          width: MediaQuery.of(context).size.width - 35.0,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: SelectableText(
                              snapshot.data.data()[address].toString(),
                              style: kTextStyleSmallLetter.copyWith(
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                              textScaleFactor: 0.85,
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: getProportionateScreenHeight(40),
                                width: getProportionateScreenHeight(40),
                                padding: EdgeInsets.all(14.5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange),
                                child: Center(
                                    child: SvgPicture.asset(
                                  'assets/icons/Back ICon.svg',
                                  color: Colors.black,
                                )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(new ClipboardData(
                                        text: snapshot.data.data()[address]))
                                    .then((result) {
                                  final snackBar = SnackBar(
                                    backgroundColor: Colors.white,
                                    content: Text(
                                      AppLocalizations.of(context).walletCopied,
                                      style: kTextStyleSmallLetter,
                                      textAlign: TextAlign.center,
                                    ),
                                    // action: SnackBarAction(
                                    //   label: 'Undo',
                                    //   onPressed: () {},
                                    // ),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                });
                              },
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  child: SvgPicture.asset(
                                    'assets/icons/clipBoard.svg',
                                    color: Colors.white,
                                  )),
                            ),
                            GestureDetector(
                              onTap: () async {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.confirm,
                                  animType: CoolAlertAnimType.slideInDown,
                                  barrierDismissible: true,
                                  title: AppLocalizations.of(context)
                                      .transactionDone,
                                  cancelBtnText:
                                      AppLocalizations.of(context).no,
                                  confirmBtnText:
                                      AppLocalizations.of(context).yes,
                                  confirmBtnColor:
                                      Colors.orange.withOpacity(0.85),
                                  text: AppLocalizations.of(context)
                                      .transactionReminder,
                                  onConfirmBtnTap: () async {
                                    //!Aquesta lógica s'hauria de fer en una altre pagina (processant el pagament)
                                    final uid = await Provider.of(context)
                                        .auth
                                        .getCurrentUID();
                                    final address = snapshot.data
                                        .data()['address']
                                        .toString();
                                    //!Navigator push --> checking payment page
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentVerification(
                                                    uid: uid,
                                                    coin: coin,
                                                    address: address)));

                                    // final uid = await Provider.of(context)
                                    //     .auth
                                    //     .getCurrentUID();
                                    // final result = await DatabaseMethods()
                                    //     .checkPayment(
                                    //         uid: uid,
                                    //         coin: coin,
                                    //         address: snapshot.data
                                    //             .data()[address]
                                    //             .toString());
                                    // print(result.toString());

                                    // if (result == 'ok') {
                                    //   return Navigator.pushReplacement(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) => MenuApp()));
                                    // } else {
                                    //   print(
                                    //       'Something went wrong client did not pay');
                                    //   return Navigator.pop(context);
                                    // }
                                  },
                                  backgroundColor:
                                      Colors.orange.withOpacity(0.9),
                                  onCancelBtnTap: () {
                                    return Navigator.pop(context);
                                  },
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: getProportionateScreenHeight(35),
                                    width: getProportionateScreenHeight(35),
                                    padding: EdgeInsets.all(2.5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                        child: SvgPicture.asset(
                                      'assets/icons/sending.svg',
                                      color: Colors.orange,
                                    )),
                                  ),
                                  Text(AppLocalizations.of(context).sended,
                                      style: kTextStyleWhiteSmallLetter
                                          .copyWith(color: Colors.orange),
                                      textAlign: TextAlign.center)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Container(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SmallCoinShow extends StatelessWidget {
  final String icon;
  final String coinName;

  const SmallCoinShow({Key key, this.icon, this.coinName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(45),
      width: getProportionateScreenHeight(45),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: kPrimaryGradientColor,
      ),
      child: Container(
        height: getProportionateScreenHeight(250),
        width: getProportionateScreenHeight(250),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          icon,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class TextsComboStack extends StatelessWidget {
  final index;
  final String coin;

  const TextsComboStack({Key key, this.index, this.coin}) : super(key: key);

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          coin,
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 32.5, fontWeight: FontWeight.w600),
        ),
        Text(
          coin,
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(fontSize: 33, color: Colors.white),
        ),
        Text(
          coin,
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 33.5, fontWeight: FontWeight.w600),
        ),
        Text(
          coin,
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          coin,
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 34.5, fontWeight: FontWeight.w600),
        ),
        Text(
          coin,
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          coin,
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 35, fontWeight: FontWeight.w600),
        ),
        Text(
          coin,
          textScaleFactor: 0.95,
          style:
              kTextStyleBodyBig.copyWith(fontSize: 35.5, color: Colors.white),
        ),
      ],
    );
  }
}
