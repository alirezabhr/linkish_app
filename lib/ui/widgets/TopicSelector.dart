import 'package:flutter/material.dart';

import '../../services/web_api.dart';
import 'TopicChip.dart';

class TopicSelector extends StatefulWidget {
  @override
  _TopicSelectorState createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  String dropdownValue = "";
  List<String> _topicList = [];
  List<String> _selectedItems = [];

  setData() async {
    List<String> tmpList = await WebApi().getTopicsList();
    setState(() {
      this._topicList = tmpList;
      this.dropdownValue = tmpList.first;
    });
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _topicList.isEmpty
        ? CircularProgressIndicator()
        : Column(
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          items: _topicList.map((element) {
            return DropdownMenuItem(value: element, child: Text(element));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _topicList.remove(newValue);
              dropdownValue = _topicList.first;
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
