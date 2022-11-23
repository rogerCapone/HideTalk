import 'package:flutter/material.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';

class PlansBody extends StatelessWidget {
  const PlansBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                color: kPrimaryColor,
              ),
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 40),
              child: Container(
                  height: getProportionateScreenHeight(100),
                  width: getProportionateScreenWidth(100),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: SizedBox()
                  // StreamBuilder(
                  //   stream: Global.appRef.userAppData,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return Text(
                  //           snapshot.data.data()['activeSubscription'] == ''
                  //               ? 'Noob Plan'
                  //               : snapshot.data.data()['activeSubscription']);
                  //     } else {
                  //       return SizedBox();
                  //     }
                  //   },
                  // ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
