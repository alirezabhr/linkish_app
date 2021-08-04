import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  bool _flag = false;
  bool _isSending = false;
  bool _isLoading = false;
  late final int userId;

  setBankAccountData(Influencer influencer, String cardNo, String accountNo) async {
    setState(() {
      _isSending = true;
    });
    try {
      await WebApi().setBankAccount(influencer, cardNo, accountNo);
      influencer.setBankCardNo(cardNo);
      influencer.setBankAccountNo(accountNo);
      setState(() {
        _cardNo = cardNo;
        _accountNo = accountNo;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("شماره کارت شما با موفقیت ثبت شد."),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("در حال حاضر این عملیات امکان پذیر نمی باشد."),
        ),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void setData(Influencer influencer) {
    this._accountNo = influencer.bankAccountNo;
    this._cardNo = influencer.bankCardNo;
    _cardNoController.text = _cardNo;
    _accountNoController.text = _accountNo;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Influencer influencer = Provider.of<Influencer>(context);
    if (!_flag) {
      _flag = true;
      userId = influencer.userId;
      setData(influencer);
    }
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
                    SizedBox(height: 40),
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
                            await setBankAccountData(influencer, cardNo, accountNo);
                            // await getBankAccount(userId);
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
