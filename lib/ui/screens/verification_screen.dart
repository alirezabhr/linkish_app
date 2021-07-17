import 'package:flutter/material.dart';

import '../../services/web_api.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String emailAddress = ModalRoute.of(context)!.settings.arguments as String;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("Verification"),),
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Text(
                  "Enter You OTP:",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: TextFormField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'OTP',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: ()async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          // await WebApi().checkOtp(emailAddress, _otpController.text);  // checkOtp function has problem
                          Navigator.pushReplacementNamed(context, "/registration", arguments: emailAddress);
                        } catch (exception) {
                          print(exception);   // todo should add a validation, show the exception
                        }
                      }
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
