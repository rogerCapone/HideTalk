import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../shared/constants.dart';
import '../../../shared/constants.dart';

class HideImage extends StatelessWidget {
  final String imgUrl;
  final String userName;
  final DateTime sendAt;
  final String senderPic;
  final String payload;
  final int camera;
  const HideImage(
      {Key key,
      this.camera,
      this.imgUrl,
      this.userName,
      this.sendAt,
      this.senderPic,
      this.payload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final uid = await Provider.of(context).auth.getCurrentUID();
        try {
          //! Eliminar la foto del bucket

          //!Eliminar el missatge
          await DatabaseMethods()
              .deleteHotImage(mails: [payload], imgPath: imgUrl, uid: uid);
          Navigator.pop(context, true);
          return true;
        } catch (e) {
          return false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: kSecondaryColor,
              child: Image.network(
                imgUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 0.4,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                      Text(
                        'Decrypting Image', //AppLocalizations.of(context).decryptImage,
                        textScaleFactor: 1.0,
                        style: kTextStyleWhiteBodyMediumCursiva,
                      ) //AppLocalizations.of(context).decryptImage,
                    ],
                  );
                },
              ),
            ),
            Positioned(
                top: 35,
                left: 20,
                child: Row(children: [
                  Container(
                    height: getProportionateScreenHeight(65),
                    width: getProportionateScreenHeight(65),
                    decoration: BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.circle),
                    child: ExtendedImage.network(
                      senderPic,
                      height: getProportionateScreenHeight(60),
                      width: getProportionateScreenHeight(60),

                      fit: BoxFit.cover,
                      cache: true,
                      shape: BoxShape.circle,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      //cancelToken: cancellationToken,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    userName,
                    style: kTextStyleWhiteBodyMedium,
                    textScaleFactor: 1.0,
                  ),
                ])),
            Positioned(
              left: 20,
              bottom: 30,
              child: GestureDetector(
                onTap: () async {
                  final uid = await Provider.of(context).auth.getCurrentUID();

                  await DatabaseMethods().deleteHotImage(
                      mails: [payload], imgPath: imgUrl, uid: uid);
                  Navigator.pop(context, true);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/Back ICon.svg',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: Container(
                height: 100,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sendAt.day.toString() +
                          '/' +
                          sendAt.month.toString() +
                          '/' +
                          sendAt.year.toString(),
                      style: kTextStyleWhiteBodyMedium,
                      textScaleFactor: 1.0,
                    ),
                    SizedBox(
                      height: 8.5,
                    ),
                    Text(
                      sendAt.hour.toString() +
                          ':' +
                          sendAt.minute.toString() +
                          ':' +
                          sendAt.second.toString(),
                      style: kTextStyleWhiteBodyMediumCursiva,
                      textScaleFactor: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
