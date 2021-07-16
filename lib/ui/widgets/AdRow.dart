import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/Ad.dart';

class AdRow extends StatefulWidget {
  @override
  _AdRowState createState() => _AdRowState();
}

class _AdRowState extends State<AdRow> {
  late Image _image;
  late Ad _ad;

  getAds() {
    _ad = new Ad("New Ad", "https://www.google.com", false,
        "http://192.168.1.9:8000/ad/media/soori_land.jpg", ["sport", "news"]);
  }

  showPreviousAd() {}

  showNextAd() {}

  @override
  void initState() {
    this.getAds();
    _image = Image.network("https://www.bruna.nl/images/active/carrousel/fullsize/9789492934468_front.jpg");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

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
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: showPreviousAd,
                  icon: Icon(Icons.chevron_left),
                  iconSize: 40,
                ),
                Container(
                  height: height * 0.6,
                  width: width * 0.65,
                  decoration: BoxDecoration(border: Border.all()),
                  child: _image,
                ),
                IconButton(
                  onPressed: showNextAd,
                  icon: Icon(Icons.chevron_right),
                  iconSize: 40,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Confirm"), style: buttonStyle,),
                ElevatedButton(onPressed: () {}, child: Text("Reject"), style: buttonStyle),
                ElevatedButton(onPressed: () {}, child: Text("Report"), style: buttonStyle),
              ],
            ),
          )
        ],
      ),
    );
  }
}
