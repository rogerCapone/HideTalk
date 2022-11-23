import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hide_talk/pages/log/setProfileData/components/uploadPicture.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:hide_talk/widgets/default_button.dart';
import 'package:hide_talk/widgets/form_error.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'confirmAdult.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({Key key}) : super(key: key);

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  List<bool> _selections = List.generate(3, (_) => false);

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  String userName;
  String realName;
  DateTime birthDate = DateTime(2008, 12, 31, 23, 12, 34);
  String postalCode;
  String tokenId;

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

  // _saveDeviceToken({String uid}) async {
  //   String fcmToken = await _fcm.getToken();
  //   if (fcmToken != null) {}
  // }

  @override
  void initState() {
    super.initState();
    try {
      _fcm.requestPermission(provisional: true); //
    } catch (e) {
      print(e);
    }
    _fcm.getToken().then((value) {
      print(value);
      print('I ALREADY GOT IT BRO... ✌🏻😊');
      setState(() {
        tokenId = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;
    print('I try to build the widget');
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildUserNameFormField(),
          SizedBox(height: getProportionateScreenHeight(24.5)),
          Text(
            AppLocalizations.of(context).genderQuestion,
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style:
                kTextStyleWhiteBodyMedium.copyWith(fontWeight: FontWeight.w300),
          ),
          SizedBox(height: getProportionateScreenHeight(12.5)),
          buildGenderSelector(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(25.5)),
          DefaultButton(
            text: AppLocalizations.of(context).continuee,
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                final uid = await auth.getCurrentUID();
                //Guardar la informació FIREBASE DATABASE

                await DatabaseMethods().uploadUserData(
                    uid: uid,
                    userName: userName,
                    tokenId: tokenId,
                    sex: _selections[0] == true
                        ? 'Man'
                        : _selections[1] == true
                            ? 'Undefined'
                            : 'Woman');
                print('Should be uploaded');

                //Navegar a una pagina que permeti afegir una imatge
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmAdultScreen()));

                //Guardarla a Cloud Storage i tot ready per la app

                // Navigator.pushNamed(context, OtpScreen.routeName);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildGenderSelector() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(40),
        borderColor: Colors.grey.withOpacity(0.4),
        children: <Widget>[
          CustomSurffixIcon(
              color: Colors.orange, svgIcon: "assets/icons/man.svg"),
          Container(
            height: 35,
            width: 35,
            child: Stack(
              children: [
                CustomSurffixIcon(
                    color: Colors.grey.withOpacity(0.7),
                    svgIcon: "assets/icons/genderless.svg"),
                SvgPicture.asset('assets/icons/genderless.svg')
              ],
            ),
          ),
          CustomSurffixIcon(
              color: Colors.orange, svgIcon: "assets/icons/woman.svg"),
        ],
        isSelected: _selections,
        onPressed: (int index) {
          setState(() {
            _selections[0] = false;
            _selections[1] = false;
            _selections[2] = false;
            _selections[index] = true;
          });
          print(_selections.toString());
        },
      ),
    );
  }

  // TextFormField buildRealNameFormField() {
  //   return TextFormField(
  //     onSaved: (newValue) => realName = newValue,
  //     decoration: InputDecoration(
  //       labelText: "Real Name",
  //       hintText: "Enter your Real Name",
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(30),
  //       ),
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
  //     ),
  //   );
  // }

  MediaQuery buildUserNameFormField() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
      child: TextFormField(
        onSaved: (newValue) => userName = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kNamelNullError);
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty) {
            addError(error: kNamelNullError);
            return "";
          }
          return null;
        },
        style: kTextStyleWhiteBodyMedium.copyWith(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w400),
          hintStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w200),
          helperStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontSize: 14, fontWeight: FontWeight.w200),
          helperText:
              AppLocalizations.of(context).userNameTip, //"Confirmar Contraseña"
          labelText:
              AppLocalizations.of(context).userName, //"Confirmar Contraseña"
          hintText: AppLocalizations.of(context)
              .yourUserName, //"Reescribe tu Constraseña"
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
            svgIcon: "assets/icons/User.svg",
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
