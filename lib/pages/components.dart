import 'package:flutter/material.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AppData {
  static final AppData _appData = new AppData._internal();

  bool isClient;

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();

var kWelcomeAlertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    animationDuration: Duration(milliseconds: 450),
    backgroundColor: kPrimaryColor,
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    titleStyle: kTextStyleBodyMedium);
