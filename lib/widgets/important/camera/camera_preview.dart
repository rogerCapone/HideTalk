import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:hide_talk/shared/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hide_talk/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final File imgFile;
  final String userUid;
  final String userName;
  final String senderPic;
  final int camera;

  const PreviewScreen({
    Key key,
    this.imgPath,
    this.imgFile,
    this.userUid,
    this.userName,
    this.senderPic,
    this.camera,
  }) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of(context).auth;
    String imgUrl;

    final firebase_storage.FirebaseStorage _storage =
        firebase_storage.FirebaseStorage.instanceFor(
            bucket: 'gs://hide-talk.appspot.com');
    firebase_storage.UploadTask _uploadTask;
    Future<bool> _startUpload(File file) async {
      final uid = await auth.getCurrentUID();
      String filePath =
          '/HideTalk/HotImg/$uid.${DateTime.now().millisecondsSinceEpoch}.png';
      try {
        _uploadTask = _storage.ref().child(filePath).putFile(file);
        firebase_storage.TaskSnapshot storageSnapshot = await _uploadTask;
        Navigator.pop(context, true);

        var downloadUrl = await storageSnapshot.ref.getDownloadURL();
        imgUrl = downloadUrl;
        setState(() {});
        return true;
      } catch (e) {
        return false;
      }
    }

    return Scaffold(
      body: widget.camera == 1
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: kSecondaryColor,
              child: Stack(
                children: <Widget>[
                  // RotatingWidget(
                  //   rotateX: true,
                  //   angleRadianX: pi,
                  //   autoplay: true,
                  //   duration: Duration(seconds: 2),
                  // child:
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.file(
                        File(widget.imgPath),
                        fit: BoxFit.cover,
                      ),
                      // ),
                    ),
                  ),

                  Positioned(
                    top: getProportionateScreenHeight(50),
                    left: getProportionateScreenHeight(25),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, true),
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
                  loading == false
                      ? SizedBox()
                      : Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: kSecondaryColor.withOpacity(0.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.2,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Encriptando Imagen',
                                style: kTextStyleWhiteBodyMediumCursiva,
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                  loading == true
                      ? SizedBox()
                      : Positioned(
                          bottom: 20,
                          right: 20,
                          child: FloatingActionButton(
                            //!COMENÇAR LA ANIMACIÓ DE ENVIAR MISSATGE
                            child: Transform.rotate(
                              angle: 1 / 2 * -pi,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              //!Enviar Photo--> firebase crear database.dart --> send picture
                              final uid = await Provider.of(context)
                                  .auth
                                  .getCurrentUID();
                              setState(() {
                                loading = true;
                              });
                              print(loading);
                              //*Setstate --> pagina carreganse, o una animació de que la pantalla pugi acorde
                              //* a un temps rollo complete (ficar un container partit)
                              // File file = await getCachedImageFile(widget.imgPath);
                              final result = await _startUpload(widget.imgFile);
                              //!Eliminar la foto del dispositiu
                              if (result == true) {
                                await DatabaseMethods().sendHideImg(
                                    payload: '',
                                    sendAt:
                                        DateTime.now().millisecondsSinceEpoch,
                                    sendBy: uid,
                                    sendTo: widget.userUid,
                                    sendByName: widget.userName,
                                    image: true,
                                    imageUrl: imgUrl,
                                    senderPic: widget.senderPic);
                              } else {
                                //!Something was wrong

                              }
                              // getBytesFromFile().then((bytes) {
                              //   // Share.file('Share via', basename(widget.imgPath), bytes.buffer.asUint8List(),'image/path');
                              // });
                              // await DatabaseMethods().sendHideImage(uid:uid, widget.imgPath);

                              //!Atenció eliminar captures (not possible (?))
                            },
                            backgroundColor: kPrimaryColor.withOpacity(0.45),
                            elevation: 10,
                          ),
                        ),
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: kSecondaryColor,
              child: Stack(
                children: <Widget>[
                  // RotatingWidget(
                  //   rotateX: true,
                  //   angleRadianX: pi,
                  //   autoplay: true,
                  //   duration: Duration(seconds: 2),
                  // child:
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      File(widget.imgPath),
                      fit: BoxFit.cover,
                    ),
                    // ),
                  ),

                  Positioned(
                    top: getProportionateScreenHeight(50),
                    left: getProportionateScreenHeight(25),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, true),
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
                  loading == false
                      ? SizedBox()
                      : Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: kSecondaryColor.withOpacity(0.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.2,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Encriptando Imagen', //AppLo
                                style: kTextStyleWhiteBodyMediumCursiva,
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                  loading == true
                      ? SizedBox()
                      : Positioned(
                          bottom: 20,
                          right: 20,
                          child: FloatingActionButton(
                            //!COMENÇAR LA ANIMACIÓ DE ENVIAR MISSATGE
                            child: Transform.rotate(
                              angle: 1 / 2 * -pi,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              //!Enviar Photo--> firebase crear database.dart --> send picture
                              final uid = await Provider.of(context)
                                  .auth
                                  .getCurrentUID();
                              setState(() {
                                loading = true;
                              });
                              print(loading);
                              //*Setstate --> pagina carreganse, o una animació de que la pantalla pugi acorde
                              //* a un temps rollo complete (ficar un container partit)
                              // File file = await getCachedImageFile(widget.imgPath);
                              final result = await _startUpload(widget.imgFile);
                              //!Eliminar la foto del dispositiu
                              if (result == true) {
                                await DatabaseMethods().sendHideImg(
                                    payload: '',
                                    sendAt:
                                        DateTime.now().millisecondsSinceEpoch,
                                    sendBy: uid,
                                    sendTo: widget.userUid,
                                    sendByName: widget.userName,
                                    image: true,
                                    imageUrl: imgUrl,
                                    senderPic: widget.senderPic);
                              } else {
                                //!Something was wrong

                              }
                              // getBytesFromFile().then((bytes) {
                              //   // Share.file('Share via', basename(widget.imgPath), bytes.buffer.asUint8List(),'image/path');
                              // });
                              // await DatabaseMethods().sendHideImage(uid:uid, widget.imgPath);

                              //!Atenció eliminar captures (not possible (?))
                            },
                            backgroundColor: kPrimaryColor.withOpacity(0.45),
                            elevation: 10,
                          ),
                        ),
                ],
              ),
            ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      // floatingActionButton:
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }
}
