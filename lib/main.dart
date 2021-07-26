import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/influencer.dart';

import 'ui/screens/welcome_screen.dart';
import 'ui/screens/email_screen.dart';
import 'ui/screens/verification_screen.dart';
import 'ui/screens/registration_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/bank_account_screen.dart';

void main() {
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
          '/email': (ctx) => EmailScreen(),
          '/verification': (ctx) => VerificationScreen(),
          '/registration': (ctx) => RegistrationScreen(),
          '/home': (ctx) => HomePage(),
          '/bank-account': (ctx) => BankAccountScreen(),
        },
      ),
    );
  }
}