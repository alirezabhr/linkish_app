import 'package:flutter/material.dart';

import '../../services/web_api.dart';
import '../../models/influencer_ad.dart';

class ApprovedAdList extends StatefulWidget {
  const ApprovedAdList({Key? key}) : super(key: key);

  @override
  _ApprovedAdListState createState() => _ApprovedAdListState();
}

class _ApprovedAdListState extends State<ApprovedAdList> {
  final int _userId = 6;
  bool _isLoading = true;
  List<InfluencerAd> _allSuggestedAdsList = [];
  List<InfluencerAd> _approvedAdsList = [];

  getAds() async {
    setState(() {
      _isLoading = true;
    });
    List<InfluencerAd> _list = await WebApi().getApprovedAds(_userId);
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
    getAds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _approvedAdsList.isEmpty
            ? Text("No Approved Ads")
            : Column(
                children: List.generate(_approvedAdsList.length, (index) {
                  InfluencerAd _ad = _approvedAdsList[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(_ad.ad.title),
                        trailing: Text(_ad.approvedAt.substring(0, 19)),
                        subtitle: Text("clicks: ${_ad.clicks}"),
                        onTap: () {
                        },
                      ),
                      Divider(thickness: 1.5),
                    ],
                  );
                }),
              );
  }
}
