import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hide_talk/pages/log/setProfileData/components/uploadPicture.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:hide_talk/widgets/default_button.dart';
import 'package:hide_talk/widgets/form_error.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateUserName extends StatefulWidget {
  const UpdateUserName({Key key}) : super(key: key);

  @override
  _UpdateUserNameState createState() => _UpdateUserNameState();
}

class _UpdateUserNameState extends State<UpdateUserName> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  List<bool> _selections = List.generate(3, (_) => false);

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String newName;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildUserNameFormField(),
              SizedBox(height: getProportionateScreenHeight(22.5)),
              SizedBox(height: getProportionateScreenHeight(12.5)),
              DefaultButton(
                text: AppLocalizations.of(context).changeUserName,
                press: () async {
                  final uid = await auth.getCurrentUID();
                  //Guardar la informació FIREBASE DATABASE

                  await DatabaseMethods().updateUserName(
                    uid: uid,
                    newName: newName,
                  );
                  // print('Should be uploaded');

                  // Navigator.pop(context, {
                  //   'message': 'Sabia decisión $newName 🤘🏻😏',
                  //   'error': false
                  // });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () => Navigator.pop(context),
          child: CustomSurffixIcon(svgIcon: 'assets/icons/Back ICon.svg'),
        ),
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
          onSaved: (newValue) => newName = newValue,
          onChanged: (value) {
            newName = value;
          },
          style:
              kTextStyleWhiteBodyMedium.copyWith(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
                fontWeight: FontWeight.w400),
            hintStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
                fontWeight: FontWeight.w200),
            helperStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
                fontSize: 14, fontWeight: FontWeight.w200),
            // helperText:
            //     AppLocalizations.of(context).userName, //"Confirmar Contraseña"
            labelText: 'New ' +
                AppLocalizations.of(context).userName, //"Confirmar Contraseña"
            hintText: AppLocalizations.of(context)
                .userName, //"Reescribe tu Constraseña"
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
        ));
  }
}
