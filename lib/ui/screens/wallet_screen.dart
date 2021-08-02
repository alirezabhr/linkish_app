import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/influencer_ad.dart';
import '../../models/influencer.dart';
import '../widgets/WalletReport.dart';
import '../widgets/active_ad.dart';
import '../../services/web_api.dart';
import '../../services/utils.dart' as utils;

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final InfluencerAd activeAd;
  late final Influencer _influencer;
  bool flag = false;
  bool _isLoading = true;
  bool _hasActiveAd = false;
  List<InfluencerAd> _walletList = [];
  int _totalIncome = 0;

  void getWallet() async {
    setState(() {
      _isLoading = true;
      _hasActiveAd = false;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? userId = _prefs.getInt("id");
    List<InfluencerAd> tmpList = await WebApi().getWallet(userId!);
    List<InfluencerAd> approvedList = [];
    int earnings = 0;

    for (InfluencerAd ad in tmpList) {
      if (!utils.isActiveAd(ad)) {
        approvedList.add(ad);
        earnings += (ad.income * ((100-ad.deduction)/100)).round();
      } else {
        activeAd = ad;
        setState(() {
          _hasActiveAd = true;
        });
      }
    }
    
    setState(() {
      _walletList.addAll(approvedList);
      _totalIncome = earnings;
      _isLoading = false;
    });
  }

  withdraw(int amount) async {
    if (amount < 100000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حداقل مبلغ قابل برداشت: 100هزار تومان")),
      );
    } else {
      try {
        await WebApi().withdraw(_influencer.userId, amount);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("درخواست شما با موفقیت ثبت شد.")),
        );
      } on DioError {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("در حال حاضر قادر به برداشت وجه نیستید. لظفا بعدا تلاش کنید.")),
        );
      }
    }
  }

  @override
  void initState() {
    getWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (flag == false) {
      _influencer = Provider.of<Influencer>(context);
      flag = true;
    }
    final height = MediaQuery.of(context).size.height;

    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              height: height * 0.4,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300],
              ),
              child: Column(
                children: [
                  Container(
                    height: height * 0.3,
                    width: double.maxFinite,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                                child: Icon(Icons.wallet_giftcard),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "کیف پول لینکیش",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "$_totalIncome تومان",
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
                        await withdraw(_totalIncome);
                      },
                      label: Text("برداشت از کیف"),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: _hasActiveAd ? WalletActiveAd(activeAd) : null,
                        ),
                        Column(
                            children: List.generate(_walletList.length,
                                (index) => WalletReport(_walletList[index])),
                          ),
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
