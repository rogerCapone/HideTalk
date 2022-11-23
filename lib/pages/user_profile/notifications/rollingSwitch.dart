library my_rolling_switch;

import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hide_talk/shared/constants.dart';

/// Customable and attractive Switch button.
/// Currently, you can't change the widget
/// width and height properties.
///
/// As well as the classical Switch Widget
/// from flutter material, the following
/// arguments are required:
///
/// * [value] determines whether this switch is on or off.
/// * [onChanged] is called when the user toggles the switch on or off.
///
/// If you don't set these arguments you would
/// experiment errors related to animationController
/// states or any other undesirable behavior, please
/// don't forget to set them.
///
class MyRollingSwitch extends StatefulWidget {
  @required
  final bool value;
  @required
  final Function(bool) onChanged;
  final String textOff;
  final String textOn;
  final Color colorOn;
  final Color colorOff;
  final double width;
  final double height;
  final double textSize;
  final double iconSize;
  final Duration animationDuration;
  final IconData iconOn;
  final IconData iconOff;
  final Function onTap;
  final Function onDoubleTap;
  final Function onSwipe;

  MyRollingSwitch(
      {this.value = false,
      this.textOff = "Off",
      this.textOn = "On",
      this.textSize = 14.0,
      this.colorOn = Colors.green,
      this.colorOff = Colors.red,
      this.iconOff = Icons.flag,
      this.iconOn = Icons.check,
      this.animationDuration = const Duration(milliseconds: 600),
      this.onTap,
      this.onDoubleTap,
      this.onSwipe,
      this.onChanged,
      this.height,
      this.width,
      this.iconSize});

  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<MyRollingSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  double value = 0.0;

  bool turnState;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: widget.animationDuration);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
    turnState = widget.value;
    _determine();
  }

  @override
  Widget build(BuildContext context) {
    Color transitionColor = Color.lerp(widget.colorOff, widget.colorOn, value);

    return GestureDetector(
      onDoubleTap: () {
        _action();
        if (widget.onDoubleTap != null) widget.onDoubleTap();
      },
      onTap: () {
        _action();
        if (widget.onTap != null) widget.onTap();
      },
      onPanEnd: (details) {
        _action();
        if (widget.onSwipe != null) widget.onSwipe();
        //widget.onSwipe();
      },
      child: Container(
        padding: EdgeInsets.all(20),
        width: widget.width,
        decoration: BoxDecoration(
            color: kSecondaryColor, borderRadius: BorderRadius.circular(50)),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(10 * value, 0), //original
              child: Opacity(
                opacity: (1 - value).clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: 0.5 * pi,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.only(right: 10),
                    alignment: Alignment.topRight,
                    height: widget.height,
                    child: Text(
                      widget.textOff,
                      textScaleFactor: 1.0,
                      style: kTextStyleWhiteBodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(10 * (1 - value), 0), //original
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: 0.5 * pi,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.only(/*top: 10,*/ left: 5),
                    alignment: Alignment.topRight,
                    height: widget.height,
                    child: Text(
                      widget.textOn,
                      textScaleFactor: 1.0,
                      style: kTextStyleWhiteBodyMedium.copyWith(
                          color: kPrimaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(80 * value, 0),
              child: Transform.rotate(
                angle: lerpDouble(0, 2 * pi, value),
                child: Container(
                  height: widget.height,
                  width: widget.width,
                  margin: EdgeInsets.all(25),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Opacity(
                          opacity: (1 - value).clamp(0.0, 1.0),
                          child: Transform.rotate(
                            angle: -pi * 0.5,
                            child: SvgPicture.asset(
                              'assets/icons/off.svg',
                              color: kSecondaryColor,
                              width: widget.iconSize,
                            ),
                          ),

                          // Icon(
                          //   widget.iconOff,
                          //   size: widget.iconSize,
                          //   color: transitionColor,
                          // ),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: value.clamp(0.5, 1.0),
                          child: Transform.rotate(
                            angle: -pi * 0.5,
                            child: SvgPicture.asset(
                              'assets/icons/off.svg',
                              color: Colors.white,
                              width: widget.iconSize,
                            ),
                          ),
                          // Icon(
                          //   widget.iconOn,
                          //   size: widget.iconSize,
                          //   color: transitionColor,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(80 * value, 0),
              child: Transform.rotate(
                angle: lerpDouble(0, 2 * pi, value),
                child: Container(
                  height: widget.height,
                  width: widget.width,
                  margin: EdgeInsets.all(26.5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: kSecondaryColor),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Opacity(
                          opacity: (1 - value).clamp(0.0, 1.0),
                          child: Transform.rotate(
                            angle: -pi * 0.5,
                            child: SvgPicture.asset(
                              'assets/icons/off.svg',
                              color: Colors.white.withOpacity(0.65),
                              width: widget.iconSize,
                            ),
                          ),

                          // Icon(
                          //   widget.iconOff,
                          //   size: widget.iconSize,
                          //   color: transitionColor,
                          // ),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Transform.rotate(
                            angle: -pi * 0.5,
                            child: SvgPicture.asset(
                              'assets/icons/off.svg',
                              color: kPrimaryColor,
                              width: widget.iconSize,
                            ),
                          ),
                          // Icon(
                          //   widget.iconOn,
                          //   size: widget.iconSize,
                          //   color: transitionColor,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _action() {
    _determine(changeState: true);
  }

  _determine({bool changeState = false}) {
    setState(() {
      if (changeState) turnState = !turnState;
      (turnState)
          ? animationController.forward()
          : animationController.reverse();

      widget.onChanged(turnState);
    });
  }
}
