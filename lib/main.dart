import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/influencer.dart';
import 'ui/screens/terms_condtions_screen.dart';
import 'ui/screens/welcome_screen.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/email_screen.dart';
import 'ui/screens/verification_screen.dart';
import 'ui/screens/registration_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/bank_account_screen.dart';
import 'ui/screens/password_screen.dart';
import 'ui/screens/change_profile_screen.dart';
import 'ui/screens/contact_us_screen.dart';
import 'ui/screens/forget_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Influencer(),
      child: MaterialApp(
        title: 'Linkish',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'SamimFD',
        ),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: WelcomeScreen(),
        routes: {
          '/welcome': (ctx) => WelcomeScreen(),
          '/terms-conditions': (ctx) => TermsConditionsScreen(),
          '/email': (ctx) => EmailScreen(),
          '/verification': (ctx) => VerificationScreen(),
          '/registration': (ctx) => RegistrationScreen(),
          '/home': (ctx) => HomePage(),
          '/bank-account': (ctx) => BankAccountScreen(),
          '/password': (ctx) => PassWordScreen(),
          '/change-profile': (ctx) => ChangeProfileScreen(),
          '/contact-us': (ctx) => ContactUsScreen(),
          '/login': (ctx) => LoginScreen(),
          '/forget-password': (ctx) => ForgetPasswordScreen(),
        },
      ),
    );
  }
}
