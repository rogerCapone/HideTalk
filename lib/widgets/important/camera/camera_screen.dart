import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xfile/xfile.dart' as myFile;

import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/widgets/important/camera/camera_preview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../custom_surfix_icon.dart';

class CameraScreen extends StatefulWidget {
  final String userUid;
  final String userName;
  final String senderPic;

  const CameraScreen({Key key, this.userUid, this.userName, this.senderPic})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  List cameras;
  int selectedCameraIndex;
  String imgPath;
  String path;
  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      print(cameras);
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  void _onCapturePressed({
    BuildContext context,
    String path,
    String senderPic,
    String userName,
    String userUid,
  }) async {
    try {
      Directory path = await getApplicationDocumentsDirectory();
      // await new Directory(path).create(recursive: true);
      // File file = await getCachedImageFile(path);
      // String filePath = path.path;
      // File file =
      //     new File('$filePath/${DateTime.now().millisecondsSinceEpoch}.png');
      //     file.writeAsString
      // print(file.existsSync());
      // file.absolute
      // print(file.absolute.path);
      XFile pic = await controller.takePicture();
      myFile.XFile coolFile = myFile.XFile.fromPath(pic.path);
      File imgFile = coolFile.toFile();
      print(imgFile.path);
      print(imgFile.path);
      print(imgFile.path);
      print(imgFile.path);
      print(imgFile.path);
      print(imgFile.path);
      print(imgFile.path);
      print(imgFile.path);
      print(imgFile.path);
      print(imgFile.path);
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewScreen(
                  imgPath: pic.path,
                  imgFile: imgFile,
                  senderPic: widget.senderPic,
                  userName: widget.userName,
                  userUid: widget.userUid,
                  camera: selectedCameraIndex)));
      if (result == true) {
        return Navigator.pop(context, true);
      }
    } catch (e) {
      _showCameraException(e);
    }
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: _cameraPreviewWidget(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 95,
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _cameraToggleRowWidget(),
                      // _cameraControlWidget(context),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  height: getProportionateScreenHeight(70),
                                  width: getProportionateScreenHeight(70),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.orange)),
                                  child: Container(
                                    height: getProportionateScreenHeight(50),
                                    width: getProportionateScreenHeight(50),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/hideTalk.png',
                                          ),
                                          // colorFilter: ColorFilter.mode(Colors.black),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _onCapturePressed(
                                    context: context,
                                    path: path,
                                    senderPic: widget.senderPic,
                                    userName: widget.userName,
                                    userUid: widget.userUid,
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Container(
        padding:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () async {
            Navigator.pop(context, true);
          },
          child: CustomSurffixIcon(svgIcon: 'assets/icons/Back ICon.svg'),
        ),
      ),
    );
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  /// Display the control bar with buttons to take pictures
  // Widget _cameraControlWidget(context) {
  //   return Expanded(
  //     child: Align(
  //       alignment: Alignment.center,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         mainAxisSize: MainAxisSize.max,
  //         children: <Widget>[
  //           FloatingActionButton(
  //             child: SvgPicture.asset(
  //               'assets/icons/hide.svg',
  //               // color: Colors.black.withOpacity(0.12),
  //             ),
  //             backgroundColor: Colors.white,
  //             onPressed: () {
  //               _onCapturePressed(context);
  //                 Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => PreviewScreen(
  //                 imgPath: path,
  //                 senderPic: widget,
  //               )),
  //     );
  //             },
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
          onPressed: _onSwitchCamera,
          icon: Icon(
            _getCameraLensIcon(lensDirection),
            color: Colors.white,
            size: 24,
          ),
          label: Text(
            lensDirection.index == 1 ? 'Frontal' : 'Trasera',
            style: kTextStyleWhiteSmallLetter,
            textScaleFactor: 1.2,
          ),
        ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }
}
