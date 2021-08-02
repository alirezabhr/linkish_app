import 'package:flutter/material.dart';

import '../../models/influencer_ad.dart';

class WalletActiveAd extends StatelessWidget {
  final InfluencerAd influencerAd;
  WalletActiveAd(this.influencerAd);
  final DEDUCTION_MULTIPLE = 0.9;

  @override
  Widget build(BuildContext context) {
    final String startTime = influencerAd.approvedAt;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(5)
      ),
      child: ListTile(
        leading: Icon(
          Icons.trending_up,
          color: Colors.green,
          textDirection: TextDirection.ltr,
        ),
        title: Text(influencerAd.ad.title),
        trailing: Text(
          "درآمد: ${(influencerAd.income * DEDUCTION_MULTIPLE).round()}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text('شروع کمپین: '),
            Text(startTime),
          ],
        ),
      ),
    );
  }
}


class ApprovedActiveAd extends StatelessWidget {
  final InfluencerAd influencerAd;
  ApprovedActiveAd(this.influencerAd);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        title: Text(influencerAd.ad.title),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text("شروع کمپین: "),
              Text(influencerAd.approvedAt),
            ],
          ),
        ),
      ),
    );
  }
}
