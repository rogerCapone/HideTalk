// import 'package:animations/animations.dart';
// import 'package:flutter/material.dart';
// import 'package:hide_talk/pages/log/login/a_login_screen.dart';
// import 'package:hide_talk/pages/user_profile/components/profile_menu.dart';
// import 'package:hide_talk/pages/user_profile/myAccount/myAccount.dart';
// import 'package:hide_talk/pages/user_profile/myAccount/myQr/myQR.dart';
// import 'package:hide_talk/pages/user_profile/myAccount/settings/security.dart';
// import 'package:hide_talk/services/provider.dart';
// import 'package:hide_talk/shared/constants.dart';
// import 'package:hide_talk/shared/size_config.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of(context).auth;
//     final transitionType = ContainerTransitionType.fadeThrough;

//     return Container(
//       height: getProportionateScreenHeight(MediaQuery.of(context).size.height),
//       width: MediaQuery.of(context).size.width,
//       color: kSecondaryColor,
//       child: SingleChildScrollView(
//         physics: AlwaysScrollableScrollPhysics(),
//         padding: EdgeInsets.symmetric(
//           vertical: getProportionateScreenHeight(30),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             // AvProfiles(),
//             Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                 child: OpenContainer(
//                   openColor: Colors.white,
//                   closedColor: kSecondaryColor,
//                   transitionType: transitionType,
//                   openElevation: 0.0,
//                   closedShape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                   openShape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                   transitionDuration: Duration(seconds: 1),
//                   openBuilder: (context, _) => MyAccountBody(),
//                   closedBuilder: (context, openContainer) => ProfileMenu(
//                       text: "Mi Información",
//                       icon: "assets/icons/info.svg",
//                       press: openContainer),
//                 )),
//             SizedBox(height: getProportionateScreenHeight(0.5)),

//             Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                 child: OpenContainer(
//                   openColor: Colors.white,
//                   closedColor: kSecondaryColor,
//                   transitionType: transitionType,
//                   openElevation: 0.0,
//                   closedShape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                   openShape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                   transitionDuration: Duration(seconds: 1),
//                   openBuilder: (context, _) => SecurityPage(),
//                   closedBuilder: (context, openContainer) => ProfileMenu(
//                       text: "Mi Seguridad",
//                       icon: "assets/icons/Lock.svg",
//                       press: openContainer),
//                 )),
//             SizedBox(height: getProportionateScreenHeight(0.5)),
//             Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                 child: OpenContainer(
//                   openColor: Colors.white,
//                   closedColor: kSecondaryColor,
//                   transitionType: transitionType,
//                   openElevation: 0.0,
//                   closedShape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                   openShape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0))),
//                   transitionDuration: Duration(seconds: 1),
//                   openBuilder: (context, _) => MyQR(),
//                   closedBuilder: (context, openContainer) => ProfileMenu(
//                       text: "Mi QR",
//                       icon: "assets/icons/qr.svg",
//                       press: openContainer),
//                 )),

//             SizedBox(height: getProportionateScreenHeight(1.5)),
//             Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                 child: Container(
//                   height: getProportionateScreenHeight(60),
//                   width: getProportionateScreenWidth(200),
//                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                   child: GestureDetector(
//                     onTap: () async {
//                       //! Abans fer que entri el pin
//                       await auth.delelteAccount();
//                       await auth.signOut();
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginScreen()),
//                         (Route<dynamic> route) => false,
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         color: Colors.red.withOpacity(0.75),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Eliminar Cuenta',
//                           style: kTextStyleWhiteBodyMediumCursiva,
//                           textScaleFactor: 1.0,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )),
//             SizedBox(
//               height: 15,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
