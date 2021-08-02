import 'package:flutter/material.dart';

import '../../models/influencer_ad.dart';
import '../../services/utils.dart';

class ApprovedAdListTile extends StatefulWidget {
  final InfluencerAd influencerAd;

  ApprovedAdListTile(this.influencerAd);

  @override
  _ApprovedAdListTileState createState() => _ApprovedAdListTileState();
}

class _ApprovedAdListTileState extends State<ApprovedAdListTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return _isExpanded
        ? Container(
            child: ListTile(
              title: Text(widget.influencerAd.ad.title),
              trailing: Text("کلیک ها: ${widget.influencerAd.clicks}"),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("شروع کمپین: "),
                        Text(widget.influencerAd.approvedAt),
                      ],
                    ),
                    Row(
                      children: [
                        Text("پایان کمپین: "),
                        Text(
                            "${getNextDay(widget.influencerAd.approvedAt)}"),
                      ],
                    ),
                    Text(
                      "دریافتی: ${widget.influencerAd.income} تومان",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          )
        : Container(
            child: ListTile(
              title: Text(widget.influencerAd.ad.title),
              trailing: Text("کلیک ها: ${widget.influencerAd.clicks}"),
              subtitle: Text(widget.influencerAd.approvedAt.substring(0, 19)),
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          );
  }
}
