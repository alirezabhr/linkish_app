import 'package:flutter/material.dart';
import 'package:linkish/models/withdraw.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/influencer_ad.dart';
import '../../services/web_api.dart';
import '../../services/utils.dart' as utils;
import 'WalletReport.dart';
import 'active_ad.dart';

class WalletIncomes extends StatefulWidget {
  const WalletIncomes({Key? key}) : super(key: key);

  @override
  _WalletIncomesState createState() => _WalletIncomesState();
}

class _WalletIncomesState extends State<WalletIncomes> {
  late final InfluencerAd activeAd;
  List<InfluencerAd> _walletList = [];
  bool _isLoading = true;
  bool _hasActiveAd = false;

  void getWalletIncome() async {
    setState(() {
      _isLoading = true;
      _hasActiveAd = false;
    });

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? userId = _prefs.getInt("id");
    List<InfluencerAd> tmpList = await WebApi().getWalletIncome(userId!);
    List<InfluencerAd> approvedList = [];

    for (InfluencerAd ad in tmpList) {
      if (!utils.isActiveAd(ad)) {
        approvedList.add(ad);
      } else {
        activeAd = ad;
        setState(() {
          _hasActiveAd = true;
        });
      }
    }

    setState(() {
      _walletList.addAll(approvedList);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getWalletIncome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class WalletWithdraws extends StatefulWidget {
  const WalletWithdraws({Key? key}) : super(key: key);

  @override
  _WalletWithdrawsState createState() => _WalletWithdrawsState();
}

class _WalletWithdrawsState extends State<WalletWithdraws> {
  List<Withdraw> _withdrawsList = [];
  bool _isLoading = true;

  Future<void> _loadWithdraws() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int? userId = _prefs.getInt("id");
    List<Withdraw> tmpList = await WebApi().getWithdrawsList(userId!);

    setState(() {
      _withdrawsList = tmpList;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _loadWithdraws();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: List.generate(
                  this._withdrawsList.length,
                  (index) {
                    Withdraw item = _withdrawsList[index];
                    return Column(children: [
                      ListTile(
                        leading: Icon(
                          Icons.arrow_upward,
                          color: Colors.red,
                          textDirection: TextDirection.ltr,
                        ),
                        title: Text(
                          "برداشت: ${item.amount}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: item.isPaid ? Text("پرداخت شده") : Text("در حال پردازش"),
                        subtitle: Text(item.requestedAt),
                      ),
                      Divider(thickness: 1.5),
                    ]);
                  },
                ),
              ),
            ),
    );
  }
}
