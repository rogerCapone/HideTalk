import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hide_talk/logic/cubits/settings/settings_cubit.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/pages/user_profile/notifications/rollingSwitch.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: kSecondaryColor,
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              TextsComboStack(),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: Global.appRef.userAppData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        height: getProportionateScreenHeight(500),
                        width: getProportionateScreenWidth(250),
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.5 * pi,
                            child: MyRollingSwitch(
                              //initial value
                              value: snapshot.data.data()['sendNotifications'],
                              textOn: 'ON',
                              textOff: 'OFF',
                              colorOn: kSecondaryColor,
                              width: getProportionateScreenHeight(650),
                              height: getProportionateScreenWidth(250),
                              iconSize: getProportionateScreenWidth(150),
                              colorOff: kSecondaryColor,
                              // iconOn: Icons.done,
                              // iconOff: Icons.remove_circle_outline,
                              textSize: 16.0,
                              onChanged: (bool state) async {
                                //Use it to manage the different states
                                final uid = await Provider.of(context)
                                    .auth
                                    .getCurrentUID();
                                await DatabaseMethods()
                                    .changeNotiSettings(uid: uid, value: state);
                                //!canviar-ho de la database
                                print('Current State of SWITCH IS: $state');
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          )),
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
}

class TextsComboStack extends StatelessWidget {
  const TextsComboStack({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).notifications,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 32.5, fontWeight: FontWeight.w600),
        ),
        Text(
          AppLocalizations.of(context).notifications,
          style: kTextStyleBodyBig.copyWith(fontSize: 33, color: Colors.white),
        ),
        Text(
          AppLocalizations.of(context).notifications,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 33.5, fontWeight: FontWeight.w600),
        ),
        Text(
          AppLocalizations.of(context).notifications,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        // Text(
        //   AppLocalizations.of(context).notifications,
        //   style: kTextStyleBodyBig.copyWith(
        //       fontSize: 34.5, fontWeight: FontWeight.w600),
        // ),
        // Text(
        //   AppLocalizations.of(context).notifications,
        //   style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        // ),
        // Text(
        //   AppLocalizations.of(context).notifications,
        //   style: kTextStyleBodyBig.copyWith(
        //       fontSize: 35, fontWeight: FontWeight.w600),
        // ),
        // Text(
        //   AppLocalizations.of(context).notifications,
        //   style:
        //       kTextStyleBodyBig.copyWith(fontSize: 35.5, color: Colors.white),
        // ),
      ],
    );
  }
}
