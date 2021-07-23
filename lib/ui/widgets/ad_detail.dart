import 'package:flutter/material.dart';

import '../../models/influencer_ad.dart';
import '../../services/web_api.dart';
import '../../services/utils.dart';

class AdDetail extends StatelessWidget {
  final InfluencerAd influencerAd;

  AdDetail(this.influencerAd);

  @override
  Widget build(BuildContext context) {
    final String remainingTime =
        calculateRemainTime(this.influencerAd.approvedAt);
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              influencerAd.ad.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: BoxDecoration(),
            child:
                Image.network("${WebApi.baseUrl}${influencerAd.ad.imageUrl}"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(influencerAd.shortLink),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("copy"),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Text(
                  "media type: ${influencerAd.ad.isVideo ? "video" : "image"}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("download"),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "remaining: " + remainingTime,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
