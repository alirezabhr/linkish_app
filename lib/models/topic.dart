class Topic {
  int _id;
  String _title;

  Topic(this._id, this._title);

  String get title => _title;
  int get id => _id;

  Map toMap() {
    Map map = {
      'id': this._id,
      'title': this._title,
    };
    return map;
  }

  static Topic mapToTopic(Map map) {
    return Topic(map['id'], map['title']);
  }
}