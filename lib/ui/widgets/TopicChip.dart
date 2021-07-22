import 'package:flutter/material.dart';

import '../../models/topic.dart';

class TopicChip extends StatelessWidget {
  final Topic _topic;
  final Function(Topic) removeFunc;

  TopicChip(this._topic, this.removeFunc);

  @override
  Widget build(BuildContext context) {
    return InputChip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(this._topic.title[0].toUpperCase()),
      ),
      label: Text(
        this._topic.title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.grey[100],
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
      onDeleted: () {
        this.removeFunc(this._topic);
      },
      onPressed: () {
        this.removeFunc(this._topic);
      },
    );
  }
}
