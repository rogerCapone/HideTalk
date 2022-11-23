import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hide_talk/shared/size_config.dart';

//! PER AFEGIR UN COLOR ROLLO
//? #351f39
//*S'ha de affegir 0xff + 351f39 ==>

const kPrimaryColor =
    Color(0xFFFF7643); //?Blau: Color(0xff11698e); //? Taronja:
const kPrimaryLightColor = Color(0xFFFFECDF);
// const kPrimaryGradientColor = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
// );
const kPrimaryGradientColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFA53E), Color(0xFFFF7643),
      //?Taronja fluix a Taronja fort: ,Color(0xff11698e),      Color(0xff19456b)
    ]);
const kCoolGradientColor = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  stops: [0.25, 0.6],
  colors: [Colors.purple, Color(0xFFFF7643)],
);
const kGradient1 = LinearGradient(
  begin: Alignment.bottomRight,
  end: Alignment.bottomLeft,
  stops: [0.25, 0.7],
  colors: [Colors.white, Colors.black],
);
final gTraffic = 'CN2bDeAD4ufM';
const kSecondaryColor = Color(0xff121013); //Color(0xfffe3de);
//?VerdeChicle Color(    0xff16c79a); //?Rosa pastel: Color(0xffe7d9ea); //?Magenta: Color(    0xff2c061f);   //?Blanc  //?Rosa fluixet:  //?Negre: Color(0xff121013);  //? Lila Clar: Color(0xff726a95);
//?Lila Fort:  Color(0xff351f39); //? Gris: Color(0xFF979797);
const kIntroBackGround = Color(0xfffe3de);

const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError =
    'Por favor introduzca su Correo'; //"Please Enter your email";
const String kInvalidEmailError =
    'Por favor introduzca un Correo Valido'; //"Please Enter Valid Email";
const String kPassNullError =
    'Por favor introduzca su Contraseña'; //"Please Enter your password";
const String kShortPassError =
    'La constraseña es demasiado corta'; //"Password is too short";
const String kMatchPassError =
    'Las contraseñas no coinciden'; //"Passwords don't match";
const String kNamelNullError =
    'Por favor introduzca un nombre de Usuario'; //"Please Enter your name";
// const String kPhoneNumberNullError = "Please Enter your phone number";
// const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

//? ESTILOS DE TEXTO

final kTextStyleTitleBig = GoogleFonts.montserrat(
  color: Colors.black,
  fontSize: getProportionateScreenWidth(22.5),
  fontWeight: FontWeight.w500,
);

final kTextStyleBodyBig = GoogleFonts.montserrat(
  fontSize: 30,
  color: Colors.black,
  fontWeight: FontWeight.w300,
);

final kTextStyleBodyMedium = GoogleFonts.montserrat(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.w200,
);

final kTextStyleBodyMediumCursiva = GoogleFonts.montserrat(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w200,
    fontStyle: FontStyle.italic);

final kTextStyleBodyContact = GoogleFonts.montserrat(
  fontSize: 10.5,
  color: Colors.black,
  fontWeight: FontWeight.w200,
);

final kTextStyleBodySmall = GoogleFonts.montserrat(
    fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400);

final kTextStyleSmallLetter = GoogleFonts.muli(
    fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400);

//! White

final kTextStyleWhiteBodyBig = GoogleFonts.montserrat(
  fontSize: 30,
  color: Colors.white,
  fontWeight: FontWeight.w300,
);

final kTextStyleWhiteTitleBig = GoogleFonts.montserrat(
  color: Colors.white,
  fontSize: getProportionateScreenWidth(22.5),
  fontWeight: FontWeight.w500,
);
final kTextStyleWhiteBodyMedium = GoogleFonts.montserrat(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.w200,
);

final kTextStyleWhiteBodyMediumCursiva = GoogleFonts.montserrat(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.w200,
    fontStyle: FontStyle.italic);

final kTextStyleWhiteBodySmall = GoogleFonts.montserrat(
    fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400);

final kTextStyleWhiteSmallLetter = GoogleFonts.muli(
    fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400);

final kTextStyleWhiteSmallLetterCursiva = GoogleFonts.muli(
    fontStyle: FontStyle.italic,
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w400);

final kBoobie = 'lV3hNxRvsP3s';
