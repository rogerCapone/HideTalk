import 'package:flutter/material.dart';
import 'package:hide_talk/shared/constants.dart';

import 'components/splashBody.dart';

class SplashScreen extends StatelessWidget {
  // static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kSecondaryColor,
        child: Body(),
      ),
    );
  }
}
