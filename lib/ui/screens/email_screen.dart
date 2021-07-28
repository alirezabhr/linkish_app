import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/web_api.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ثبت نام لینکیش"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                "ایمیل خود را وارد نمایید:",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.right,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ایمیل',
                ),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      await WebApi().sendEmail(_emailController.text);
                      Navigator.pushReplacementNamed(context, "/verification",
                          arguments: _emailController.text);
                    } catch (exception) {
                      print(
                          exception); // todo should add a validation, show the exception
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white,)
                      : Text(
                          "ادامه",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
