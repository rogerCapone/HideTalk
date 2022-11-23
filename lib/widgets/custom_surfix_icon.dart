import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hide_talk/shared/size_config.dart';

class CustomSurffixIcon extends StatelessWidget {
  const CustomSurffixIcon({Key key, @required this.svgIcon, this.color})
      : super(key: key);

  final String svgIcon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: SvgPicture.asset(
        svgIcon,
        color: color ?? Colors.black,
        height: getProportionateScreenWidth(25),
      ),
    );
  }
}
