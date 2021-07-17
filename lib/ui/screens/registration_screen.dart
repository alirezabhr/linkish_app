import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/TopicSelector.dart';
import '../../services/web_api.dart';
import '../../models/influencer.dart';

enum InstagramPageType { general, pro }

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _igIdController = TextEditingController();
  final _locationController = TextEditingController();
  InstagramPageType? _pageType = InstagramPageType.general;

  @override
  Widget build(BuildContext context) {
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
                    child: Text(
                      emailAddress,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
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
                    ),
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
                    controller: _igIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Instagram Id',
                    ),
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
                          bool isGeneral = _pageType == InstagramPageType.general ? true : false;
                          try {
                            Influencer influencer = Influencer(
                              emailAddress, _passwordController.text,
                              _igIdController.text, _locationController.text,
                              isGeneral, [],
                            );

                            await WebApi().influencerSignup(influencer);
                            Navigator.pushReplacementNamed(context, "/home");
                          } catch (exception) {
                            print(exception); // todo should add a validation, show the exception
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
