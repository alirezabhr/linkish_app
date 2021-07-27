import 'package:flutter/material.dart';

import '../../models/influencer_ad.dart';
import '../../services/utils.dart';

class WalletReport extends StatelessWidget {
  final InfluencerAd influencerAd;

  WalletReport(this.influencerAd);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.call_received,
            color: Colors.green,
            textDirection: TextDirection.ltr,
          ),
          title: Text(influencerAd.ad.title),
          trailing: Text(
            "earning: ${influencerAd.income}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(getNextDay(influencerAd.approvedAt.substring(0, 19))),
        ),
        Divider(thickness: 1.5),
      ],
    );
  }
}
