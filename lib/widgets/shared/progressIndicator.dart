// import 'dart:async';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:hide_talk/shared/constants.dart';
// import 'package:waveprogressbar_flutter/waveprogressbar_flutter.dart';

// class BezierCurveDemo extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return MyProgress();
//   }
// }

// class MyProgress extends State<BezierCurveDemo> {
//   // final TextEditingController _controller = new TextEditingController();
//   //默认初始值为0.0
//   double waterHeight = 0.0;
//   WaterController waterController = WaterController();
//   Timer timer;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding widgetsBinding = WidgetsBinding.instance;
//     widgetsBinding.addPostFrameCallback((callback) {
//       waterController.changeWaterHeight(waterHeight);
//     });
//     timer =
//         Timer.periodic(Duration(milliseconds: 120), (Timer t) => sumaUnNum());
//   }

//   void sumaUnNum() {
//     int minInt = 5;
//     int maxInt = 15;
//     double min = 5.2;
//     double max = 10;
//     Random rnd = new Random();
//     waterHeight = waterHeight + rnd.nextDouble() * rnd.nextInt(maxInt - minInt);
//     setState(() {});
//     print("$waterHeight is in the range of $min and $max");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 80.0),
//       child: new Center(
//         child: new WaveProgressBar(
//           flowSpeed: 2.0,
//           waveDistance: 45.0,
//           waterColor: kPrimaryColor,
//           //strokeCircleColor: Color(0x50e16009),
//           heightController: waterController,
//           percentage: waterHeight,
//           size: new Size(300, 300),
//           textStyle: new TextStyle(
//               color: Color(0x15000000),
//               fontSize: 60.0,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
