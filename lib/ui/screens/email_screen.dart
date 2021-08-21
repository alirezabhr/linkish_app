import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/web_api.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final _igIdController = TextEditingController();
  bool _isLoading = false;
  bool _isCheckingIgId = false;
  bool _isSendingEmail = false;
  bool _isAcceptedTermAndCondition = true;

  Future<void> checkIgIdAndSendEmail() async {
    bool _isValid = true;
    setState(() {
      _isCheckingIgId = true;
    });

    try {
      Map response = await WebApi().checkInstagramId(_igIdController.text);
      if (response['followers'] < 10000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("اینستاگرام شما کمتر از ده هزار دنبال کننده دارد."),
          ),
        );
        _isValid = false;
        return;
      }
    } on DioError catch (error) {
      _isValid = false;
      if (error.response!.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("آیدی اینستاگرام یافت نشد."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("خطا در بررسی صفحه اینستاگرام!\nلطفا دوباره تلاش کنید"),
          ),
        );
      }
      return;
    }

    setState(() {
      _isCheckingIgId = false;
      _isSendingEmail = true;
    });

    try {
      await WebApi().sendEmail(_emailController.text);
    } catch (exception) {
      _isValid = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("خطا در ارسال ایمیل!"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = false;
      _isSendingEmail = false;
    });

    if (_isValid) {
      Map routeData = {
        'email': _emailController.text,
        'instagram_id': _igIdController.text,
      };
      Navigator.pushReplacementNamed(context, "/verification",
          arguments: routeData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ثبت نام لینکیش"),
      ),
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
                    "ایمیل و آیدی اینستاگرام خود را وارد نمایید:",
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _igIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'آیدی اینستاگرام',
                      suffixText: '@',
                    ),
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فیلد آیدی اینستاگرام خالی است';
                      }
                      if (value.contains(' ') ||
                          value.contains('-') ||
                          value.contains('@')) {
                        return 'آیدی نامعتبر است';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      value: _isAcceptedTermAndCondition,
                      onChanged: (bool? value) {
                        setState(() {
                          _isAcceptedTermAndCondition = value!;
                        });
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed("/terms-conditions");
                        },
                        child: Text(
                          'شرایط و ضوابط',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Text("را میپذیرم"),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Center(
                    child: _isLoading
                        ? Text(
                            _isCheckingIgId
                                ? "در حال بررسی پیج اینستاگرام..."
                                : _isSendingEmail
                                    ? "در خال ارسال ایمیل..."
                                    : "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          )
                        : null,
                  ),
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

                              if (!_isAcceptedTermAndCondition) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "شرایط و ضوابط را تایید نکرده‌اید"),
                                  ),
                                );
                              } else {
                                await checkIgIdAndSendEmail();
                                setState(() {
                                  _isCheckingIgId = false;
                                  _isSendingEmail = false;
                                });
                              }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('قبلا ثبت نام کرده‌اید؟ '),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text('ورود'),
                    ),
                    SizedBox(width: 20),
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
