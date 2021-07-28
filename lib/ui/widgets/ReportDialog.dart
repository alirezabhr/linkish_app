import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/web_api.dart';

final List<String> _reportMessages = [
  "محتوای غیراخلاقی",
  "محتوای سیاسی",
  "سایر"
];

class ReportDialog extends StatefulWidget {
  final int _userPk;
  final int _adId;
  final Function() report;

  ReportDialog(this._userPk, this._adId, this.report);

  @override
  _ReportDialogState createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _reportController = TextEditingController();
  String dropdownValue = _reportMessages.first;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text('گزارش مشکل تبلیغ'),
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          child: Wrap(
            children: [
              DropdownButton<String>(
                value: dropdownValue,
                items: _reportMessages.map((element) {
                  return DropdownMenuItem(value: element, child: Text(element));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: dropdownValue == _reportMessages.last
                    ? TextFormField(
                        controller: _reportController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'گزارش',
                          hintText: 'توضیح گزارش',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'مشکل را شرح دهید';
                          }
                        },
                      )
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String reportMsg;
                if (dropdownValue == _reportMessages.last) {
                  reportMsg = _reportController.text;
                } else {
                  reportMsg = dropdownValue;
                }
                await WebApi().reportAd(this.widget._userPk, this.widget._adId, reportMsg);
                widget.report();
                Navigator.of(context).pop();
              }
            },
            child: Text('ثبت گزارش'),
          ),
        ],
      ),
    );
  }
}
