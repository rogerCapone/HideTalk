import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePin extends StatefulWidget {
  ChangePin({Key key}) : super(key: key);

  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  TextEditingController pinController = TextEditingController();
  TextEditingController pinController2 = TextEditingController();
  TextEditingController pinController3 = TextEditingController();
  int pin;
  int pin2;
  int pin3;
  bool error = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: kSecondaryColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: getProportionateScreenWidth(30),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: getProportionateScreenHeight(45),
                              width: getProportionateScreenHeight(45),
                              padding: EdgeInsets.all(14.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                'assets/icons/Back ICon.svg',
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenWidth(30),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(80)),
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 0.85),
                        child: TextFormField(
                          controller: pinController,
                          keyboardType: TextInputType.number,
                          style: kTextStyleWhiteBodyMedium.copyWith(
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            helperStyle: kTextStyleWhiteSmallLetter,

                            labelStyle: kTextStyleWhiteBodyMediumCursiva
                                .copyWith(fontWeight: FontWeight.w400),
                            hintStyle: kTextStyleWhiteBodyMediumCursiva
                                .copyWith(fontWeight: FontWeight.w200),
                            labelText: AppLocalizations.of(context).oldPin,
                            hintText: error
                                ? AppLocalizations.of(context).fourDigits
                                : AppLocalizations.of(context).oldPin,
                            helperText: AppLocalizations.of(context).fourDigits,
                            disabledBorder: OutlineInputBorder(
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
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 0.85),
                        child: TextFormField(
                          controller: pinController2,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          style: kTextStyleWhiteBodyMedium.copyWith(
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            helperStyle: kTextStyleWhiteSmallLetter,
                            labelStyle: kTextStyleWhiteBodyMediumCursiva
                                .copyWith(fontWeight: FontWeight.w400),
                            hintStyle: kTextStyleWhiteBodyMediumCursiva
                                .copyWith(fontWeight: FontWeight.w200),
                            labelText: AppLocalizations.of(context).createPin,
                            hintText: error
                                ? AppLocalizations.of(context).fourDigits
                                : AppLocalizations.of(context).createPin,
                            helperText: AppLocalizations.of(context).fourDigits,
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orange[100].withOpacity(0.85)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: CustomSurffixIcon(
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
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 0.85),
                        child: TextFormField(
                          onEditingComplete: () async {
                            error = false;
                            var pinString2 = pinController2.value.text.length;
                            // print(
                            //     pinString3.toString() + '   ' + pinString.toString());
                            pin3 = int.parse(pinController3.value.text);
                            pin2 = int.parse(pinController2.value.text);
                            if ((pin2 == pin3) && pinString2 == 4) {
                              final uid = await Provider.of(context)
                                  .auth
                                  .getCurrentUID();

                              var result = await DatabaseMethods()
                                  .pinAndPayCheck(
                                      uid: uid,
                                      pin: int.parse(pinController.text));

                              if (result != 'bad_pin') {
                                await DatabaseMethods()
                                    .setPin(uid: uid, pin: pin2);
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  error = true;

                                  pinController2.clear();
                                  pinController3.clear();
                                });
                              }
                            } else {
                              setState(() {
                                error = true;
                                pinController.clear();
                              });
                            }
                          },
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          controller: pinController3,
                          style: kTextStyleWhiteBodyMedium.copyWith(
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            helperStyle: kTextStyleWhiteSmallLetter,

                            labelStyle: kTextStyleWhiteBodyMediumCursiva
                                .copyWith(fontWeight: FontWeight.w400),
                            hintStyle: kTextStyleWhiteBodyMediumCursiva
                                .copyWith(fontWeight: FontWeight.w200),
                            labelText: AppLocalizations.of(context).repeatPin,
                            hintText: error
                                ? AppLocalizations.of(context).fourDigits
                                : AppLocalizations.of(context).repeatPin,
                            helperText: AppLocalizations.of(context).fourDigits,
                            disabledBorder: OutlineInputBorder(
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
                            suffixIcon: CustomSurffixIcon(
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
                      onPressed: () async {
                        error = false;

                        var pinString2 = pinController2.value.text.length;
                        // print(
                        //     pinString3.toString() + '   ' + pinString.toString());
                        pin3 = int.parse(pinController3.value.text);
                        pin2 = int.parse(pinController2.value.text);

                        if ((pin2 == pin3) && pinString2 == 4) {
                          final uid =
                              await Provider.of(context).auth.getCurrentUID();

                          var result = await DatabaseMethods().pinAndPayCheck(
                              uid: uid, pin: int.parse(pinController.text));

                          if (result != 'bad_pin') {
                            await DatabaseMethods().setPin(uid: uid, pin: pin2);
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              error = true;
                              pinController.clear();
                            });
                          }
                        } else {
                          setState(() {
                            error = true;
                            pinController2.clear();
                            pinController3.clear();
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
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      // floatingActionButton: Container(
      //   margin: EdgeInsets.symmetric(vertical: 20),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.orange,
      //     onPressed: () => Navigator.pop(context),
      //     child: CustomSurffixIcon(svgIcon: 'assets/icons/Back ICon.svg'),
      //   ),
      // ),
    );
  }
}
