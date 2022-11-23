import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hide_talk/pages/appMenu/appMenu.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/encryption.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/constants.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hide_talk/widgets/custom_surfix_icon.dart';

class HideHash extends StatefulWidget {
  const HideHash({Key key}) : super(key: key);

  @override
  _HideHashState createState() => _HideHashState();
}

class _HideHashState extends State<HideHash> {
  String _pageState = 'non';
  Future<bool> scanQRCode(String uid) async {
    try {
      final encryptedScan = await FlutterBarcodeScanner.scanBarcode(
        '#f88f01',
        'Cancel',
        true,
        ScanMode.QR,
      );

      setState(() {
        _pageState = 'loading';
      });
      try {
        final result = await DatabaseMethods()
            .startHide(uid: uid, scannedHash: encryptedScan);

        print(result);
        if (result == true) {
          return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MenuApp()),
              (Route<dynamic> route) => false);
        } else {
          setState(() {
            _pageState = 'non';
          });
          return false;
        }
      } catch (e) {
        setState(() {
          _pageState = 'non';
        });
        print(e.toString());
        return false;
      }
      //
    } on PlatformException {
      print('Failed to get platform version.');
      setState(() {
        _pageState = 'non';
      });
      return false;
    }
  }

  String error;
  @override
  Widget build(BuildContext context) {
    TextEditingController hashController = TextEditingController();

    return Scaffold(
      body: _pageState != 'loading'
          ? SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: kSecondaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextsComboStack(),
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () async {
                          String uid =
                              await Provider.of(context).auth.getCurrentUID();
                          final result = await scanQRCode(uid);
                          if (result == true) {
                            return Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MenuApp()),
                                (Route<dynamic> route) => false);
                          } else {
                            setState(() {
                              _pageState = 'non';
                            });
                            final snackBar = SnackBar(
                              backgroundColor: Colors.white,
                              content: Text(
                                AppLocalizations.of(context).notAHideHash,
                                style: kTextStyleSmallLetter,
                                textAlign: TextAlign.center,
                              ),
                              // action: SnackBarAction(
                              //   label: 'Undo',
                              //   onPressed: () {},
                              // ),
                            );
                            setState(() {
                              error = 'true';
                            });
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Container(
                          height: 65,
                          width: getProportionateScreenWidth(160),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 1.5, vertical: 1.5),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.orange),
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.5, vertical: 2.5),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 15, top: 2, bottom: 2),
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      'Face2Face',
                                      textScaleFactor: 1.005,
                                      style: kTextStyleBodyMediumCursiva
                                          .copyWith(color: Colors.orange),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Face2Face',
                                      textScaleFactor: 1.0,
                                      style: kTextStyleWhiteBodyMediumCursiva,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(45)),
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaleFactor: 0.85),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          child: TextFormField(
                            onSaved: (string) async {
                              setState(() {
                                _pageState = 'loading';
                              });
                              final uid = await Provider.of(context)
                                  .auth
                                  .getCurrentUID();

                              final result = await DatabaseMethods().startHide(
                                  uid: uid, scannedHash: hashController.text);

                              if (result == true) {
                                //! Se li hauria de establir el periode de proba (1 mes FREE)
                                return Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuApp()),
                                    (Route<dynamic> route) => false);
                              } else {
                                setState(() {
                                  _pageState = 'non';
                                });
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    AppLocalizations.of(context).notAHideHash,
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
                            },
                            onFieldSubmitted: (string) async {
                              setState(() {
                                _pageState = 'loading';
                              });
                              final uid = await Provider.of(context)
                                  .auth
                                  .getCurrentUID();
                              final result = await DatabaseMethods().startHide(
                                  uid: uid, scannedHash: hashController.text);

                              if (result == true) {
                                //! Se li hauria de establir el periode de proba (1 mes FREE)
                                return Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuApp()),
                                    (Route<dynamic> route) => false);
                              } else {
                                setState(() {
                                  _pageState = 'non';
                                });
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    AppLocalizations.of(context).notAHideHash,
                                    style: kTextStyleSmallLetter,
                                    textAlign: TextAlign.center,
                                  ),
                                  // action: SnackBarAction(
                                  //   label: 'Undo',
                                  //   onPressed: () {},
                                  // ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            controller: hashController,
                            textAlign: TextAlign.center,
                            obscureText: false,
                            style: kTextStyleWhiteBodyMedium.copyWith(
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              labelStyle: kTextStyleWhiteBodyMediumCursiva
                                  .copyWith(fontWeight: FontWeight.w400),
                              hintStyle: kTextStyleWhiteBodyMediumCursiva
                                  .copyWith(fontWeight: FontWeight.w200),
                              helperStyle:
                                  kTextStyleWhiteBodyMediumCursiva.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w200),

                              labelText: 'Hide Hash',
                              hintText: 'Hide Hash',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              // If  you are using latest version of flutter then lable text and hint text shown like this
                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                              // floatingLabelBehavior: FloatingLabelBehavior.always,
                              suffixIcon: CustomSurffixIcon(
                                svgIcon: "assets/icons/xoco.svg",
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: Builder(
                        builder: (context) => GestureDetector(
                          onTap: () async {
                            final uid =
                                await Provider.of(context).auth.getCurrentUID();
                            try {
                              final result = await DatabaseMethods().startHide(
                                  uid: uid, scannedHash: hashController.text);
                              print(result.toString());
                              if (result == true) {
                                return Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuApp()),
                                    (Route<dynamic> route) => false);
                              } else {
                                setState(() {
                                  _pageState = 'non';
                                });
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    AppLocalizations.of(context).notAHideHash,
                                    style: kTextStyleSmallLetter,
                                    textAlign: TextAlign.center,
                                  ),
                                  // action: SnackBarAction(
                                  //   label: 'Undo',
                                  //   onPressed: () {},
                                  // ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                            //
                          },
                          child: Container(
                            height: 140,
                            width: getProportionateScreenWidth(160),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5, vertical: 1.5),
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.orange),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.5, vertical: 2.5),
                              child: Container(
                                // padding: EdgeInsets.all
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.black,
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        'Usar 🍫',
                                        textScaleFactor: 1.005,
                                        style: kTextStyleWhiteBodyMediumCursiva,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: kSecondaryColor,
              child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 0.4,
                  ),
                ),
              ),
            ),
    );
  }
}

class TextsComboStack extends StatelessWidget {
  final index;

  const TextsComboStack({Key key, this.index}) : super(key: key);

  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Text(
          "Hide Hash",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          "Hide Hash",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 34.5, fontWeight: FontWeight.w600),
        ),
        Text(
          "Hide Hash",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(fontSize: 34, color: Colors.white),
        ),
        Text(
          "Hide Hash",
          textScaleFactor: 0.95,
          style: kTextStyleBodyBig.copyWith(
              fontSize: 35, fontWeight: FontWeight.w600),
        ),
        Text(
          "Hide Hash",
          textScaleFactor: 0.95,
          style:
              kTextStyleBodyBig.copyWith(fontSize: 35.5, color: Colors.white),
        ),
      ],
    );
  }
}
