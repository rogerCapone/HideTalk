import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/helper/keyboard.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/pages/payment/choosePayment.dart';
import 'package:hide_talk/pages/payment/payment.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SetPersonalPin extends StatefulWidget {
  SetPersonalPin({Key key}) : super(key: key);

  @override
  _SetPersonalPinState createState() => _SetPersonalPinState();
}

class _SetPersonalPinState extends State<SetPersonalPin> {
  TextEditingController pinController = TextEditingController();
  TextEditingController pinController2 = TextEditingController();
  int pin;
  int pin2;
  bool error = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(color: kSecondaryColor), //kIntroBackGround),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(80)),
                  child: MediaQuery(
                    data:
                        MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      style: kTextStyleWhiteBodyMedium.copyWith(
                          fontWeight: FontWeight.w200),
                      textAlign: TextAlign.center,
                      controller: pinController,
                      decoration: InputDecoration(
                        // alignLabelWithHint: true,
                        helperStyle: kTextStyleWhiteSmallLetter,

                        labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
                            color: Colors.orange, fontWeight: FontWeight.w400),
                        hintStyle: kTextStyleWhiteBodyMedium.copyWith(
                            fontWeight: FontWeight.w200),
                        labelText: AppLocalizations.of(context).myPin,
                        hintText: AppLocalizations.of(context).createPin,
                        helperText: AppLocalizations.of(context).fourDigits,
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: CustomSurffixIcon(
                            color: Color(Colors.orange.value),
                            svgIcon: "assets/icons/pin.svg"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(80)),
                  child: MediaQuery(
                    data:
                        MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
                    child: TextFormField(
                      onChanged: (stringChange) async {
                        if (stringChange.length == 4) {
                          error = false;
//!!!
                          FocusScope.of(context).unfocus();
                          var pinString = pinController.value.text.length;
                          var pinString2 = pinController2.value.text.length;

                          pin2 = int.parse(pinController2.value.text);
                          pin = int.parse(pinController.value.text);
                          KeyboardUtil.hideKeyboard(context);

                          if ((pin == pin2) && pinString == 4) {
                            final uid =
                                await Provider.of(context).auth.getCurrentUID();
                            await DatabaseMethods().setPin(uid: uid, pin: pin);
                            return Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChoosePayment(uid: uid)),
                                (Route<dynamic> route) => false);
                          } else {
                            // setState(() {
                            //   print('shot');
                            //   error = true;
                            //   pinController.clear();
                            //   pinController2.clear();
                            // });
                          }
                        }
                      },
                      onEditingComplete: () async {
                        error = false;
//!!!
                        FocusScope.of(context).unfocus();
                        var pinString = pinController.value.text.length;
                        var pinString2 = pinController2.value.text.length;

                        pin2 = int.parse(pinController2.value.text);
                        pin = int.parse(pinController.value.text);
                        KeyboardUtil.hideKeyboard(context);

                        if ((pin == pin2) && pinString == 4) {
                          final uid =
                              await Provider.of(context).auth.getCurrentUID();
                          await DatabaseMethods().setPin(uid: uid, pin: pin);
                          return Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChoosePayment(uid: uid)),
                              (Route<dynamic> route) => false);
                        } else {
                          // setState(() {
                          //   error = true;
                          pinController.clear();
                          pinController2.clear();
                          // });
                        }
                      },
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      style: kTextStyleWhiteBodyMedium.copyWith(
                          fontWeight: FontWeight.w200),
                      textAlign: TextAlign.center,
                      controller: pinController2,
                      decoration: InputDecoration(
                        // alignLabelWithHint: true,
                        helperStyle: kTextStyleWhiteSmallLetter,

                        labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
                            color: Colors.orange, fontWeight: FontWeight.w400),
                        hintStyle: kTextStyleWhiteBodyMedium.copyWith(
                            fontWeight: FontWeight.w200),
                        labelText: AppLocalizations.of(context).repeatPin,
                        hintText: AppLocalizations.of(context).repeatPin,
                        helperText: AppLocalizations.of(context).fourDigits,
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: CustomSurffixIcon(
                            color: Color(Colors.orange.value),
                            svgIcon: "assets/icons/pin.svg"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: () async {
                    error = false;

                    var pinString = pinController.value.text.length;
                    var pinString2 = pinController2.value.text.length;
                    print(pinString2.toString() + '   ' + pinString.toString());
                    pin2 = int.parse(pinController2.value.text);
                    pin = int.parse(pinController.value.text);

                    if ((pin == pin2) && pinString == 4) {
                      final uid =
                          await Provider.of(context).auth.getCurrentUID();
                      await DatabaseMethods().setPin(uid: uid, pin: pin);
                      return Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChoosePayment(uid: uid)),
                          (Route<dynamic> route) => false);
                    } else {
                      setState(() {
                        error = true;
                        pinController.clear();
                        pinController2.clear();
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: SvgPicture.asset(
                      "assets/icons/coolLock.svg",
                      height: getProportionateScreenWidth(25),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
