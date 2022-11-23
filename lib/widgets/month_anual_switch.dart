import 'package:flutter/material.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonthAnualSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const MonthAnualSwitch(
      {Key key, this.value, this.onChanged, this.activeColor})
      : super(key: key);

  @override
  _MonthAnualSwitchState createState() => _MonthAnualSwitchState();
}

class _MonthAnualSwitchState extends State<MonthAnualSwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 120));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.fastLinearToSlowEaseIn));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }

            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          onHorizontalDragStart: (drag) {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 135.0,
            height: 45.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: _circleAnimation.value == Alignment.centerLeft
                    ? kSecondaryColor.withOpacity(0.9)
                    : widget.activeColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _circleAnimation.value == Alignment.centerRight
                    ? Padding(
                        padding: const EdgeInsets.only(left: 9.5, right: 9.5),
                        child: Text(AppLocalizations.of(context).monthly,
                            style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                      )
                    : Container(),
                Align(
                  alignment: _circleAnimation.value,
                  child: Container(
                    width: 25.0,
                    height: 25.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                ),
                _circleAnimation.value == Alignment.centerLeft
                    ? Padding(
                        padding: const EdgeInsets.only(left: 9.5, right: 9.5),
                        child: Text(AppLocalizations.of(context).anual,
                            style: kTextStyleWhiteBodyMediumCursiva.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
