import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/influencer_ad.dart';
import '../widgets/WalletReport.dart';
import '../../services/web_api.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isLoading = true;
  List<InfluencerAd> _walletList = [];
  int _totalIncome = 0;

  void getWallet() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? userId = _prefs.getInt("id");
    List<InfluencerAd> tmpList = await WebApi().getWallet(userId!);
    int earnings = 0;
    for (InfluencerAd ad in tmpList) {
      earnings += ad.income;
    }
    
    setState(() {
      _walletList = tmpList;
      _totalIncome = earnings;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getWallet();
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
                      onPressed: () {},
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
                  : Column(
                      children: List.generate(_walletList.length,
                          (index) => WalletReport(_walletList[index])),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
