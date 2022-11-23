import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/pages/chats/chat/chat.dart';
import 'package:hide_talk/pages/chats/chats_body.dart';
import 'package:hide_talk/pages/contacts/contacts_body.dart';
import 'package:hide_talk/pages/pinPage/pinPage.dart';
import 'package:hide_talk/pages/user_profile/components/profile_body.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuApp extends StatefulWidget {
  MenuApp({Key key}) : super(key: key);

  @override
  _MenuAppState createState() => _MenuAppState();
}

class _MenuAppState extends State<MenuApp> with WidgetsBindingObserver {
  int screenSelected = 0;
  PageController pageController = PageController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final Color inActiveIconColor = Color(0xFFB6B6B6);

  bool _pinPage = false;
  bool backAgain = false;
  int n_msg = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      print('onMESSAGE');
      print(msg.toString());
      //? per accedir : message['notification]['title']
      //? per accedir : message['notification]['body']
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      print('onMessageOpenedApp');
      print(msg.toString());
    });

    // onResume: (Map<String, dynamic> message) async {
    //   print('onResume');
    //   print(message['notification']['body']);
    // },
    // onLaunch: (Map<String, dynamic> message) async {
    //   print('onResume');
    //   print('onResume');
    //   print('onResume');
    // },
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        //!imp quan surt de la app
        print('paused');
        break;
      case AppLifecycleState.resumed:
        //!imp quan torna a entrar a la app
        print('resumed');
        backAgain = true;
        break;
      case AppLifecycleState.inactive:
        backAgain = false;
        Future.delayed(const Duration(minutes: 7), () async {
          if (backAgain != true) {
            setState(() {
              _pinPage = true;
            });
          } else {
            print('dismissed 😋');
          }
        });
        // setState(() {
        //   _pinPage = true;
        // });
        print('inactive');
        break;
      case AppLifecycleState.detached:
        setState(() {
          _pinPage = true;
        });
        print('detatched');
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      drawerDragStartBehavior: DragStartBehavior.start,
      drawerScrimColor: Colors.black.withOpacity(0.45),
      endDrawer: screenSelected != 2
          ? null
          : ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              child: SecretContactsDrawer(),
            ),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: kSecondaryColor),
          PageView(
            controller: pageController,
            physics: BouncingScrollPhysics(),
            onPageChanged: (page) {
              print(page.toString());
              setState(() {
                screenSelected = page;
              });
            },
            scrollDirection: Axis.horizontal,
            children: [
              ContactsScreen(),
              ChatsBody(),
              ProfileBody(),
            ],
          ),
          _pinPage
              ? PinPage()
              // Container(
              //     height: MediaQuery.of(context).size.height,
              //     width: MediaQuery.of(context).size.width,
              //     child: PinPage(),
              //     color: screenSelected == 0 ? kSecondaryColor : Colors.white,
              //   )
              : Container(),
        ],
      ),
      bottomNavigationBar: _pinPage
          ? SizedBox()
          : Container(
              decoration: BoxDecoration(
                  color: screenSelected == 0 ? null : kSecondaryColor,
                  gradient: screenSelected == 0 ? kPrimaryGradientColor : null),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: IconButton(
                              icon: SvgPicture.asset(
                                "assets/icons/contacts.svg",
                                height: 24.5,
                                color: screenSelected == 0
                                    ? kPrimaryColor
                                    : inActiveIconColor,
                                // color: MenuState.home == selectedMenu
                                //     ? kPrimaryColor
                                //     : inActiveIconColor,
                              ),
                              onPressed: () {
                                pageController.jumpToPage(0);

                                // _changeBodyPage(0);

                                //Navigator.pushNamed(context, HomeScreen.routeName);
                              }),
                        ),
                        // IconButton(
                        //   icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),
                        //   onPressed: () {},
                        // ),
                        Stack(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                "assets/icons/Chat bubble Icon.svg",
                                color: screenSelected == 1
                                    ? kPrimaryColor
                                    : inActiveIconColor,
                              ),
                              onPressed: () {
                                pageController.jumpToPage(1);

                                // _changeBodyPage(1);
                              },
                            ),
                            StreamBuilder(
                              stream: Global.appRef.inboxStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<dynamic> list =
                                      snapshot.data.data()['inbox'];
                                  n_msg = list.length;

                                  return n_msg > 0
                                      ? Positioned(
                                          top: 0,
                                          right: 5,
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kPrimaryColor),
                                            child: Center(
                                              child: Text(
                                                n_msg.toString(),
                                                textScaleFactor: 1.0,
                                                style: kTextStyleBodySmall
                                                    .copyWith(
                                                        fontSize: 13.5,
                                                        color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox();
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                        IconButton(
                            icon: SvgPicture.asset(
                              "assets/icons/User Icon.svg",
                              color: screenSelected == 2
                                  ? kPrimaryColor
                                  : inActiveIconColor,
                              // color: MenuState.profile == selectedMenu
                              //     ? kPrimaryColor
                              //     : inActiveIconColor,
                            ),
                            onPressed: () {
                              pageController.jumpToPage(2);

                              // _changeBodyPage(2);
                            }),
                      ],
                    )),
              ),
            ),
    );
  }

  // void _changeBodyPage(int i) {
  //   setState(() {
  //     screenSelected = i;
  //   });
  // }
}

class SecretContactsDrawer extends StatelessWidget {
  const SecretContactsDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String year = date.year.toString();
    return Drawer(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: kSecondaryColor,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height - 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height -
                getProportionateScreenHeight(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(40),
                ),
                Text(
                  AppLocalizations.of(context).secretContacts,
                  style: kTextStyleWhiteBodyMedium.copyWith(
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.0,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(12.5),
                ),
                Container(
                  child: SingleChildScrollView(
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: Global.appRef.userAppData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<dynamic> myList =
                                snapshot.data.data()['hideContacts'];
                            print(myList.toString());
                            if (myList.length == 0) {
                              return Container(
                                height: getProportionateScreenHeight(300),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .noSecretContacts,
                                    style: kTextStyleWhiteBodyMediumCursiva
                                        .copyWith(fontSize: 20),
                                    textScaleFactor: 1.0,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                height: getProportionateScreenHeight(500),
                                width: getProportionateScreenWidth(300),
                                child: ListView.builder(
                                  itemCount: myList.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.5),
                                      height: getProportionateScreenHeight(45),
                                      width: getProportionateScreenWidth(80),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.5, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white.withOpacity(0.75),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          return Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatDetailPage(
                                                      image: myList[i]
                                                          ['photoUrl'],
                                                      userName: myList[i]
                                                          ['userName'],
                                                      userUid: myList[i]['uid'],
                                                      fav: myList[i]['fav']),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 80,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: kPrimaryColor),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                  top: 5,
                                                  left: 5,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      final uid =
                                                          await Provider.of(
                                                                  context)
                                                              .auth
                                                              .getCurrentUID();
                                                      await DatabaseMethods()
                                                          .showContact(
                                                              uid: uid,
                                                              contact:
                                                                  myList[i]);
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/icons/visibility.svg',
                                                            height: 22.8,
                                                            width: 22.8,
                                                            color:
                                                                Colors.white),
                                                        SvgPicture.asset(
                                                            'assets/icons/visibility.svg',
                                                            height: 21,
                                                            width: 21,
                                                            color:
                                                                Colors.black),
                                                        SvgPicture.asset(
                                                          'assets/icons/visibility.svg',
                                                          height: 19,
                                                          width: 19,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              Positioned(
                                                  top: 5,
                                                  right: 5,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      final uid =
                                                          await Provider.of(
                                                                  context)
                                                              .auth
                                                              .getCurrentUID();
                                                      await DatabaseMethods()
                                                          .removeHideContact(
                                                              uid: uid,
                                                              contact:
                                                                  myList[i]);
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .delete_outline_sharp,
                                                            color: Colors.white,
                                                            size: 20.5),
                                                        Icon(
                                                            Icons
                                                                .delete_outline_sharp,
                                                            color: Colors.black,
                                                            size: 18.5),
                                                        Icon(
                                                            Icons
                                                                .delete_outline_sharp,
                                                            color: Colors.white,
                                                            size: 13.5),
                                                        // Icon(
                                                        //     Icons
                                                        //         .delete_outline_sharp,
                                                        //     color: Colors.black,
                                                        //     size: 13.5),
                                                      ],
                                                    ),
                                                  )),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        getProportionateScreenWidth(
                                                            30)),
                                                width:
                                                    getProportionateScreenWidth(
                                                        175),
                                                child: Center(
                                                  child: Text(
                                                    myList[i]['userName'],
                                                    textScaleFactor: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: kTextStyleBodyMedium,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          } else {
                            return SizedBox();
                          }
                        }),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(35),
                ),
                Container(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context).copyRight(year),
                      style: kTextStyleWhiteSmallLetter,
                      textAlign: TextAlign.center,
                      textScaleFactor: 0.75,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
