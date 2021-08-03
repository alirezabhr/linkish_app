import 'ad.dart';

class InfluencerAd {
  String _shortLink;
  int _clicks;
  String _approvedAt;
  Ad _ad;
  int _deduction;
  int _cpc;

  InfluencerAd(
    this._shortLink,
    this._clicks,
    this._deduction,
    this._cpc,
    this._approvedAt,
    this._ad,
  );

  String get shortLink => _shortLink;
  Ad get ad => _ad;
  String get approvedAt => _approvedAt;
  int get clicks => _clicks;
  int get deduction => _deduction;
  int get cpc => _cpc;
}
