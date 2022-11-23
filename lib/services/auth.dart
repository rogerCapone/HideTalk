import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AppleSignIn _appleSignIn = AppleSignIn();

  Stream<String> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
      );

  // GET UID
  Future<String> getCurrentUID() async {
    return (_firebaseAuth.currentUser).uid;
  }

  // GET CURRENT USER
  Future<User> getCurrentUser() async {
    dynamic currentUser = _firebaseAuth.currentUser;
    print("//");
    print(currentUser.toString());
    print("//");
    return _firebaseAuth.currentUser;
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      {String email, String password}) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return authResult.user.uid;
  }

  //SignIn Google
  Future<User> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      var mail = googleSignInAccount.email;
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      print(googleAuth.idToken);
      print(googleAuth.accessToken);
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);
      User user = result.user;
      print(user.toString());
      return user;
    } catch (e) {
      print('Fatal Error During user SIGNIN');
      print(e.toString());
    }
  }

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    print(scopes.toString());
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(
          requestedScopes: scopes,
          requestedOperation: OpenIdOperation.operationLogin)
    ]);
    // 2. check the result
    print(result.credential.toString());
    print('\n');
    print(result.status);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(displayName: displayName);
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  Future setUserInfo(
      String name, String uid, bool business, String photoUrl) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(uid).set(
          {'displayName': name, 'business': business, 'photoUrl': photoUrl},
          SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('allUsers')
          .doc('usersDoc')
          .set({
        'totalUsers': FieldValue.increment(1),
        'usersList': FieldValue.arrayUnion([
          {'displayName': name, 'photoUrl': photoUrl, 'uid': uid}
        ])
      }, SetOptions(merge: true));
      return 'done';
    } catch (e) {
      print(e.toString());
    }
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      {String email, String password}) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  // Sign Out
  signOut() async {
    //Elegir uno ()
    try {
      await _googleSignIn.signOut();
      return await _firebaseAuth.signOut();
    } catch (e) {
      return await _firebaseAuth.signOut();
    }
  }

  delelteAccount() async {
    //Elegir uno ()
    try {
      return _firebaseAuth.currentUser.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Create Anonymous User
  Future singInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }
}
// Future<User> changeUserFromSql(String userName, String authProvider,
//     String email, String password, String idToken, String accessToken) async {
//   //2 maneres de fer-ho () --> Aquesta faria que el usuari deixes la Aplicació
//   //Crear una manera per a que quan això passi, la pantalla que aparegui sigui
//   //una animació (feeling in App)
//   await signOut();

//   if (authProvider == 'google') {
//     final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: accessToken, idToken: idToken);
//     UserCredential result =
//         await _firebaseAuth.signInWithCredential(credential);
//     User user = result.user;
//     print(user.toString());
//     return user;
//   } else {
//     //'email&Password'
//     return (await _firebaseAuth.signInWithEmailAndPassword(
//             email: email, password: password))
//         .user;
//   }
// }
//} //(Aixo es per tancar el global)

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}
