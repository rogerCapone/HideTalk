import 'package:flutter/material.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';

class HideTalkInfo extends StatelessWidget {
  const HideTalkInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(45),
            ),
            TextsComboStack(),
            SizedBox(
              height: getProportionateScreenHeight(100),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: TextsComboHashTag(
                    text: ' #FeelSafe', align: TextAlign.left)),
            SizedBox(
              height: 19,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextsComboHashTag(
                    text: '#FeelHide', align: TextAlign.left)),
            SizedBox(
              height: 19,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: TextsComboHashTag(
                    text: '  #' + AppLocalizations.of(context).recoverControl,
                    align: TextAlign.left)),
            SizedBox(
              height: 19,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextsComboHashTag(text: '#Hide', align: TextAlign.left)),
            SizedBox(
              height: 19,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: TextsComboHashTag(
                    text: '  #' + AppLocalizations.of(context).myHides,
                    align: TextAlign.left)),
            SizedBox(
              height: getProportionateScreenHeight(85),
            ),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextsComboHashTagColor(
                      text: 'IG:  ',
                      align: TextAlign.center,
                      color: Colors.orange,
                    ),
                    TextsComboHashTag(
                        text: '@_HideTalk_', align: TextAlign.center),
                  ],
                )),
            SizedBox(
              height: 19,
            ),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextsComboHashTagColor(
                        text: 'Twitter:  ',
                        align: TextAlign.center,
                        color: Colors.orange),
                    TextsComboHashTag(
                        text: '@HideTalk', align: TextAlign.center),
                  ],
                )),
            SizedBox(
              height: 19,
            ),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextsComboHashTagColor(
                      text: 'Web:  ',
                      align: TextAlign.center,
                      color: Colors.orange,
                    ),
                    TextsComboHashTag(
                        text: 'www.hidetalks.com', align: TextAlign.center),
                  ],
                )),
            // Container(
            //     height: getProportionateScreenHeight(550),
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //             fit: BoxFit.contain,
            //             image: AssetImage('assets/images/hideInfo.jpg'))))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () => Navigator.pop(context),
          child: CustomSurffixIcon(svgIcon: 'assets/icons/Back ICon.svg'),
        ),
      ),
    );
  }
}

class TextsComboStack extends StatelessWidget {
  const TextsComboStack({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).hideTalk,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 32.5, fontWeight: FontWeight.w600),
        ),
        Text(
          AppLocalizations.of(context).hideTalk,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(fontSize: 33, color: Colors.white),
        ),
        Text(
          AppLocalizations.of(context).hideTalk,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 33.5, fontWeight: FontWeight.w600),
        ),
        Text(
          AppLocalizations.of(context).hideTalk,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          AppLocalizations.of(context).hideTalk,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 34.5, fontWeight: FontWeight.w600),
        ),
        Text(
          AppLocalizations.of(context).hideTalk,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          AppLocalizations.of(context).hideTalk,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 35, fontWeight: FontWeight.w600),
        ),
        Text(
          AppLocalizations.of(context).hideTalk,
          textScaleFactor: 0.75,
          style:
              kTextStyleBodyBig.copyWith(fontSize: 35.5, color: Colors.white),
        ),
      ],
    );
  }
}

class TextsComboHashTag extends StatelessWidget {
  const TextsComboHashTag({Key key, this.text, this.align}) : super(key: key);
  final text;
  final align;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 0.75,
          textAlign: align,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 29.5, fontWeight: FontWeight.w600),
        ),
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 0.75,
          textAlign: align,
          style:
              kTextStyleBodyBig.copyWith(fontSize: 29.8, color: Colors.white),
        ),
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textScaleFactor: 0.75,
          textAlign: align,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 30.1, fontWeight: FontWeight.w600),
        ),
        SelectableText(
          this.text,
          cursorColor: Colors.orange,
          textScaleFactor: 0.75,
          cursorRadius: Radius.circular(10),
          cursorWidth: 5.5,
          cursorHeight: 32,
          toolbarOptions: ToolbarOptions(copy: true),
          textAlign: align,
          style:
              kTextStyleBodyBig.copyWith(fontSize: 30.4, color: Colors.white),
        ),
      ],
    );
  }
}

class TextsComboHashTagColor extends StatelessWidget {
  const TextsComboHashTagColor({Key key, this.text, this.align, this.color})
      : super(key: key);
  final text;
  final align;
  final color;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textAlign: align,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 29.5, fontWeight: FontWeight.w600),
        ),
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textAlign: align,
          textScaleFactor: 0.75,
          style:
              kTextStyleBodyBig.copyWith(fontSize: 29.8, color: Colors.white),
        ),
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textAlign: align,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 30.1, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textAlign: align,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 29.8, fontWeight: FontWeight.w600, color: this.color),
        ),
        Text(
          this.text,
          overflow: TextOverflow.ellipsis,
          textAlign: align,
          textScaleFactor: 0.75,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 29.8,
              fontWeight: FontWeight.w200,
              color: kSecondaryColor),
        ),
      ],
    );
  }
}
