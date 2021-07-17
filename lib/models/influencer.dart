class Influencer {
  late String _email;
  late String _password;
  late String _instagramId;
  late String _location;
  late bool _isGeneralPage;
  late List<String> _topicsList;

  Influencer(this._email, this._password, this._instagramId, this._location,
      this._isGeneralPage, this._topicsList);

  String get email => _email;
  String get password => _password;
  String get instagramId => _instagramId;
  String get location => _location;
  bool get isGeneralPage => _isGeneralPage;
  List<String> get topicsList => _topicsList;
}