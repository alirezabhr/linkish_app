import 'ad.dart';

class SuggestedAd {
  final int _id;
  final bool _isApproved;
  final String _suggestedAt;
  final Ad _ad;

  SuggestedAd(this._id, this._isApproved, this._suggestedAt, this._ad);

  Ad get ad => _ad;
  String get suggestedAt => _suggestedAt;
  bool get isApproved => _isApproved;
  int get id => _id;
}