import 'package:flutter/material.dart';

import '../../models/topic.dart';
import 'TopicChip.dart';

class TopicSelector extends StatelessWidget {
  final List<Topic> _topics;
  final List<Topic> _selectedTopics;
  final Function(Topic) appendFunc;
  final Function(Topic) removeFunc;
  TopicSelector(this._topics, this._selectedTopics, this.appendFunc, this.removeFunc);

  @override
  Widget build(BuildContext context) {
    Topic dropdownValue = this._topics.first;

    return this._topics.isEmpty
        ? CircularProgressIndicator()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<Topic>(
          value: dropdownValue,
          items: this._topics.map((element) {
            return DropdownMenuItem(value: element, child: Text(element.title));
          }).toList(),
          onChanged: (Topic? newValue) {
            if (this._topics.length > 1) {
              dropdownValue = this._topics.first;
              this.appendFunc(newValue!);
            }
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
          children: List<Widget>.generate(this._selectedTopics.length, (index) => TopicChip(this._selectedTopics[index], this.removeFunc)),
        )
      ],
    );
  }
}
