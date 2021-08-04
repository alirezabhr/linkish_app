class Withdraw {
  int _amount;
  bool _isPaid;
  bool _isRejected;
  String _requestedAt;

  Withdraw(this._amount, this._isPaid, this._isRejected, this._requestedAt);

  String get requestedAt => _requestedAt;

  bool get isRejected => _isRejected;

  bool get isPaid => _isPaid;

  int get amount => _amount;
}