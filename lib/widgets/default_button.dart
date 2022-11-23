import 'package:flutter/material.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(22.5)),
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
          color: kPrimaryColor,
          onPressed: press,
          child: Text(
            text,
            style: kTextStyleBodyMedium.copyWith(fontWeight: FontWeight.w700),
            textScaleFactor: 0.85,
          ),
        ),
      ),
    );
  }
}
