import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/influencer.dart';


class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool dialogResponse = false;
  var _timer;
  double _progress = 4;
  late Influencer influencer;

  _loadData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool? isRegistered = _prefs.getBool("is_registered");
    if (isRegistered == true) {
      influencer.getUserDataSharedPref();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/email');
    }
  }

  void startTimer() {
    _timer = new Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) => setState(
            () {
          if (_progress == 0) {
            _timer.cancel();
            _loadData();
          } else {
            _progress -= 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double smallLogo = 100;
    const double bigLogo = 200;
    influencer = Provider.of<Influencer>(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size biggest = constraints.biggest;
          return Stack(
            children: <Widget>[
              PositionedTransition(
                rect: RelativeRectTween(
                  begin: RelativeRect.fromSize(
                      Rect.fromLTWH(biggest.width + bigLogo,
                          biggest.height / 2 - 50, smallLogo, smallLogo),
                      biggest),
                  end: RelativeRect.fromSize(
                      Rect.fromLTWH(
                          (biggest.width - bigLogo) / 2,
                          (biggest.height - bigLogo - 100) / 2,
                          bigLogo,
                          bigLogo),
                      biggest),
                ).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticInOut,
                )),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
              ),
              PositionedTransition(
                rect: RelativeRectTween(
                  begin: RelativeRect.fromSize(
                      Rect.fromLTWH(
                          (0 - 200) / 2, (biggest.height + 100) / 2, 100, 25),
                      biggest),
                  end: RelativeRect.fromSize(
                      Rect.fromLTWH((biggest.width - 200) / 2,
                          (biggest.height + 100) / 2, 200, 50),
                      biggest),
                ).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticInOut,
                )),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'لینکیش',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: (biggest.width - 100) / 2,
                child: Container(
                  width: 100,
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.deepPurple,
                        thickness: 1.5,
                      ),
                      Center(
                          child: Text(
                            'نسخه 1.0.0',
                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
