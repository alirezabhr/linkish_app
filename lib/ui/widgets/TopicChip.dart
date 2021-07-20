import 'package:flutter/material.dart';

class TopicChip extends StatelessWidget {
  final String label;

  TopicChip(this.label);

  @override
  Widget build(BuildContext context) {
    return InputChip(
      labelPadding: EdgeInsets.all(2.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Text(label[0].toUpperCase()),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.grey[100],
      elevation: 6.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
      onDeleted: () {
        removeItem();
      },
      onPressed: () {
        removeItem();
      },
    );
  }

  removeItem() {
    print("hellp");
  }
}
