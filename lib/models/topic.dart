
class Topic {
  int _id;
  String _title;

  Topic(this._id, this._title);

  String get title => _title;
  int get id => _id;
}

class TopicList {
  List<Topic> _topics = [];

  List<Topic> get topics => _topics;
  set topics(List<Topic> value) {
    _topics = value;
  }
  void addTopic(Topic topic) {
    _topics.add(topic);
  }

  List<int> getTopicsId(List<String> topicsTitle) {
    List<int> list = [];
    List<String> allTopicsTitles = List.generate(_topics.length, (index) => _topics[index].title);

    topicsTitle.forEach((element) {
      int index = allTopicsTitles.indexOf(element);
      list.add(_topics[index].id);
    });

    return list;
  }
}