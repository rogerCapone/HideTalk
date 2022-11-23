// import 'package:flutter/material.dart';
// import 'package:hide_talk/pages/log/register/register_screen.dart';
// import 'package:hide_talk/shared/constants.dart';
// import 'package:hide_talk/shared/size_config.dart';
// import 'package:hide_talk/widgets/animations/bonucyTrans.dart';
// import 'package:video_player/video_player.dart';

// class PromoVideo extends StatefulWidget {
//   PromoVideo({Key key}) : super(key: key);

//   @override
//   _PromoVideoState createState() => _PromoVideoState();
// }

// class _PromoVideoState extends State<PromoVideo> {
//   bool finished = false;
//   VideoPlayerController controller;
//   @override
//   void initState() {
//     super.initState();
//     controller = VideoPlayerController.network(
//       'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FCorp%2FHTBoom.mp4?alt=media&token=8d96177a-d9b5-4864-b78c-b856be44657e',
//     )..initialize().then((_) {
//         setState(() {
//           // finished = true;
//         });
//       });
//     controller.play();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: kSecondaryColor,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: VideoPlayer(
//                 controller,
//               ),
//             ),
//             finished == true
//                 ? Container(
//                     width: getProportionateScreenWidth(250),
//                     height: getProportionateScreenHeight(100),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               finished = !finished;
//                             });
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                                 color: kSecondaryColor.withOpacity(0.85),
//                                 shape: BoxShape.circle),
//                             child: Icon(
//                               Icons.replay_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: getProportionateScreenWidth(25)),
//                         GestureDetector(
//                           onTap: () {
//                             return Navigator.push(
//                                 context, BouncyTrans(widget: SignUpScreen()));
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                                 color: kSecondaryColor.withOpacity(0.85),
//                                 shape: BoxShape.circle),
//                             child: Icon(
//                               Icons.replay_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : SizedBox()
//           ],
//         ),
//       ),
//     );
//   }
// }
