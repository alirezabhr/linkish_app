import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/influencer.dart';
import '../../services/web_api.dart';
import '../../services/logger_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoggingIn = false;

  Future<bool> logUserIn(
    Influencer influencer,
    String email,
    String password,
  ) async {
    try {
      Map response = await WebApi().influencerLogin(email, password);
      Map user = response['user'];

      await influencer.setUserId(response["id"]);
      await influencer.setToken("jwt " + response["token"]);
      await influencer.logUserIn(user, password);
      return true;
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        showSnackError("ایمیل یا رمز عبور اشتباه است");
      }

      LoggerService logger = LoggerService();
      await logger.sendLog(
        'login',
        {
          "catch_in": "dio error login screen",
          "response_status_code": e.response!.statusCode,
          "response_data": e.response!.data,
          "email": email,
        },
      );
    } catch (e) {
      showSnackError("خطا!");

      LoggerService logger = LoggerService();
      await logger.sendLog(
        'login',
        {
          "catch_in": "catch in login screen",
          "error": e,
          "email": email,
        },
      );
    }
    return false;
  }

  void showSnackError(String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMsg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Influencer influencer = Provider.of<Influencer>(context);
    return Scaffold(
      appBar: AppBar(title: Text('ورود')),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 6.0,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ایمیل',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فیلد ایمیل خالی است';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'رمزعبور',
                      prefixIcon: IconButton(
                        icon: _obscurePassword
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
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
                        return 'فیلد رمزعبور خالی است';
                      }
                      if (value.length < 8) {
                        return 'رمز عبور باید شامل حداقل 8 کاراکتر باشد';
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
                            if (_formKey.currentState!.validate()) {
                              if (!_isLoggingIn) {
                                setState(() {
                                  _isLoggingIn = true;
                                });

                                String _email = _emailController.text.toLowerCase();
                                String _password = _passwordController.text;
                                bool _loginFlag = await logUserIn(
                                    influencer, _email, _password);

                                setState(() {
                                  _isLoggingIn = false;
                                });

                                if (_loginFlag==true) {
                                  Navigator.of(context).pushReplacementNamed('/home');
                                }
                              }
                            }
                          },
                          child: _isLoggingIn
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "ورود",
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
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/forget-password');
                      },
                      child: Text('فراموشی رمز؟'),
                    ),
                    Text(' / ', style: TextStyle(fontSize: 18)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/email');
                      },
                      child: Text('ساخت حساب جدید'),
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
