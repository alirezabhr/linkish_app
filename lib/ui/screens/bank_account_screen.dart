import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/web_api.dart';
import '../../services/utils.dart' as utils;
import '../../models/influencer.dart';

class BankAccountScreen extends StatefulWidget {
  const BankAccountScreen({Key? key}) : super(key: key);

  @override
  _BankAccountScreenState createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String _cardNo = "";
  String _accountNo = "";
  final TextEditingController _cardNoController = TextEditingController();
  final TextEditingController _accountNoController = TextEditingController();
  bool _isSending = false;
  bool _isLoading = false;

  setBankAccountData(int userId, String cardNo, String accountNo) async {
    setState(() {
      _isSending = true;
    });
    await WebApi().setBankAccount(userId, cardNo, accountNo);
    setState(() {
      _isSending = false;
    });
  }

  getBankAccount(int userId) async {
    setState(() {
      _isLoading = true;
    });
    Map data = await WebApi().getBankAccount(userId);

    if (data['account_number']!="") {
      this._accountNo = data['account_number'];;
    } else {
      this._accountNo = "شماره شبا ثبت نشده است";
    }

    if (data['card_number']!="") {
      this._cardNo = utils.addDashCardNo(data['card_number']);
    } else {
      this._cardNo = "شماره کارت ثبت نشده است";
    }

    setState(() {
      _isLoading = false;
    });
  }

  void setData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? id = _prefs.getInt("id");
    getBankAccount(id!);
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Influencer influencer = Provider.of<Influencer>(context);
    final int userId = influencer.userId;
    return Scaffold(
      appBar: AppBar(title: Text("تنظیمات حساب بانکی")),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Text("شماره کارت: ", style: TextStyle(fontSize: 16),),
                        Text(
                          _cardNo,
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("شماره شبا: ", style: TextStyle(fontSize: 16),),
                        Text(
                          _accountNo,
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        controller: _cardNoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'شماره کارت',
                        ),
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        maxLength: 16,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'فیلد شماره کارت خالی است';
                          }
                          if (value.length < 16) {
                            return 'تعداد ارقام شماره کارت کافی نیست';
                          }
                          if (!utils.isNumeric(value)) {
                            return 'شماره کارت نامعتبر است';
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
                          labelText: 'شماره شبا',
                        ),
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        maxLength: 24,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'فیلد شماره حساب خالی است';
                          }
                          if (value.length < 24) {
                            return 'تعداد ارقام کافی نیست';
                          }
                          if (!utils.isNumeric(value)) {
                            print(utils.isNumeric(value));
                            return 'شماره حساب نامعتبر است';
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
                            String cardNo = _cardNoController.text;
                            String accountNo = _accountNoController.text;
                            await setBankAccountData(userId, cardNo, accountNo);
                            await getBankAccount(userId);
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
