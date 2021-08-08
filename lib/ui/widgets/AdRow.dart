import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/ReportDialog.dart';
import '../widgets/ad_detail.dart';

import '../../models/influencer.dart';
import '../../models/suggested_ad.dart';
import '../../models/influencer_ad.dart';
import '../../services/web_api.dart';
import '../../services/utils.dart';

class AdRow extends StatefulWidget {
  @override
  _AdRowState createState() => _AdRowState();
}

class _AdRowState extends State<AdRow> {
  late final Influencer _influencer;
  bool flag = false;
  int _userId = 0;
  bool _isLoading = true;
  bool _hasActiveAd = false;
  List<SuggestedAd> _suggestedAdsList = [];
  late InfluencerAd _activeAd;
  late SuggestedAd _suggestedAd;
  bool _hasNext = false;
  bool _hasBefore = false;

  setUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _userId = _prefs.getInt("id")!;
  }

  getAds() async {
    if (_userId == 0) {
      await this.setUserId();
    }

    setState(() {
      _hasNext = false;
      _hasBefore = false;
      _hasActiveAd = false;
      _isLoading = true;
    });

    List<InfluencerAd> _list1 = [];
    List<SuggestedAd> _list2 = [];
    try {
      _list1 = await WebApi().getApprovedAds(_userId);
      _list2 = await WebApi().getSuggestedAds(_userId);
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        String _newToken = await WebApi().obtainToken();
        _influencer.setToken(_newToken);
        _list1 = await WebApi().getApprovedAds(_userId);
        _list2 = await WebApi().getSuggestedAds(_userId);
      }
    }

    setState(() {
      if (_list1.isNotEmpty) {
        _activeAd = _list1.last;
        if (isActiveAd(_activeAd)) {
          _hasActiveAd = true;
        }
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

  void _reportAd() async {
    await getAds();
  }

  @override
  void initState() {
    this.getAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (flag == false) {
      _influencer = Provider.of<Influencer>(context);
      flag = true;
    }
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Container(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasActiveAd
              ? AdDetail(this._activeAd)
              : _suggestedAdsList.isEmpty
                  ? Center(
                      child: FittedBox(
                        child: Column(
                          children: [
                            Image(
                              image:
                                  AssetImage('assets/images/empty_state.gif'),
                            ),
                            Text(
                              "هیچ تبلیغی پیشنهاد نشده است",
                              style: TextStyle(fontSize: 40),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
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
                                height: height * 0.55,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.check_sharp),
                                onPressed: () async {
                                  await WebApi().confirmAd(
                                      this._userId, this._suggestedAd.id);
                                  await getAds();
                                },
                                label: Text("تایید تبلیغ"),
                                style: buttonStyle,
                              ),
                              ElevatedButton.icon(
                                  icon: Icon(Icons.close_sharp),
                                  onPressed: () async {
                                    await WebApi().rejectAd(
                                        this._userId, this._suggestedAd.id);
                                    await getAds();
                                  },
                                  label: Text("مرتبط نیست"),
                                  style: buttonStyle),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: TextButton.icon(
                            icon: Icon(Icons.warning_amber_rounded),
                            onPressed: () {
                              showDialog<void>(
                                  context: context,
                                  builder: (context) => ReportDialog(
                                        this._userId,
                                        this._suggestedAd.id,
                                        this._reportAd,
                                      ));
                            },
                            label: Text(
                              "گزارش مشکل",
                              style: TextStyle(color: Colors.red),
                            ),
                            style: ElevatedButton.styleFrom(),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
