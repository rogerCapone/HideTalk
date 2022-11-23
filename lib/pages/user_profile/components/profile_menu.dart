import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/services/locale_provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:provider/provider.dart';
import 'package:hide_talk/services/provider.dart' as myProvider;

class ProfileMenu extends StatelessWidget {
  const ProfileMenu(
      {Key key,
      @required this.text,
      @required this.icon,
      this.press,
      this.type})
      : super(key: key);

  final String text, icon;
  final VoidCallback press;
  final int type;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: type != 0 ? 20 : 45, vertical: 5.5),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        color: type != 0 ? kSecondaryColor : kSecondaryColor,
        onPressed: press,
        child: Row(
          children: [
            type != 0
                ? Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      // SvgPicture.asset(
                      //   icon,
                      //   color: kPrimaryColor,
                      //   width: 22,
                      // ),
                      SvgPicture.asset(
                        icon,
                        color: Colors.white,
                        width: 23,
                      ),
                      // SvgPicture.asset(
                      //   icon,
                      //   color: Colors.black,
                      //   width: 24,
                      // ),
                    ],
                  )
                : SizedBox(),
            // : Stack(
            //     alignment: Alignment.centerRight,
            //     children: [
            //       // SvgPicture.asset(
            //       //   icon,
            //       //   color: Colors.black,
            //       //   width: 22,
            //       // ),
            //       // SvgPicture.asset(
            //       //   icon,
            //       //   color: kPrimaryColor,
            //       //   width: 23,
            //       // ),
            //       SvgPicture.asset(
            //         icon,
            //         color: Colors.red,
            //         width: 20,
            //       ),
            //     ],
            //   ),
            SizedBox(
              width: 35,
            ),
            Expanded(
              child: type != 0
                  ? Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Text(
                        //   text,
                        //   style: kTextStyleBodySmall.copyWith(
                        //       fontSize: 18.5, color: kPrimaryColor),
                        //   textAlign: TextAlign.center,
                        //   textScaleFactor: 1.0,
                        // ),
                        // Text(
                        //   text,
                        //   style: kTextStyleBodySmall.copyWith(
                        //       fontSize: 19, color: Colors.white),
                        //   textAlign: TextAlign.center,
                        //   textScaleFactor: 1.0,
                        // ),
                        Text(
                          text,
                          style: kTextStyleWhiteBodySmall.copyWith(
                              fontWeight: FontWeight.w200, fontSize: 18.5),
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                        ),
                      ],
                    )
                  : Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // Text(
                        //   text,
                        //   style: kTextStyleBodySmall.copyWith(fontSize: 18.5),
                        //   textAlign: TextAlign.center,
                        //   textScaleFactor: 1.0,
                        // ),
                        // Text(
                        //   text,
                        //   style: kTextStyleBodySmall.copyWith(
                        //       fontSize: 19, color: kPrimaryColor),
                        //   textAlign: TextAlign.center,
                        //   textScaleFactor: 1.0,
                        // ),
                        GestureDetector(
                          onTap: () async {
                            //!Hauria de sortir un popUp
                            final auth = myProvider.Provider.of(context).auth;
                            await auth.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Container(
                            child: Text(
                              text,
                              style: kTextStyleBodySmall.copyWith(
                                  fontSize: 16.5, color: kPrimaryColor),
                              textAlign: TextAlign.right,
                              textScaleFactor: 1.0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // final provider =
                                print(locale.toString());
                                if (locale.toString() == 'en') {
                                  print('LOCALE IS IN ${locale.toString()}');
                                  print('Converting to ESPA');
                                  provider.setLocale(Locale('es'));
                                } else {
                                  provider.setLocale(Locale('en'));
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      // color: Colors.white.withOpacity(0.75),
                                      shape: BoxShape.circle),
                                  child: Text(
                                    locale.toString() == 'en'
                                        ? 'ENG'
                                        : locale.toString() == 'es'
                                            ? 'ESP'
                                            : 'ENG',
                                    style: kTextStyleBodyMedium.copyWith(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
