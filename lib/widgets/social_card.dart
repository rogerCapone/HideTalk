import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hide_talk/shared/size_config.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({Key key, this.icon, this.press, this.google})
      : super(key: key);

  final String icon;
  final Function press;
  final bool google;

  @override
  Widget build(BuildContext context) {
    return google
        ? GestureDetector(
            onTap: press,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10)),
              padding: EdgeInsets.all(getProportionateScreenWidth(12)),
              height: getProportionateScreenHeight(70),
              width: getProportionateScreenWidth(70),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(icon),
            ),
          )
        : GestureDetector(
            onTap: press,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10)),
              padding: EdgeInsets.all(getProportionateScreenWidth(8.5)),
              height: getProportionateScreenHeight(70),
              width: getProportionateScreenWidth(70),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(icon),
            ),
          );
  }
}
