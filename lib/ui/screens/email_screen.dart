import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/web_api.dart';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Email"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                "Enter You Email:",
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
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: ()async {
                    try {
                      await WebApi().sendEmail(_emailController.text);
                      Navigator.pushReplacementNamed(context, "/verification");
                    } catch (exception) {
                      print(exception);   // todo should add a validation, show the exception
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
    );
  }
}
