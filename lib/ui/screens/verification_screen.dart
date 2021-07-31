import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../services/web_api.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final String emailAddress =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("ثبت نام لینکیش"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Text(
                    "کد یکبار مصرف ایمیل شده را وارد نمایید:",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.right,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        emailAddress,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: TextFormField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'کد',
                      hintText: 'کد یکبار مصرف',
                    ),
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    maxLength: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فیلد خالی است';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/email');
                      },
                      icon: Icon(Icons.email),
                      label: Text('تصحیح ایمیل'),
                    ),
                    // ElevatedButton.icon(
                    //   onPressed: _isTimerOn
                    //       ? null
                    //       : () async {
                    //           _timer?.cancel();
                    //           await WebApi().sendEmail(emailAddress);
                    //         },
                    //   icon: Icon(Icons.refresh),
                    //   label: Text('ارسال مجدد'),
                    // ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (!_isLoading) {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await WebApi().checkOtp(
                                      emailAddress, _otpController.text);
                                  Navigator.pushReplacementNamed(
                                      context, "/registration",
                                      arguments: emailAddress);
                                } on DioError catch (exception) {
                                  if (exception.response!.statusCode == 400) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "رمز یکبار مصرف اشتباه است")),
                                    );
                                  }
                                  print(
                                      exception); // todo should add a validation, show the exception
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                              }
                            }
                          },
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white,)
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
