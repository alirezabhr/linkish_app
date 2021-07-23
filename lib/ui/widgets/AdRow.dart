import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkish/ui/widgets/ReportDialog.dart';

import '../../models/suggested_ad.dart';
import '../../services/web_api.dart';

class AdRow extends StatefulWidget {
  @override
  _AdRowState createState() => _AdRowState();
}

class _AdRowState extends State<AdRow> {
  final int _userId = 8;
  bool _isLoading = true;
  List<SuggestedAd> _allSuggestedAdsList = [];
  List<SuggestedAd> _suggestedAdsList = [];
  late SuggestedAd _suggestedAd;
  bool _hasNext = false;
  bool _hasBefore = false;

  getAds() async {
    setState(() {
      _hasNext = false;
      _hasBefore = false;
      _isLoading = true;
    });
    List<SuggestedAd> _list = await WebApi().getSuggestedAds(_userId);
    setState(() {
      this._allSuggestedAdsList = _list;
      this._suggestedAdsList = [];
      for (SuggestedAd item in _allSuggestedAdsList) {
        if (!item.isApproved) {
          this._suggestedAdsList.add(item);
        }
      }

      if (_suggestedAdsList.length > 0) {
        this._suggestedAd = _suggestedAdsList.first;
        if (_suggestedAdsList.last != this._suggestedAd) {
          this._hasNext = true;
        }
      }

      _isLoading = false;
    });
  }

  showPreviousAd() {
    int index =
        _suggestedAdsList.indexOf(_suggestedAd);
    setState(() {
      _suggestedAd = _suggestedAdsList[index - 1];
      _hasNext = true;
      if (_suggestedAdsList.first == _suggestedAd) {
        _hasBefore = false;
      } else {
        _hasBefore = true;
      }
    });
  }

  showNextAd() {
    int index =
        _suggestedAdsList.indexOf(_suggestedAd);
    setState(() {
      _suggestedAd = _suggestedAdsList[index + 1];
      _hasBefore = true;
      if (_suggestedAdsList.last == _suggestedAd) {
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
          : _suggestedAdsList.isEmpty
              ? Center(
                  child: Text(
                  "No Suggested Ads",
                  style: TextStyle(fontSize: 24),
                ))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        this._suggestedAd.ad.title,
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
                                "${WebApi.baseUrl}${_suggestedAd.ad.imageUrl}"),
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
                            onPressed: () async {
                              await WebApi().confirmAd(this._userId, this._suggestedAd.id);
                              await getAds();
                            },
                            child: Text("Confirm"),
                            style: buttonStyle,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await WebApi().rejectAd(this._userId, this._suggestedAd.id);
                                await getAds();
                              },
                              child: Text("Reject"),
                              style: buttonStyle),
                          ElevatedButton(
                              onPressed: () {
                                showDialog<void>(context: context, builder: (context) => ReportDialog());
                              },
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
