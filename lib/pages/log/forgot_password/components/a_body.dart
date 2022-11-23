import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:hide_talk/widgets/default_button.dart';
import 'package:hide_talk/widgets/form_error.dart';
import 'package:hide_talk/widgets/no_account_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: kSecondaryColor,
      child: Center(
          child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: getProportionateScreenHeight(40),
                        width: getProportionateScreenHeight(40),
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
                SizedBox(height: getProportionateScreenHeight(85)),
                Text(
                  AppLocalizations.of(context).forgotPassword,
                  style: kTextStyleWhiteTitleBig,
                  textScaleFactor: 1.0,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppLocalizations.of(context).forgotProcedure,
                    // "",
                    style: kTextStyleWhiteBodyMediumCursiva,
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                ForgotPassForm(),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    String email;
    final _auth = Provider.of(context).auth;

    Widget okButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).understand,
        textScaleFactor: 1.0,
        style: kTextStyleWhiteBodySmall,
      ),
      color: kPrimaryColor,
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
    Container alert = Container(
        height: getProportionateScreenHeight(250),
        width: getProportionateScreenWidth(200),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
        child: AlertDialog(
          title: Text(
            AppLocalizations.of(context).visitMail,
            textScaleFactor: 1.0,
            style: kTextStyleWhiteBodyBig,
          ),
          content: Text(AppLocalizations.of(context).findResetPassword,
              textScaleFactor: 1.0, style: kTextStyleWhiteBodyMediumCursiva),
          actions: [
            Center(child: okButton),
          ],
        ));

    return Form(
      key: _formKey,
      child: Column(
        children: [
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: TextFormField(
              style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                  fontWeight: FontWeight.w400),
              keyboardType: TextInputType.emailAddress,
              onSaved: (newValue) {
                setState(
                  () {
                    email = newValue;
                  },
                );
              },
              onChanged: (value) {
                if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                  setState(() {
                    errors.remove(kEmailNullError);
                  });
                } else if (emailValidatorRegExp.hasMatch(value) &&
                    errors.contains(kInvalidEmailError)) {
                  setState(() {
                    errors.remove(kInvalidEmailError);
                  });
                }
                email = value;
                print(email);
              },
              validator: (value) {
                if (value.isEmpty && !errors.contains(kEmailNullError)) {
                  setState(() {
                    errors.add(kEmailNullError);
                  });
                } else if (!emailValidatorRegExp.hasMatch(value) &&
                    !errors.contains(kInvalidEmailError)) {
                  setState(() {
                    errors.add(kInvalidEmailError);
                  });
                }
                return null;
              },
              decoration: InputDecoration(
                labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
                    fontWeight: FontWeight.w400),

                hintStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
                    fontWeight: FontWeight.w200),
                errorStyle: kTextStyleWhiteSmallLetter.copyWith(
                    fontWeight: FontWeight.w200),
                labelText: AppLocalizations.of(context).mail, //"Correo"
                hintText: AppLocalizations.of(context)
                    .writeMail, //"Escribe tu Correo"
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
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: AppLocalizations.of(context).resetPassword,
            press: () async {
              if (_formKey.currentState.validate()) {
                print(email);
                await _auth.sendPasswordResetEmail(email);
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierColor: Colors.transparent.withOpacity(0.6),
                    builder: (context) {
                      return alert;
                    });
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
        ],
      ),
    );
  }
}
