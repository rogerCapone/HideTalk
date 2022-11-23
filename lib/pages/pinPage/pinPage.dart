import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/pages/payment/choosePayment.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PinPage extends StatefulWidget {
  PinPage({Key key}) : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  TextEditingController pinController = TextEditingController();
  int pin;
  bool obscure = true;
  bool failed = false;
  int attempts = 0;

  @override
  void initState() {
    pinController.clear();
    super.initState();
  }

  // @override
  // void dispose() async {
  //   // Clean up the controller when the widget is disposed.

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;

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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: kSecondaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(90)),
                  child: MediaQuery(
                    data:
                        MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
                    child: TextFormField(
                      onChanged: (string) async {
                        if (string.length == 4) {
                          pin = int.parse(pinController.value.text);
                          final uid =
                              await Provider.of(context).auth.getCurrentUID();
                          String result = await DatabaseMethods()
                              .pinAndPayCheck(uid: uid, pin: pin);

                          if (result == 'ok') {
                            pinController.clear();

                            return Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MenuApp()));
                          } else if (result == 'bad_pin') {
                            pinController.clear();

                            setState(() {
                              failed = true;
                              pinController.clear();
                              attempts++;
                            });
                          } else if (result == 'not_pay') {
                            pinController.clear();

                            return Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChoosePayment()));
                          } else {
                            pinController.clear();
                            return Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChoosePayment()));
                          }
                          if (attempts == 5) {
                            SystemNavigator.pop();
                          }
                        }
                      },
                      onEditingComplete: () async {
                        final uid =
                            await Provider.of(context).auth.getCurrentUID();
                        String result = await DatabaseMethods().pinAndPayCheck(
                            uid: uid, pin: int.parse(pinController.value.text));

                        if (result == 'ok') {
                          return Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuApp()));
                        } else if (result == 'bad_pin') {
                          setState(() {
                            failed = true;
                            pinController.clear();
                            attempts++;
                          });
                        } else if (result == 'not_pay') {
                          return Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChoosePayment(
                                        uid: uid,
                                      )));
                        }
                        pinController.clear();

                        if (attempts == 5) {
                          SystemNavigator.pop();
                        }
                      },
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      style: kTextStyleWhiteBodyMedium.copyWith(
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        // alignLabelWithHint: true,
                        helperStyle: kTextStyleWhiteSmallLetter,

                        labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
                            color: Colors.orange, fontWeight: FontWeight.w400),
                        hintStyle: kTextStyleWhiteBodyMedium.copyWith(
                            fontWeight: FontWeight.w200),
                        labelText: AppLocalizations.of(context).myPin,
                        hintText: AppLocalizations.of(context).myPin,
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
                            svgIcon: "assets/icons/coolLock.svg"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
                failed
                    ? Text(
                        AppLocalizations.of(context).pinMissMatch,
                        style: kTextStyleBodyMediumCursiva.copyWith(
                            color: Colors.red),
                        textScaleFactor: 1.0,
                      )
                    : SizedBox(),
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),
                // FloatingActionButton(
                //   backgroundColor: Colors.orange,
                //   onPressed: () async {
                //     pin = int.parse(pinController.value.text);
                //     final uid = await Provider.of(context).auth.getCurrentUID();
                //     final result = await DatabaseMethods()
                //         .pinAndPayCheck(uid: uid, pin: pin);

                //     if (result == 'ok') {
                //       return Navigator.pushReplacement(context,
                //           MaterialPageRoute(builder: (context) => MenuApp()));
                //     } else if (result == 'bad_pin') {
                //       setState(() {
                //         failed = true;
                //         pinController.clear();
                //         attempts++;
                //       });
                //     } else if (result == 'not_pay') {
                //       return Navigator.pushReplacement(context,
                //           MaterialPageRoute(builder: (context) => PaymentPage()));
                //     }
                //     if (attempts == 5) {
                //       SystemNavigator.pop();
                //     }
                //   },
                //   child: Padding(
                //     padding: EdgeInsets.all(5),
                //     child: SvgPicture.asset(
                //       "assets/icons/Lock.svg",
                //       height: getProportionateScreenWidth(25),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: getProportionateScreenHeight(100),
                ),
                GestureDetector(
                  onTap: () async {
                    await auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).closeSession,
                    textScaleFactor: 1.0,
                    style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
