class Ad {
  String _title;
  String _baseLink;
  bool _isVideo;
  String _mediaUrl;
  List<String> _topics;

  Ad(this._title, this._baseLink, this._isVideo, this._mediaUrl, this._topics);

  List<String> get topics => _topics;

  String get mediaUrl => _mediaUrl;

  bool get isVideo => _isVideo;

  String get baseLink => _baseLink;

  String get title => _title;
}