import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:linkish/services/logger_service.dart';

import '../../services/web_api.dart';
import '../../services/logger_service.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map routeData = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
    final String emailAddress = routeData['email'];

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
                                      arguments: routeData);
                                } on DioError catch (exception) {
                                  setState(() {
                                    _isLoading = false;
                                  });

                                  if (exception.response!.statusCode == 400) {
                                    showSnackBar("رمز یکبار مصرف اشتباه است");
                                  } else {
                                    showSnackBar("خطا در بررسی رمز یکبار مصرف");

                                    LoggerService logger = LoggerService();
                                    await logger.sendLog(
                                      'verification_code',
                                      {
                                        "catch_in": "dio error verification screen",
                                        "email": emailAddress,
                                        "response_status_code": exception
                                            .response!.statusCode,
                                        "response_data": exception.response!
                                            .data,
                                      },
                                    );
                                  }
                                } catch (error) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showSnackBar("خطا در بررسی رمز یکبار مصرف");

                                  LoggerService logger = LoggerService();
                                  await logger.sendLog(
                                    'login',
                                    {
                                      "catch_in": "catch in login screen",
                                      "email": emailAddress,
                                      "error": error.toString(),
                                    },
                                  );
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              }
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
