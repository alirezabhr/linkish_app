class Ad {
  late int id;
  String _title;
  String _baseLink;
  List<String> _topics;
  bool _isVideo;
  String _imageUrl;
  late String videoUrl;
  late String shortLink;

  Ad(this._title, this._baseLink, this._isVideo, this._imageUrl, this._topics);

  List<String> get topics => _topics;
  String get imageUrl => _imageUrl;
  bool get isVideo => _isVideo;
  String get baseLink => _baseLink;
  String get title => _title;
}