import 'package:flutter/material.dart';

import '../../models/topic.dart';
import '../../services/web_api.dart';
import 'TopicChip.dart';

class TopicSelector extends StatefulWidget {
  @override
  _TopicSelectorState createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  String dropdownValue = "";
  List<String> _topicsTitleList = [];
  List<String> _selectedItems = [];

  setData() async {
    List<Topic> topicsList = await WebApi().getTopicsList();  // todo should get it from provider
    setState(() {
      this._topicsTitleList = List.generate(topicsList.length, (index) => topicsList[index].title);
      this.dropdownValue = topicsList.first.title;
    });
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _topicsTitleList.isEmpty
        ? CircularProgressIndicator()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          items: _topicsTitleList.map((element) {
            return DropdownMenuItem(value: element, child: Text(element));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _topicsTitleList.remove(newValue);
              dropdownValue = _topicsTitleList.first;
              _selectedItems.add(newValue!);
            });
          },
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple, fontSize: 18),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
        ),
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List<Widget>.generate(_selectedItems.length, (index) => TopicChip(_selectedItems[index])),
        )
      ],
    );
  }
}
