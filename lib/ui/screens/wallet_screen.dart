import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/wallet_items.dart';
import '../../services/web_api.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  bool flag = false;
  int _walletAmount = 0;

  withdraw(int amount) async {
    if (amount < 100000) {
      showSnackBar("حداقل مبلغ قابل برداشت: 100هزار تومان");
    } else {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      int? userId = _prefs.getInt('id');
      try {
        await WebApi().withdraw(userId!, amount);
        showSnackBar("درخواست شما با موفقیت ثبت شد.");
        await this.getWalletAmount();
      } on DioError {
        showSnackBar("در حال حاضر قادر به برداشت وجه نیستید. لطفا بعدا تلاش کنید.");
      }
    }
  }

  Future<void> getWalletAmount() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? userId = _prefs.getInt('id');
    int _amount = await WebApi().getWalletAmount(userId!);
    setState(() {
      _walletAmount = _amount;
    });
  }

  void showSnackBar(String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMsg)),
    );
  }

  @override
  void initState() {
    getWalletAmount();
    _controller = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              height: height * 0.35,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Column(
                children: [
                  Container(
                    height: height * 0.27,
                    width: double.maxFinite,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 44),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.lightBlueAccent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.credit_card),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "کیف پول لینکیش",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "$_walletAmount تومان",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.arrow_circle_up),
                      onPressed: () async {
                        await withdraw(_walletAmount);
                      },
                      label: Text("برداشت از کیف"),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                // border: Border.all(color: Colors.black38),
              ),
              child: TabBar(
                controller: _controller,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.green,
                        ),
                        Text(
                          'دریافت ها',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.red,
                        ),
                        Text(
                          'برداشت ها',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    WalletIncomes(),
                    WalletWithdraws(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
