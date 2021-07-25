import 'ad.dart';

class InfluencerAd {
  String _shortLink;
  int _clicks;
  String _approvedAt;
  Ad _ad;
  late int income;

  InfluencerAd(this._shortLink, this._clicks, this._approvedAt, this._ad);


  String get shortLink => _shortLink;
  Ad get ad => _ad;
  String get approvedAt => _approvedAt;
  int get clicks => _clicks;
}