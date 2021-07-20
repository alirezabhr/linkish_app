import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/TopicSelector.dart';
import '../../models/topic.dart';
import '../../models/influencer.dart';
import '../../services/web_api.dart';

enum InstagramPageType { general, pro }

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late Influencer influencer;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _igIdController = TextEditingController();
  final _locationController = TextEditingController();
  InstagramPageType? _pageType = InstagramPageType.general;

  @override
  Widget build(BuildContext context) {
    influencer = Provider.of<Influencer>(context);
    String emailAddress = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                      // labelText: 'Password',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ایمیل:",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          emailAddress,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      prefixIcon: IconButton(
                        icon: _obscurePassword
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                    obscureText: this._obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      if (value.length < 8) {
                        return 'Password should be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _igIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Instagram Id',
                    ),
                    textDirection: TextDirection.ltr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Location',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  title: const Text('My Page Is General'),
                  leading: Radio<InstagramPageType>(
                    value: InstagramPageType.general,
                    groupValue: _pageType,
                    onChanged: (InstagramPageType? value) {
                      setState(() {
                        _pageType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('My Page Is Professional'),
                  leading: Radio<InstagramPageType>(
                    value: InstagramPageType.pro,
                    groupValue: _pageType,
                    onChanged: (InstagramPageType? value) {
                      setState(() {
                        _pageType = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 16.0),
                  child: _pageType == InstagramPageType.pro
                      ? TopicSelector()
                      : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool isGeneral =
                              _pageType == InstagramPageType.general
                                  ? true
                                  : false;
                          try {
                            Map data = {
                              "email": emailAddress,
                              "password": _passwordController.text,
                              "instagram_id": _igIdController.text,
                              "location": _locationController.text,
                              "is_general_page": isGeneral,
                              "topics": [Topic(2, "fake2"), Topic(5, "fake5")],
                              // todo its fake. should change
                            };
                            String token = await WebApi().influencerSignup(data);
                            influencer.setUserDat(data);
                            influencer.setToken(token);
                            influencer.registerUser();
                            Navigator.pushReplacementNamed(context, "/home");
                          } on DioError catch (e) {
                            print(e.response!.data); // todo should add a validation, show the exception
                          }
                        }
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
