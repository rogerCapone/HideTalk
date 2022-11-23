import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/custom_surfix_icon.dart';
import 'package:hide_talk/widgets/default_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatSettingsPage extends StatefulWidget {
  final String image;
  final String userUid;
  final String userName;
  final bool fav;

  const ChatSettingsPage(
      {Key key, this.image, this.userUid, this.userName, this.fav})
      : super(key: key);

  @override
  _ChatSettingsPageState createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  TextEditingController nameController = TextEditingController();
  String imgUrl;
  bool _contactUpload = false;
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
      String filePath = '/HideTalk/Contacts/$uid||${DateTime.now()}.png';

      _loaded = false;
      setState(() async {
        _contactUpload = true;
        _uploadTask = _storage.ref().child(filePath).putFile(_image);
        firebase_storage.TaskSnapshot storageSnapshot = await _uploadTask;

        var downloadUrl = await storageSnapshot.ref.getDownloadURL();
        imgUrl = downloadUrl;
        print(imgUrl);

        print('this is the URL i am seeting');
        final result = await DatabaseMethods().changeContactImage(
            uid: uid,
            imgUrl: imgUrl,
            oldImg: widget.image,
            contactUid: widget.userUid,
            userName: widget.userName,
            fav: widget.fav);

        Navigator.pop(context);
        Navigator.pop(context);
      });
      print(imgUrl);
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
        color: kSecondaryColor,
        child: _contactUpload == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: getProportionateScreenHeight(65),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: getProportionateScreenWidth(15),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: getProportionateScreenHeight(45),
                              width: getProportionateScreenHeight(45),
                              padding: EdgeInsets.all(14.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                'assets/icons/Back ICon.svg',
                                color: Colors.white,
                              )),
                            ),
                          ),
                        ],
                      )),
                  Stack(
                    children: [
                      Container(
                          height: getProportionateScreenWidth(175),
                          width: getProportionateScreenWidth(175),
                          child: Hero(
                            tag: widget.image,
                            child: ExtendedImage.network(
                              widget.image,
                              alignment: Alignment.center,

                              fit: BoxFit.cover,
                              cache: true,
                              shape: BoxShape.circle,
                              //cancelToken: cancellationToken,
                            ),
                          )),
                      Positioned(
                        right: 10,
                        bottom: 0,
                        child: SizedBox(
                          height: getProportionateScreenHeight(55),
                          width: getProportionateScreenHeight(55),
                          child: GestureDetector(
                            onTap: () async {
                              await getImage()
                                  .whenComplete(() => _startUpload(_image));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 17),
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
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.userName,
                    style: kTextStyleWhiteBodyMedium.copyWith(
                        fontSize: 35, fontWeight: FontWeight.bold),
                    textScaleFactor: 1.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildUserNameFormField(),
                      SizedBox(height: getProportionateScreenHeight(22.5)),
                      SizedBox(height: getProportionateScreenHeight(12.5)),
                      DefaultButton(
                        text: AppLocalizations.of(context).changeContactName,
                        press: () async {
                          final uid =
                              await Provider.of(context).auth.getCurrentUID();
                          //Guardar la informació FIREBASE DATABASE

                          final result =
                              await DatabaseMethods().updateContactName(
                            uid: uid,
                            contactUid: widget.userUid,
                            fav: widget.fav,
                            photoUrl: widget.image,
                            userName: widget.userName,
                            newName: nameController.text,
                          );

                          if (result == true) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.white,
                              content: Text(
                                widget.userName +
                                    AppLocalizations.of(context).notYourContact,
                                style: kTextStyleSmallLetter,
                                textAlign: TextAlign.center,
                              ),
                              // action: SnackBarAction(
                              //   label: 'Undo',
                              //   onPressed: () {},
                              // ),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }

                          // print('Should be uploaded');

                          // Navigator.pop(context, {
                          //   'message': 'Sabia decisión $newName 🤘🏻😏',
                          //   'error': false
                          // });
                          // Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 0.4,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context).modifyingContact,
                    style: kTextStyleWhiteBodyMediumCursiva,
                    textScaleFactor: 1.0,
                  )
                ],
              ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      // floatingActionButton: Container(
      //   margin: EdgeInsets.symmetric(vertical: 20),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.orange,
      //     onPressed: () => Navigator.pop(context),
      //     child: CustomSurffixIcon(svgIcon: 'assets/icons/Back ICon.svg'),
      //   ),
      // ),
    );
  }

  MediaQuery buildUserNameFormField() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
      child: TextFormField(
        controller: nameController,
        // onSaved: (newValue) => newName = newValue,
        // onChanged: (value) {
        //   newName = value;
        // },
        style: kTextStyleWhiteBodyMedium.copyWith(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w400),
          hintStyle: kTextStyleWhiteBodyMediumCursiva.copyWith(
              fontWeight: FontWeight.w200),
          labelText: AppLocalizations.of(context).newContactName,
          hintText: AppLocalizations.of(context).newContactName,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(30),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(30),
          ),
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(
              color: Colors.orange, svgIcon: "assets/icons/User.svg"),
        ),
      ),
    );
  }
}
