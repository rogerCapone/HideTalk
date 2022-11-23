import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hide_talk/pages/legal/privacyPolicy.dart';
import 'package:hide_talk/pages/legal/termsAndConditions.dart';
import 'package:hide_talk/pages/log/login/a_login_screen.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyInformation extends StatefulWidget {
  @override
  _MyInformationState createState() => _MyInformationState();
}

class _MyInformationState extends State<MyInformation> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<DocumentSnapshot>(
              future: Global.appRef.getAppDataDoc(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data.data());
                  DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data.data()['createdAt']);
                  int day = createdAt.day;
                  int month = createdAt.month;
                  int year = createdAt.year;
                  DateTime lastLogin = DateTime.fromMillisecondsSinceEpoch(
                      snapshot.data.data()['lastLogin']);
                  int hourLL = lastLogin.hour;
                  int minuteLL = lastLogin.minute;
                  int dayLL = lastLogin.day;
                  int monthLL = lastLogin.month;
                  int yearLL = lastLogin.year;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).allCollectedData,
                          style: kTextStyleBodySmall,
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '#FeelHide',
                          textScaleFactor: 1.1,
                          style: kTextStyleBodyMediumCursiva,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '\n\n',
                          textScaleFactor: 1.0,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 45),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).myName,
                                    style: kTextStyleBodySmall,
                                    textScaleFactor: 1.0,
                                  ),
                                  Text(
                                    // snapshot.data.data()['sex'] == 'Male'
                                    //     ? 'Hombre' //AppLocalizations.of(context).men,
                                    //     : snapshot.data.data()['sex'] == 'Female'
                                    //         ? 'Mujer' //AppLocalizations.of(context).women,
                                    //         :
                                    snapshot.data.data()['userName'],
                                    style: kTextStyleBodyMediumCursiva,
                                    textScaleFactor: 1.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Text(
                                '\n',
                                textScaleFactor: 1.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).sex,
                                    style: kTextStyleBodySmall,
                                    textScaleFactor: 1.0,
                                  ),
                                  Text(
                                    // snapshot.data.data()['sex'] == 'Male'
                                    //     ? 'Hombre' //AppLocalizations.of(context).men,
                                    //     : snapshot.data.data()['sex'] == 'Female'
                                    //         ? 'Mujer' //AppLocalizations.of(context).women,
                                    //         :
                                    AppLocalizations.of(context).doesNotMatter,
                                    style: kTextStyleBodyMediumCursiva,
                                    textScaleFactor: 1.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Text(
                                '\n',
                                textScaleFactor: 1.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).mail + ':  ',
                                    style: kTextStyleBodySmall,
                                    textScaleFactor: 1.0,
                                  ),
                                  Text(
                                    snapshot.data
                                            .data()['userEmail']
                                            .split('@')[0] +
                                        '@...',
                                    style: kTextStyleBodyMediumCursiva,
                                    textScaleFactor: 1.0,
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              ),
                              Text(
                                '\n',
                                textScaleFactor: 1.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).lastConnection,
                                    textScaleFactor: 1.0,
                                    style: kTextStyleBodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    (hourLL.toString().length > 1 &&
                                            minuteLL.toString().length > 1)
                                        ? '' +
                                            hourLL.toString() +
                                            ':' +
                                            minuteLL.toString()
                                        : minuteLL.toString().length > 1
                                            ? '0' +
                                                hourLL.toString() +
                                                ':' +
                                                minuteLL.toString()
                                            : hourLL.toString().length > 1
                                                ? hourLL.toString() +
                                                    ':' +
                                                    '0' +
                                                    minuteLL.toString()
                                                : '0' +
                                                    hourLL.toString() +
                                                    ':' +
                                                    '0' +
                                                    minuteLL.toString(),
                                    textScaleFactor: 1.0,
                                    style: kTextStyleBodyMediumCursiva,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Text(
                                '\n',
                                textScaleFactor: 1.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).accountCreated,
                                    textScaleFactor: 1.0,
                                    style: kTextStyleBodySmall,
                                  ),
                                  Text(
                                    ' ' +
                                        day.toString() +
                                        ' / ' +
                                        month.toString() +
                                        ' / ' +
                                        year.toString(),
                                    textScaleFactor: 1.0,
                                    style: kTextStyleBodyMedium,
                                  ),
                                ],
                              ),
                              Text(
                                '\n',
                                textScaleFactor: 1.0,
                                style: kTextStyleBodySmall,
                              )
                            ])),
                        // Text(
                        //   'Sexo: ' + snapshot.data.data()['sex'],
                        //   style: kTextStyleBodySmall,
                        //   textScaleFactor: 1.0,
                        // ),
                        Text(
                          '\n',
                          textScaleFactor: 1.0,
                          style: kTextStyleBodySmall,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).accepted,
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.0,
                            style: kTextStyleSmallLetter,
                          ),
                        ),
                        Text(
                          '\n',
                          textScaleFactor: 0.55,
                          style: kTextStyleBodySmall,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TermsAndConditions())),
                                  child: Text(
                                    AppLocalizations.of(context).termsAndCo,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style: kTextStyleSmallLetter.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  )),
                              Text(
                                AppLocalizations.of(context).and,
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: kTextStyleSmallLetter,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PrivacyPolicy())),
                                child: Text(
                                    AppLocalizations.of(context).privacyPolicy,
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1.0,
                                    style: kTextStyleSmallLetter.copyWith(
                                      decoration: TextDecoration.underline,
                                    )),
                              )
                            ])
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }),
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
}
