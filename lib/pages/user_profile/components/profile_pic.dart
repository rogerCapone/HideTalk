import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/globals.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key key,
  }) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  String imgUrl;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;

    bool _loaded = false;
    File _image;

    Future getImage() async {
      var image =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = File(image.path);
      });
    }

    final firebase_storage.FirebaseStorage _storage =
        firebase_storage.FirebaseStorage.instanceFor(
            bucket: 'gs://hide-talk.appspot.com');
    firebase_storage.UploadTask _uploadTask;

    void _startUpload(File file) async {
      final uid = await auth.getCurrentUID();
      String filePath = '/HideTalk/Profile/$uid||${DateTime.now()}.png';
      _loaded = false;
      setState(() async {
        _uploadTask = _storage.ref().child(filePath).putFile(_image);
        firebase_storage.TaskSnapshot storageSnapshot = await _uploadTask;

        var downloadUrl = await storageSnapshot.ref.getDownloadURL();
        imgUrl = downloadUrl;
        print(imgUrl);

        print('this is the URL i am seeting');
        await DatabaseMethods().changeUserImg(uid: uid, imgUrl: imgUrl);
        setState(() {});
        print(_loaded);
        _loaded = true;
        print(_loaded);
      });
      print(imgUrl);
    }

    return Container(
      height: getProportionateScreenHeight(235),
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder(
              stream: Global.userRef.userAppData,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data.data() != null) {
                  //! Aqui hauriem de determinar el USER GLOBAL
                  return Row(
                    children: [
                      Container(
                        height: getProportionateScreenWidth(200),
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.passthrough,
                          children: [
                            Positioned(
                              top: 0,
                              child: Container(
                                  height: getProportionateScreenHeight(200),
                                  width: getProportionateScreenHeight(200),
                                  child: ExtendedImage.network(
                                    snapshot.data.data()['photoUrl'],
                                    alignment: Alignment.center,

                                    fit: BoxFit.cover,
                                    cache: true,
                                    shape: BoxShape.circle,
                                    //cancelToken: cancellationToken,
                                  )),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                // color: Colors.orange,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                width: getProportionateScreenWidth(135),
                                child: Text(
                                  snapshot.data.data()['userName'],
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor: 0.85,
                                  style: kTextStyleWhiteBodyMedium.copyWith(
                                      fontSize: 25),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    height: 75,
                    width: 75,
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(5),
                        horizontal: getProportionateScreenHeight(25.5)),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kPrimaryColor),
                  );
                }
              }),
          Positioned(
            right: 20,
            top: 10,
            child: SizedBox(
              height: getProportionateScreenHeight(55),
              width: getProportionateScreenHeight(55),
              child: GestureDetector(
                onTap: () async {
                  await getImage().whenComplete(() => _startUpload(_image));

                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 17),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFFF5F6F9).withOpacity(0.6),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Camera Icon.svg",
                    color: kSecondaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
