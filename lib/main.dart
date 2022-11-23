import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hide_talk/l10n/l10n.dart';
import 'package:hide_talk/pages/log/register/verify.dart';
import 'package:hide_talk/pages/log/setProfileData/completeProfile.dart';
import 'package:hide_talk/pages/log/setProfileData/components/confirmAdult.dart';
import 'package:hide_talk/pages/log/setProfileData/components/uploadPicture.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:hide_talk/pages/pinPage/pinPage.dart';
import 'package:hide_talk/pages/pinPage/setUpPin.dart';
import 'package:hide_talk/pages/splash/splashScreen.dart';
import 'package:hide_talk/services/apple/apple_signIn_available.dart';
import 'package:hide_talk/services/auth.dart';
import 'package:hide_talk/services/database.dart';
import 'package:hide_talk/services/locale_provider.dart';
import 'package:hide_talk/services/provider.dart';
import 'package:hide_talk/shared/size_config.dart';
import 'package:hide_talk/shared/theme.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart' as provider;

import 'logic/cubits/internet/internet_cubit.dart';
import 'logic/cubits/settings/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appleSignInAvailable = await AppleSignInAvaialble.check();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  // await Purchases.setDebugLogsEnabled(true);
  //* await Purchases.setup(REVENUE_CAT_API_KEY);

  runApp(
    // DevicePreview(
    // builder: (context) =>
    MyApp(connectivity: Connectivity()),
    // )
  );
}

class MyApp extends StatefulWidget {
  final Connectivity connectivity;

  const MyApp({Key key, this.connectivity}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Provider(
        auth: AuthService(),
        db: FirebaseFirestore.instance,
        //! If this is not working you need to remove the child widget and leave
        // ! directelly the MaterialApp()
        child: MultiBlocProvider(
          providers: [
            BlocProvider<InternetCubit>(
              create: (internetCubitContext) =>
                  InternetCubit(connectivity: widget.connectivity),
            ),
            BlocProvider<SettingsCubit>(
              create: (settingsCubitContext) => SettingsCubit(),
            )
          ],
          child: provider.ChangeNotifierProvider(
            create: (context) => LocaleProvider(),
            builder: (context, child) {
              final prov = provider.Provider.of<LocaleProvider>(context);

              return MaterialApp(
                  title: 'HideTalk',
                  debugShowCheckedModeBanner: false,
                  //? Internacionalitzar
                  supportedLocales: L10n.all,
                  locale: prov.locale,
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  theme: theme(),
                  darkTheme: ThemeData(
                    primarySwatch: Colors.orange,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  home: HomeController(),
                  routes: <String, WidgetBuilder>{
                    // '/home': (BuildContext context) => HomeController(),
                  });
            },
          ),
        ));
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final AuthService auth = Provider.of(context).auth;

    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData && snapshot.data.uid != null) {
          // final bool signedIn = snapshot.hasData;
          if (snapshot.data.emailVerified) {
            DatabaseMethods().userLogin(snapshot.data);
            return FutureBuilder(
                future:
                    DatabaseMethods().userRegisterStage(uid: snapshot.data.uid),
                builder: (context, snapshot) {
                  // if(snapshot.data !=null){
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == 'allDone') {
                      return PinPage();
                    } else if (snapshot.data == 'userName' ||
                        snapshot.data == 'complete') {
                      return CompleteProfileScreen();
                    } else if (snapshot.data == 'oldEnough') {
                      return ConfirmAdultScreen();
                    } else if (snapshot.data == 'photoUrl') {
                      return PictureUploadScreen();
                    } else {
                      return SetPersonalPin();
                    }
                  } else {
                    return PinPage();
                    // return Container(
                    //     child: Center(
                    //   child: CircularProgressIndicator(
                    //     strokeWidth: 0.4,
                    //   ),
                    // ));
                  }
                });
          } else {
            return VerifyScreen();
          }

          // * I can try to place a BlocBuilder Here in order to get it through the whole TREE
          // return PinPage(); //HomeScreen()

        } else {
          return SplashScreen();
        }
      },
    );
  }
}
