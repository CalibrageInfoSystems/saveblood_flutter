// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_logindemo/ui/constants.dart';
// import 'package:flutter_logindemo/ui/home_screen.dart';
// import 'package:flutter_logindemo/ui/profile_screen.dart';
// import 'package:flutter_logindemo/ui/profile_view_screen.dart';
// import 'package:flutter_logindemo/ui/signup_screen.dart';

// import './ui/signin.dart';
// import './ui/splashscreen.dart';
// import 'ui/forgotpassword_screen.dart';
// import 'ui/notification_screen.dart';
// import 'ui/profile_screen/profile_screen_new.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'localization/app_translations_delegate.dart';
// import 'localization/application.dart';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logindemo/ui/constants.dart';
import 'package:flutter_logindemo/ui/home_screen.dart';
import 'package:flutter_logindemo/ui/profile_screen.dart';
import 'package:flutter_logindemo/ui/profile_view_screen.dart';
import 'package:flutter_logindemo/ui/selectLanuguage_screen.dart';
import 'package:flutter_logindemo/ui/signup_screen.dart';
import './ui/signin.dart';
import './ui/splashscreen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/app_translations.dart';
import 'localization/app_translations_delegate.dart';
import 'localization/application.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/constants.dart';
import 'ui/forgotpassword_screen.dart';
import 'ui/notification_screen.dart';
import 'ui/profile_screen/profile_screen_new.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

   AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login",
      theme: ThemeData(primarySwatch: Colors.red,accentColor: Colors.redAccent),
      routes: <String, WidgetBuilder>{
        Constants.SPLASH_SCREEN: (BuildContext context) =>  SplashScreen(),
        Constants.SIGN_IN: (BuildContext context) =>  SignInPage(),
        Constants.PROFILE_SCREEN_NEW :  (BuildContext context) =>  ProfileScreenNew(),
        Constants.FORGOTPASSWORD: (BuildContext context) => ForGotpasswordScreen(),
      
        Constants.PROFILE_screen :(BuildContext context) => UserProfileView(),
        Constants.EDIT_PROFILE : (BuildContext context) => UserProfileScreen(),
       // Constants.SIGN_UP: (BuildContext context) =>  SignUpScreen(),
        Constants.SIGN_UP: (BuildContext context) =>  SignupScreenNew(),
        Constants.HOME_SCREEN:(BuildContext context) => HomeScreen(),
        Constants.NOTIFICATIONS_SCREEN : (BuildContext context) => NotificationScreen(),
        Constants.SelectLanguage_Screen : (BuildContext context) => SelectLanguagescreen(),
      },
      initialRoute: Constants.SPLASH_SCREEN,
            localizationsDelegates: [
         _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
   
      supportedLocales: [
        const Locale("tu", ""),
        const Locale("es", ""),       
      ],
    );
  }

    void onLocaleChange(Locale locale) {
      setState(() {
       _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
       print(locale);
      });
  }

}

  void onLocaleChange(Locale locale) async {
    setState(() {
          AppTranslations.load(locale);

        });
      }
    
    void setState(Null Function() param0) {
}


