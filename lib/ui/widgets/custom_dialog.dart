import 'package:flutter/material.dart';

class RegistrationHelpDialog extends StatelessWidget {
  final String _textBody;

  RegistrationHelpDialog(this._textBody);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(
        Icons.lightbulb_outline,
        color: Colors.yellow,
      ),
      content: Text(_textBody),
    );
  }
}
