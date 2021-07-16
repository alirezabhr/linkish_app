import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkish/ui/widgets/CustomVideoPlayer.dart';

import '../../models/Ad.dart';

class AdRow extends StatefulWidget {
  @override
  _AdRowState createState() => _AdRowState();
}

class _AdRowState extends State<AdRow> {
  late Ad _ad;

  getAds() {
    _ad = new Ad("New Ad", "https://www.google.com", false,
        "https://i.dlpng.com/static/png/6478590_preview.png",
        ["sport", "news"]);
  }

  showPreviousAd() {}

  showNextAd() {}

  @override
  void initState() {
    this.getAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              this._ad.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: showPreviousAd, icon: Icon(Icons.chevron_left), iconSize: 40,),
              Container(
                width: width * 0.65,
                child: CustomVideoPlayer(),
              ),
              IconButton(onPressed: showNextAd, icon: Icon(Icons.chevron_right), iconSize: 40,),
            ],
          ),
        ],
      ),
    );
  }
}
