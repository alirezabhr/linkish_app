import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'approved_ad_list_tile.dart';

import '../../services/web_api.dart';
import '../../models/influencer_ad.dart';
import '../../models/influencer.dart';

class ApprovedAdList extends StatefulWidget {
  const ApprovedAdList({Key? key}) : super(key: key);

  @override
  _ApprovedAdListState createState() => _ApprovedAdListState();
}

class _ApprovedAdListState extends State<ApprovedAdList> {
  late final Influencer _influencer;
  bool flag = false;
  int _userId = 0;
  bool _isLoading = true;
  List<InfluencerAd> _allSuggestedAdsList = [];
  List<InfluencerAd> _approvedAdsList = [];

  setUserId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _userId = _prefs.getInt("id")!;
  }

  getAds() async {
    if (_userId == 0) {
      await this.setUserId();
    }

    setState(() {
      _isLoading = true;
    });
    List<InfluencerAd> _list = [];
    try {
      _list = await WebApi().getWallet(_userId);
    } on DioError catch (e) {
      if (e.response!.statusCode == 401) {
        String _newToken = await WebApi().obtainToken();
        _influencer.setToken(_newToken);
        _list = await WebApi().getWallet(_userId);
      }
    }
    setState(() {
      this._allSuggestedAdsList = _list;
      this._approvedAdsList = [];

      for (InfluencerAd item in _allSuggestedAdsList) {
        this._approvedAdsList.insert(0, item);
      }

      _isLoading = false;
    });
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
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _approvedAdsList.isEmpty
            ? FittedBox(
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/images/empty_state.gif'),
                    ),
                    Text(
                      "هیچ تبلیغ پذیرفته شده ای ندارید",
                      style: TextStyle(fontSize: 40),
                    ),
                  ],
                ),
              )
            : Column(
                children: List.generate(_approvedAdsList.length, (index) {
                  InfluencerAd _ad = _approvedAdsList[index];
                  return Column(
                    children: [
                      ApprovedAdListTile(_ad),
                      Divider(thickness: 1.5),
                    ],
                  );
                }),
              );
  }
}
