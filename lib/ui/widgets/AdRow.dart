import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/ad.dart';
import '../../services/web_api.dart';

class AdRow extends StatefulWidget {
  @override
  _AdRowState createState() => _AdRowState();
}

class _AdRowState extends State<AdRow> {
  final int _userId = 3;
  bool _isLoading = true;
  List<Ad> _adsList = [];
  late Ad _ad;
  bool _hasNext = false;
  bool _hasBefore = false;

  getAds() async {
    List<Ad> _list = await WebApi().getDisapprovedAds(this._userId);
    setState(() {
      this._adsList = _list;

      if (_list.length > 0) {
        this._ad = _adsList.first;
        if (_adsList.last != _ad) {
          this._hasNext = true;
        }
      }

      _isLoading = false;
    });
  }

  showPreviousAd() {
    int index = _adsList.indexOf(_ad);
    setState(() {
      _ad = _adsList[index - 1];
      _hasNext = true;
      if (_adsList.first == _ad) {
        _hasBefore = false;
      } else {
        _hasBefore = true;
      }
    });
  }

  showNextAd() {
    int index = _adsList.indexOf(_ad);
    setState(() {
      _ad = _adsList[index + 1];
      _hasBefore = true;
      if (_adsList.last == _ad) {
        _hasNext = false;
      } else {
        _hasNext = true;
      }
    });
  }

  @override
  void initState() {
    this.getAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Container(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _adsList.isEmpty
              ? Center(child: Text("No Suggested Ads", style: TextStyle(fontSize: 24),))
              : Column(
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
                            // right button
                            onPressed: _hasBefore ? showPreviousAd : null,
                            icon: Icon(Icons.chevron_left),
                            iconSize: 40,
                            color: _hasBefore ? Colors.black : Colors.grey,
                          ),
                          Container(
                            height: height * 0.6,
                            width: width * 0.65,
                            decoration: BoxDecoration(border: Border.all()),
                            child: Image.network(
                                "${WebApi.baseUrl}${_ad.imageUrl}"),
                          ),
                          IconButton(
                            // left button
                            onPressed: _hasNext ? showNextAd : null,
                            icon: Icon(Icons.chevron_right),
                            iconSize: 40,
                            color: _hasNext ? Colors.black : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              WebApi().confirmAd(this._userId, this._ad.id);
                            },
                            child: Text("Confirm"),
                            style: buttonStyle,
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              child: Text("Reject"),
                              style: buttonStyle),
                          ElevatedButton(
                              onPressed: () {},
                              child: Text("Report"),
                              style: buttonStyle),
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}
