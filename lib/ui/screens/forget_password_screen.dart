import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkish/services/web_api.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('فراموشی رمز')),
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Text(
                    "ایمیل خود را وارد نمایید:",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.right,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ایمیل',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فیلد ایمیل خالی است';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'ایمیل نامعتبر است';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!_isLoading) {
                              setState(() {
                                _isLoading = true;
                              });
                              String userEmail = _emailController.text.toLowerCase();

                              try {
                                await WebApi().sendEmail(userEmail);
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("خطا در ارسال ایمیل!"),
                                  ),
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                return;
                              }

                              // just wait for a second
                              await Future.delayed(Duration(seconds: 1), () {});

                              Navigator.pushReplacementNamed(context, '/otp-forget-password',
                                  arguments: {'email': userEmail});
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: _isLoading
                              ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : Text(
                            "ادامه",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
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
