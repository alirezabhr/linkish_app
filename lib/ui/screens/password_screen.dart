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
  bool _isSending = false;


  setNewPassword(int pk, String currentPass, String newPass) {
    setState(() {
      _isSending = true;
    });

    WebApi().setNewPassword(pk, currentPass, newPass);

    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Influencer influencer = Provider.of<Influencer>(context);
    final int userId = influencer.userId;
    return Scaffold(
      appBar: AppBar(title: Text("تغییر رمز عبور")),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
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
                  ),
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
                  ),
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
                  ),
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
              Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String currentPass = _currentPasswordController.text;
                      String newPass = _newPasswordController.text;
                      await setNewPassword(userId, currentPass, newPass);
                      influencer.setNewPass(newPass);
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
    );
  }
}
