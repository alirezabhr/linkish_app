import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:linkish/services/web_api.dart';

class OtpForgetPasswordScreen extends StatefulWidget {
  const OtpForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _OtpForgetPasswordScreenState createState() =>
      _OtpForgetPasswordScreenState();
}

class _OtpForgetPasswordScreenState extends State<OtpForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Map routeData = ModalRoute.of(context)!.settings.arguments as Map;
    final String emailAddress = routeData['email'];

    return Scaffold(
      appBar: AppBar(title: Text('فراموشی رمز')),
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
                        Navigator.pushReplacementNamed(
                            context, '/forget-password');
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
                                    emailAddress,
                                    _otpController.text,
                                  );

                                  routeData['otp'] = _otpController.text;

                                  Navigator.pushReplacementNamed(
                                    context,
                                    "/new-password",
                                    arguments: routeData,
                                  );
                                } on DioError catch (exception) {
                                  if (exception.response!.statusCode == 400) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("رمز یکبار مصرف اشتباه است"),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("خطا در بررسی رمز یکبار مصرف"),
                                      ),
                                    );
                                  }
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
