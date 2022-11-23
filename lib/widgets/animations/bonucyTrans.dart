import 'package:flutter/cupertino.dart';

class BouncyTrans extends PageRouteBuilder {
  final widget;
  BouncyTrans({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 1350),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return ScaleTransition(
                alignment: Alignment.topCenter,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
