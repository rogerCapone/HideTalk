import 'package:flutter/material.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/pages/log/register/verify.dart';
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

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String conform_password;
  bool remember = false;
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
          buildConformPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: DefaultButton(
                text: AppLocalizations.of(context).register,
                press: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    if (password == conform_password) {
                      //! EVALUAR -> Already registered
                      // final bool registered =
                      //     await DatabaseMethods().isEmailRegistered(email: email);

                      // if (registered == false) {
                      final result = await auth.createUserWithEmailAndPassword(
                          email: email, password: password);

                      if (result != null) {
                        final subResult = await DatabaseMethods()
                            .checkSubscription(
                                uid: result, today: DateTime.now());
                        if (subResult == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuApp()));
                        } else {
                          final String stage = await DatabaseMethods()
                              .userRegisterStage(uid: result);
                          print('\N\N\N\N');
                          print('\N\N\N\N');
                          print('\N\N\N\N');
                          print('\N\N\N\N');
                          print(stage);
                          print(stage);
                          print(stage);
                          print('\N\N\N\N');
                          print('\N\N\N\N');
                          if (stage == 'allDone') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PinPage()));
                          } else if (stage == 'userName' ||
                              stage == 'complete') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CompleteProfileScreen()));
                          } else if (stage == 'oldEnough') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ConfirmAdultScreen()));
                          } else if (stage == 'photoUrl') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PictureUploadScreen()));
                          } else if (stage == 'pin') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SetPersonalPin()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChoosePayment()));
                          }
                          print('NPTHING WAS SELECTED... SHIT');
                          // // print('\nregistered INSTANCE \n');
                          // // final bool resgistered = await DatabaseMethods()
                          // //     .isEmailRegistered(email: mail);

                          // // print('\nregistered INSTANCE \n');
                          // // print('\n$resgistered \n');
                          // // if (resgistered == false) {
                          // return Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             CompleteProfileScreen()));
                          // // } else {
                          // //   //!Procediment de login
                          // //   //? Google Login
                          // //   // setState(() {
                          // //   print('Should Consider Login Procedure');
                          // //   return Navigator.push(
                          // //       context,
                          // //       MaterialPageRoute(
                          // //           builder: (context) => LoginScreen()));
                          // //   //   // emailInUse = true;
                          // //   // });
                          // // }

                          // // Navigator.pushReplacement(
                          // //     context,
                          // //     MaterialPageRoute(
                          // //         builder: (context) =>
                          // //             ()));
                        }
                      } else {
                        print('There is something wrong psww!=pssww');
                      }
                    }

                    print(_formKey.currentState.toString());

                    // if all are valid then go to success screen

                  }
                }
                // },
                ),
          )
        ],
      ),
    );
  }

  MediaQuery buildConformPassFormField() {
    final auth = Provider.of(context).auth;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
      child: TextFormField(
        obscureText: true,
        style: kTextStyleWhiteBodyMediumCursiva.copyWith(
            fontWeight: FontWeight.w400),
        onSaved: (newValue) => conform_password = newValue,
        onEditingComplete: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            if (password == conform_password) {
              //! EVALUAR -> Already registered
              // final bool registered =
              //     await DatabaseMethods().isEmailRegistered(email: email);

              // if (registered == false) {
              final result = await auth.createUserWithEmailAndPassword(
                  email: email, password: password);

              if (result != null) {
                final subResult = await DatabaseMethods()
                    .checkSubscription(uid: result, today: DateTime.now());
                if (subResult == true) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MenuApp()));
                } else {
                  final String stage =
                      await DatabaseMethods().userRegisterStage(uid: result);
                  print('\N\N\N\N');
                  print('\N\N\N\N');
                  print('\N\N\N\N');
                  print('\N\N\N\N');
                  print(stage);
                  print(stage);
                  print(stage);
                  print('\N\N\N\N');
                  print('\N\N\N\N');
                  if (stage == 'allDone') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PinPage()));
                  } else if (stage == 'userName' || stage == 'complete') {
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
                  } else if (stage == 'pin') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SetPersonalPin()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChoosePayment()));
                  }
                  print('NPTHING WAS SELECTED... SHIT');
                  // // print('\nregistered INSTANCE \n');
                  // // final bool resgistered = await DatabaseMethods()
                  // //     .isEmailRegistered(email: mail);

                  // // print('\nregistered INSTANCE \n');
                  // // print('\n$resgistered \n');
                  // // if (resgistered == false) {
                  // return Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             CompleteProfileScreen()));
                  // // } else {
                  // //   //!Procediment de login
                  // //   //? Google Login
                  // //   // setState(() {
                  // //   print('Should Consider Login Procedure');
                  // //   return Navigator.push(
                  // //       context,
                  // //       MaterialPageRoute(
                  // //           builder: (context) => LoginScreen()));
                  // //   //   // emailInUse = true;
                  // //   // });
                  // // }

                  // // Navigator.pushReplacement(
                  // //     context,
                  // //     MaterialPageRoute(
                  // //         builder: (context) =>
                  // //             ()));
                }
              } else {
                print('There is something wrong psww!=pssww');
              }
            }

            print(_formKey.currentState.toString());

            // if all are valid then go to success screen

          }
        },
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
          } else if (value.isNotEmpty && password == conform_password) {
            removeError(error: kMatchPassError);
          }
          conform_password = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            // addError(error: kPassNullError);
            return "";
          } else if ((password != value)) {
            addError(error: kMatchPassError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w400),
          hintStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w200),
          helperStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontSize: 14, fontWeight: FontWeight.w200),
          helperText: AppLocalizations.of(context)
              .passwordHelper, //"Confirmar Contraseña"
          labelText: AppLocalizations.of(context)
              .confirmPassword, //"Confirmar Contraseña"
          hintText: AppLocalizations.of(context)
              .rewritePassword, //"Reescribe tu Constraseña"
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
              svgIcon: "assets/icons/coolLock.svg", color: kPrimaryColor),
        ),
      ),
    );
  }

  MediaQuery buildPasswordFormField() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
      child: TextFormField(
        obscureText: true,
        style: kTextStyleWhiteBodyMediumCursiva.copyWith(
            fontWeight: FontWeight.w400),
        onSaved: (newValue) => password = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
          } else if (value.length >= 4) {
            removeError(error: kShortPassError);
          }
          password = value;
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
          labelText: AppLocalizations.of(context).password, //"Contraseña"
          hintText: AppLocalizations.of(context)
              .writePassword, //Escribe tu Contraseña",

          errorStyle:
              kTextStyleWhiteSmallLetter.copyWith(fontWeight: FontWeight.w200),
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
              svgIcon: "assets/icons/coolLock.svg", color: kPrimaryColor),
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
