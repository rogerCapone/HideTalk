import 'package:flutter/material.dart';
import 'package:hide_talk/helper/keyboard.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/pages/log/forgot_password/a_forgot_password.dart';
import 'package:hide_talk/pages/log/setProfileData/completeProfile.dart';
import 'package:hide_talk/pages/log/setProfileData/components/confirmAdult.dart';
import 'package:hide_talk/pages/log/setProfileData/components/uploadPicture.dart';
import 'package:hide_talk/pages/payment/choosePayment.dart';
import 'package:hide_talk/pages/pinPage/pinPage.dart';
import 'package:hide_talk/pages/pinPage/setUpPin.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:hide_talk/widgets/default_button.dart';
import 'package:hide_talk/widgets/form_error.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  bool obscure = true;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Text(
                AppLocalizations.of(context).weRememberAccount,
                style: kTextStyleWhiteSmallLetter,
                textScaleFactor: 1.0,
              ),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen())),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).forgotPassword,
                      style: kTextStyleWhiteSmallLetter.copyWith(
                          fontSize: 10, decoration: TextDecoration.underline),
                      textScaleFactor: 1.0,
                    ),
                    Text(
                      "🥺",
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: DefaultButton(
              text: AppLocalizations.of(context).initSession,
              press: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  // if all are valid then go to success screen
                  var result = await auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  print(result.toString());
                  if (result != null) {
                    final uid = await Provider.of(context).auth.getCurrentUID();

                    final subResult = await DatabaseMethods()
                        .checkSubscription(uid: uid, today: DateTime.now());
                    if (subResult == true) {
                      return Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MenuApp()),
                          (Route<dynamic> route) => false);
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MenuApp()));
                    } else {
                      final String stage =
                          await DatabaseMethods().userRegisterStage(uid: uid);
                      print(stage);
                      if (stage == 'allDone') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => PinPage()));
                      } else if (stage == 'userName') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompleteProfileScreen()));
                      } else if (stage == 'oldEnough') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmAdultScreen()));
                      } else if (stage == 'photoUrl') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PictureUploadScreen()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SetPersonalPin()));
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChoosePayment()));
                    }
                  }
                  KeyboardUtil.hideKeyboard(context);
                  // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  MediaQuery buildPasswordFormField() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
      child: TextFormField(
        obscureText: obscure,
        style: kTextStyleWhiteBodyMediumCursiva.copyWith(
            fontWeight: FontWeight.w400),
        onSaved: (newValue) => password = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
          } else if (value.length >= 4) {
            removeError(error: kShortPassError);
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kPassNullError);
            return "";
          } else if (value.length < 4) {
            addError(error: kShortPassError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w400),
          hintStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w200),
          // helperStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
          //     fontWeight: FontWeight.w200),
          // helperText: AppLocalizations.of(context)
          //     .passwordHelper, //"Confirmar Contraseña"
          labelText:
              AppLocalizations.of(context).password, //"Confirmar Contraseña"
          hintText: AppLocalizations.of(context)
              .password, //"Reescribe tu Constraseña"
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(50),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(50),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(50),
          ),
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                obscure = !obscure;
              });
            },
            child: CustomSurffixIcon(
                svgIcon: "assets/icons/coolLock.svg", color: kPrimaryColor),
          ),
        ),
      ),
    );
  }

  MediaQuery buildEmailFormField() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        style: kTextStyleWhiteBodyMediumCursiva.copyWith(
            fontWeight: FontWeight.w400),
        onSaved: (newValue) => email = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
          } else if (emailValidatorRegExp.hasMatch(value)) {
            removeError(error: kInvalidEmailError);
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kEmailNullError);
            return "";
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            addError(error: kInvalidEmailError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w400),

          hintStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w200),
          errorStyle:
              kTextStyleWhiteSmallLetter.copyWith(fontWeight: FontWeight.w200),
          labelText: AppLocalizations.of(context).mail, //"Correo"
          hintText:
              AppLocalizations.of(context).writeMail, //"Escribe tu Correo"
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(50),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(50),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(50),
          ),
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(
              svgIcon: "assets/icons/mail.svg", color: kPrimaryColor),
        ),
      ),
    );
  }
}
