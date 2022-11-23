import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hide_talk/pages/legal/privacyPolicy.dart';
import 'package:hide_talk/pages/legal/termsAndConditions.dart';
import 'package:hide_talk/pages/pinPage/setUpPin.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/animations/bottomTrans.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:hide_talk/widgets/default_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'complete_profile_form.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UploadPicBody extends StatefulWidget {
  @override
  _UploadPicBodyState createState() => _UploadPicBodyState();
}

class _UploadPicBodyState extends State<UploadPicBody> {
  String imgUrl;
  bool loaded = false;
  bool started = false;
  File _image;
  String randomPic;

  Future getImage() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      started = true;
      _image = File(image.path);
    });
  }

  void _startUpload(File file) async {
    final firebase_storage.FirebaseStorage _storage =
        firebase_storage.FirebaseStorage.instanceFor(
            bucket: 'gs://hide-talk.appspot.com/');
    firebase_storage.UploadTask _uploadTask;
    String filePath =
        'HideTalk/Profile/${file.path.substring(2, 5)}${DateTime.now()}.png';
    loaded = false;
    _uploadTask = _storage.ref().child(filePath).putFile(file);

    firebase_storage.TaskSnapshot storageSnapshot = await _uploadTask;
    try {
      var downloadUrl = await _storage.ref().child(filePath).getDownloadURL();

      imgUrl = downloadUrl;
      setState(() {
        loaded = true;
      });
    } on firebase_core.FirebaseException catch (e) {
      print('error caught: $e');
    }
    print(loaded);
    print(imgUrl);

    print(imgUrl);
  }

  String takeRandomUrl() {
    Random rnd;
    int min = 1;
    int max = 10;
    rnd = new Random();
    int r = min + rnd.nextInt(max - min);
    // print(r.toString());
    switch (r) {
      case 1:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F1.png?alt=media&token=4ae51f50-e491-4310-babe-a57500bf36c6';
      case 2:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F2.png?alt=media&token=c59ec892-46b2-4d4b-aaa3-324ccfe61692';
      case 3:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F3.png?alt=media&token=710a48ef-cbd2-40a2-a37d-bb4b71f49e05';
      case 4:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F4.png?alt=media&token=3984c770-59ac-4343-aa5e-77c739f089c5';
      case 5:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F5.png?alt=media&token=cb1be8b7-500d-4546-826f-c2cf1e64d982';
      case 6:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F6.png?alt=media&token=dd4d14e2-a527-4fe4-9bbf-758b4b9ee999';
      case 7:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F7.png?alt=media&token=e9b75367-eebe-42be-8472-43af8e81ba97';
      case 8:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F8.png?alt=media&token=220bf14f-2f0b-4554-96b4-4ff4a214fc78';
      case 9:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F9.png?alt=media&token=e4eca813-4c99-4083-91c6-c13531efbc3a';
      case 10:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2F10.png?alt=media&token=0a378e1f-d0f1-4bbe-a1eb-9faa867d54eb';

      default:
        return 'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2Fano.jpeg?alt=media&token=5cbca437-88c8-4448-8548-ff958da006da';
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     randomPic = takeRandomUrl();
  //     print(randomPic);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;
    // // final profile = Provider.of(context).profile;
    randomPic = takeRandomUrl();
    // print(randomPic);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: kSecondaryColor,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Text(
                    AppLocalizations.of(context).imgContact,
                    style: kTextStyleWhiteBodyBig,
                    textScaleFactor: 1.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      AppLocalizations.of(context).getLucky,
                      textScaleFactor: 1.0,
                      style: kTextStyleWhiteBodyMediumCursiva,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        randomPic = takeRandomUrl();
                        started = false;
                      });
                    },
                    child: Container(
                        height: 45,
                        width: double.infinity,
                        padding: EdgeInsets.only(right: 15.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  shape: BoxShape.circle),
                              child: Center(
                                  child: Text(
                                "🍀",
                                style: kTextStyleWhiteBodyMedium,
                              )),
                            )
                          ],
                        )),
                  ),
                  Container(
                    height: getProportionateScreenHeight(250),
                    width: getProportionateScreenWidth(250),
                    child: InkWell(
                        onTap: () {
                          try {
                            print('tap');
                            getImage().whenComplete(() => _startUpload(_image));
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? NetworkImage(randomPic ??
                                      'https://firebasestorage.googleapis.com/v0/b/hide-talk.appspot.com/o/HideTalk%2FDefault%2Fano.jpeg?alt=media&token=5cbca437-88c8-4448-8548-ff958da006da') //AssetImage('assets/images/ano.jpeg')
                                  : FileImage(_image),
                              fit: _image == null
                                  ? BoxFit.scaleDown
                                  : BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                          ),
                        )),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  (started == false || loaded != false)
                      ? DefaultButton(
                          text: AppLocalizations.of(context).continuee,
                          press: () async {
                            //Guardarla a Cloud Storage i tot ready per la app

                            final uid = await auth.getCurrentUID();
                            await DatabaseMethods().uploadUserImg(
                                uid: uid,
                                imgUrl: imgUrl == null ? randomPic : imgUrl);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SetPersonalPin()));
                            // Navigator.pushNamed(context, OtpScreen.routeName);
                          },
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: getProportionateScreenHeight(56),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: kPrimaryColor.withOpacity(0.4),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  AppLocalizations.of(context).waitUntilLoading,
                                  style: kTextStyleWhiteBodyMedium,
                                  textScaleFactor: 1.0,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: getProportionateScreenHeight(20),
                                  width: getProportionateScreenHeight(20),
                                  child: CircularProgressIndicator(),
                                )
                              ],
                            ),
                          ),
                        ),
                  // : SizedBox(
                  //     width: double.infinity,
                  //     height: getProportionateScreenHeight(56),
                  //     child: FlatButton(
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20)),
                  //       color: kPrimaryColor.withOpacity(0.35),
                  //       onPressed: () {
                  //         print('SHIT');
                  //       },
                  //       child: Text(
                  //         'Upload a Picture 😎',
                  //         style: TextStyle(
                  //           fontSize: getProportionateScreenWidth(18),
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Text(
                    AppLocalizations.of(context).startAccept,
                    textAlign: TextAlign.center,
                    style: kTextStyleWhiteSmallLetter.copyWith(
                        fontWeight: FontWeight.w200),
                    textScaleFactor: 1.0,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditions())),
                        child: Text(
                          AppLocalizations.of(context).termsAndCo,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: kTextStyleWhiteSmallLetter.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        )),
                    Text(
                      AppLocalizations.of(context).and,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.0,
                      style: kTextStyleWhiteSmallLetter,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicy())),
                      child: Text(AppLocalizations.of(context).privacyPolicy,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: kTextStyleWhiteSmallLetter.copyWith(
                            decoration: TextDecoration.underline,
                          )),
                    )
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
