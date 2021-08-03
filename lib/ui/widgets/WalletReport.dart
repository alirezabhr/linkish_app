import 'package:flutter/material.dart';

import '../../models/influencer_ad.dart';
import '../../services/utils.dart';

class WalletReport extends StatelessWidget {
  final InfluencerAd influencerAd;

  WalletReport(this.influencerAd);

  @override
  Widget build(BuildContext context) {
    var _multiple = (100-influencerAd.deduction)/100;
    int _income = (influencerAd.clicks * _multiple).round() * influencerAd.cpc;
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.arrow_downward,
            color: Colors.green,
            textDirection: TextDirection.ltr,
          ),
          title: Text(influencerAd.ad.title),
          trailing: Text(
            "درآمد: $_income",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(getNextDay(influencerAd.approvedAt)),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }
}
