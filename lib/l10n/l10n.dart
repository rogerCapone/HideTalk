import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    // const Locale('ar'),
    // const Locale('ca'), //? Catala
    const Locale('es'), //? Spanish
    // const Locale('de'), //? Alemany
    // const Locale('fr'), //? Frances
    // const Locale('sl'), //? Elsove
    // const Locale('it'), //? Italia
  ];

  static String getFlag(String code) {
    switch (code) {
      // case 'ar':
      //   return '🇦🇪';
      // case 'hi':
      //   return '🇮🇳';
      case 'es':
        return 'es';
      // case 'de':
      //   return '🇩🇪';
      case 'en':
      default:
        return 'en';
    }
  }
}

//*https://www.science.co.il/language/Codes.php
