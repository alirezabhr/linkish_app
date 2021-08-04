import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/influencer.dart';
import '../../services/web_api.dart';

class PassWordScreen extends StatefulWidget {
  const PassWordScreen({Key? key}) : super(key: key);

  @override
  _PassWordScreenState createState() => _PassWordScreenState();
}

class _PassWordScreenState extends State<PassWordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _showPass1 = false;
  bool _showPass2 = false;
  bool _showPass3 = false;
  bool _isSending = false;

  setNewPassword(Influencer influencer, String currentPass, String newPass) async {
    setState(() {
      _isSending = true;
    });

    try {
      await WebApi().setNewPassword(influencer.userId, currentPass, newPass);
      influencer.setNewPass(newPass);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("رمز عبور با موفقیت تغییر یافت."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("خطا در عملیات."),
        ),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Influencer influencer = Provider.of<Influencer>(context);
    return Scaffold(
      appBar: AppBar(title: Text("تغییر رمز عبور")),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: TextFormField(
                    controller: _currentPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'رمز عبور فعلی',
                      prefixIcon: IconButton(
                        icon: _showPass1
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _showPass1 = !_showPass1;
                          });
                        },
                      ),
                    ),
                    obscureText: _showPass1,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'رمز عبور خالی است';
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
                      horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'رمز عبور جدید',
                      prefixIcon: IconButton(
                        icon: _showPass2
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _showPass2 = !_showPass2;
                          });
                        },
                      ),
                    ),
                    obscureText: _showPass2,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'رمز عبور خالی است';
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
                      horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'تکرار رمز عبور',
                      prefixIcon: IconButton(
                        icon: _showPass3
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _showPass3 = !_showPass3;
                          });
                        },
                      ),
                    ),
                    obscureText: _showPass3,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'رمز عبور خالی است';
                      }
                      if (value.length < 8) {
                        return 'رمز عبور باید حداقل 8 کاراکتر باشد';
                      }
                      if (value != _newPasswordController.text) {
                        return 'پسوردها یکسان نیستند';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String currentPass = _currentPasswordController.text;
                        String newPass = _newPasswordController.text;
                        await setNewPassword(influencer, currentPass, newPass);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _isSending
                              ? CircularProgressIndicator()
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
