import 'package:flutter/cupertino.dart';

class BottomTrans extends PageRouteBuilder {
  final widget;
  BottomTrans({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 1200),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.easeOutQuart);
              return ScaleTransition(
                alignment: Alignment.bottomCenter,
                scale: animation,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
