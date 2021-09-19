import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/influencer.dart';
import '../../services/web_api.dart';
import '../../services/analytics_service.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passController = TextEditingController();
  TextEditingController _repassController = TextEditingController();
  bool _showPass1 = false;
  bool _showPass2 = false;
  bool _isSubmitting = false;

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> setNewPassword(Influencer influencer, Map data) async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await WebApi().forgetPassword(data);
      influencer.setNewPass(data['password']);
      showSnackBar("رمز عبور با موفقیت تغییر یافت.");
      Navigator.of(context).pop();
    } on DioError catch(e) {
      showSnackBar("خطا در عملیات");

      AnalyticsService analytics = AnalyticsService();
      await analytics.sendLog(
        'forget_password',
        {
          "catch_in": "dio error in forget password",
          "response_status_code": e.response!.statusCode,
          "response_data": e.response!.data,
          "send_data": data,
        },
      );
    } catch (e) {
      showSnackBar("خطا در عملیات");

      AnalyticsService analytics = AnalyticsService();
      await analytics.sendLog(
        'forget_password',
        {
          "catch_in": "catch error in forget password",
          "error": e,
          "send_data": data,
        },
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Influencer influencer = Provider.of<Influencer>(context);
    final Map routeData = ModalRoute.of(context)!.settings.arguments as Map;

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
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'رمز عبور جدید',
                      prefixIcon: IconButton(
                        icon: _showPass1
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPass1 = !_showPass1;
                          });
                        },
                      ),
                    ),
                    obscureText: !_showPass1,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فیلد خالی است';
                      }
                      if (value.length < 8) {
                        return 'رمز عبور باید حداقل 8 کاراکتر باشد';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: TextFormField(
                    controller: _repassController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'تکرار رمز عبور',
                      prefixIcon: IconButton(
                        icon: _showPass2
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPass2 = !_showPass2;
                          });
                        },
                      ),
                    ),
                    obscureText: !_showPass2,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فیلد خالی است';
                      }
                      if (value.length < 8) {
                        return 'رمز عبور باید حداقل 8 کاراکتر باشد';
                      }
                      if (value != _passController.text) {
                        return 'رمزها یکسان نیستند';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_isSubmitting) {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isSubmitting = true;
                          });
                          String newPassword = _passController.text;
                          routeData['password'] = newPassword;

                          await setNewPassword(influencer, routeData);
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _isSubmitting
                              ? CircularProgressIndicator(color: Colors.white,)
                              : Text(
                                  "ثبت",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
