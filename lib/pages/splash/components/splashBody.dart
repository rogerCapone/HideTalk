import 'package:flutter/material.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/pages/log/register/register_screen.dart';
import 'package:hide_talk/pages/splash/components/splashContent.dart';
import 'package:hide_talk/pages/splash/promoVideo.dart';
import 'package:hide_talk/services/locale_provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/animations/bonucyTrans.dart';
import 'package:hide_talk/widgets/default_button.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;
    final splashT1 = AppLocalizations.of(context).splashText1;
    final splashT2 = AppLocalizations.of(context).splashText2;
    final splashT3 = AppLocalizations.of(context).splashText3;
    final List<Map<String, String>> splashData = [
      {
        "text": splashT1,
        "text1": '\n\n#FeelHide    #BeHide',
        "image": "assets/images/master1.png"
      },
      {
        "text": splashT2,
        "text1": '\n\n#PrivateTalk',
        "image": "assets/images/master2.png"
      },
      {
        "text": splashT3,
        "text1": '\n\n#FeelHide    #BeHide',
        "image": "assets/images/master3.png"
      },
    ];
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: getProportionateScreenHeight(35),
            ),
            //!
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 5,
                ),
                TextsComboStack(index: currentPage),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          shape: BoxShape.circle),
                      child: Container(
                          child: Text(
                        locale.toString() == 'es'
                            ? 'ENG'
                            : locale.toString() == 'en'
                                ? 'ESP'
                                : 'ENG',
                        style: kTextStyleBodyMediumCursiva.copyWith(
                            fontWeight: FontWeight.w500),
                        textScaleFactor: 0.85,
                      ))),
                ),
              ],
            ),
            Expanded(
              flex: 6,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"],
                    text: splashData[index]['text'],
                    text1: splashData[index]['text1'],
                    index: index),
              ),
            ),
            currentPage != 2
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: getProportionateScreenHeight(30)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            splashData.length,
                            (index) => buildDot(index: index),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Text(
                            AppLocalizations.of(context).swipe,
                            style: kTextStyleWhiteBodyMediumCursiva,
                            textScaleFactor: 1.0,
                          ),
                        ),
                        // Spacer(flex: 1),
                        // currentPage != 2
                        //     ? Align(
                        //         alignment: Alignment.centerRight,
                        //         child: GestureDetector(
                        //           onTap: () {
                        //             Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                     builder: (context) => LoginScreen()));
                        //           },
                        //           child: Text(
                        //             'Saltar Intro',
                        //             style: kTextStyleWhiteSmallLetter.copyWith(
                        //                 color: kPrimaryColor),
                        //             textScaleFactor: 1.0,
                        //           ),
                        //         ),
                        //       )
                        //     : SizedBox(),

                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        )
                        // Spacer(),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(100)),
                        child: DefaultButton(
                          text: AppLocalizations.of(context).start,
                          press: () {
                            return Navigator.push(
                                context,
                                BouncyTrans(
                                    widget: SignUpScreen())); //PromoVideo()));
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) => SignUpScreen()));
                          },
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(30),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 5,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class TextsComboStack extends StatelessWidget {
  final index;

  const TextsComboStack({Key key, this.index}) : super(key: key);

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          "HideTalk",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 32.5, fontWeight: FontWeight.w600),
        ),
        Text(
          "HideTalk",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(fontSize: 33, color: Colors.white),
        ),
        Text(
          "HideTalk",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 33.5, fontWeight: FontWeight.w600),
        ),
        Text(
          "HideTalk",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          "HideTalk",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 34.5, fontWeight: FontWeight.w600),
        ),
        Text(
          "HideTalk",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          "HideTalk",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 35, fontWeight: FontWeight.w600),
        ),
        Text(
          "HideTalk",
          textScaleFactor: 0.95,
          style:
              kTextStyleBodyBig.copyWith(fontSize: 35.5, color: Colors.white),
        ),
      ],
    );
  }
}
