import 'package:flutter/material.dart';

import 'ui/screens/email_screen.dart';
import 'ui/screens/verification_screen.dart';
import 'ui/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Linkish',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: EmailScreen(),
        ),
        routes: {
          '/email': (ctx) => EmailScreen(),
          '/verification': (ctx) => VerificationScreen(),
          // '/registration': (ctx) => RegistrationScreen(),
          '/home': (ctx) => HomePage(),
        },
    );
  }
}