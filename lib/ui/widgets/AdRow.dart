import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkish/ui/widgets/ad_detail.dart';

import '../widgets/ReportDialog.dart';

import '../../models/suggested_ad.dart';
import '../../models/influencer_ad.dart';
import '../../services/web_api.dart';
import '../../services/utils.dart';

class AdRow extends StatefulWidget {
  @override
  _AdRowState createState() => _AdRowState();
}

class _AdRowState extends State<AdRow> {
  final int _userId = 6;
  bool _isLoading = true;
  bool _hasActiveAd = false;
  List<SuggestedAd> _suggestedAdsList = [];
  late InfluencerAd _activeAd;
  late SuggestedAd _suggestedAd;
  bool _hasNext = false;
  bool _hasBefore = false;

  getAds() async {
    setState(() {
      _hasNext = false;
      _hasBefore = false;
      _hasActiveAd = false;
      _isLoading = true;
    });
    List<InfluencerAd> _list1 = await WebApi().getApprovedAds(_userId);
    List<SuggestedAd> _list2 = await WebApi().getSuggestedAds(_userId);
    setState(() {
      _activeAd = _list1.last;
      if (isActiveAd(_activeAd)) {
        _hasActiveAd = true;
      }

      this._suggestedAdsList = [];
      for (SuggestedAd item in _list2) {
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
    int index = _suggestedAdsList.indexOf(_suggestedAd);
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
    int index = _suggestedAdsList.indexOf(_suggestedAd);
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
          : _hasActiveAd ? AdDetail(this._activeAd)
          : _suggestedAdsList.isEmpty
              ? Center(
                  child: Text(
                  "No Suggested Ads",
                  style: TextStyle(fontSize: 24),
                ))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      child: Text(
                        this._suggestedAd.ad.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6.0),
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
                              // await WebApi().confirmAd(
                              //     this._userId, this._suggestedAd.id);
                              // await getAds();
                              List<InfluencerAd> _infList = await WebApi().getApprovedAds(this._userId);
                              InfluencerAd _approvedAd = _infList.last;
                              Navigator.of(context).pushNamed('/detail', arguments: _approvedAd);
                            },
                            child: Text("Confirm"),
                            style: buttonStyle,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await WebApi().rejectAd(
                                    this._userId, this._suggestedAd.id);
                                await getAds();
                              },
                              child: Text("Reject"),
                              style: buttonStyle),
                          ElevatedButton(
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (context) => ReportDialog(
                                        this._userId, this._suggestedAd.id));
                                // todo callback function for refreshing
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
