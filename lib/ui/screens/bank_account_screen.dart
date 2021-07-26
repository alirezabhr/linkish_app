import 'package:flutter/material.dart';
import 'package:linkish/services/web_api.dart';

class BankAccountScreen extends StatefulWidget {
  const BankAccountScreen({Key? key}) : super(key: key);

  @override
  _BankAccountScreenState createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNoController = TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bank Account")),
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
                  controller: _cardNoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'card number',
                  ),
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  maxLength: 16,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length < 16) {
                      return 'Not enough numbers';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: TextFormField(
                  controller: _accountNoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'account number',
                  ),
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.center,
                  maxLength: 24,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length < 24) {
                      return 'Not enough numbers';
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
                    await WebApi().setBankAccount();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Register",
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
