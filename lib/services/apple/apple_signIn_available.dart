import 'package:apple_sign_in/apple_sign_in.dart';

class AppleSignInAvaialble {
  AppleSignInAvaialble(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvaialble> check() async {
    return AppleSignInAvaialble(await AppleSignIn.isAvailable());
  }
}
