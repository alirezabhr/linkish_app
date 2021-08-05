import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/influencer.dart';
import '../../services/web_api.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  bool _isSending = false;

  Future<void> sendMsg(Influencer influencer, String title, String body) async {
    setState(() {
      _isSending = true;
    });

    String userEmail = influencer.email;
    await WebApi().sendContactUsMessage(userEmail, title, body);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("پیام شما با موفقیت ارسال شد."),
      ),
    );

    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Influencer influencer = Provider.of<Influencer>(context);
    return Scaffold(
      appBar: AppBar(title: Text("ارتباط با ما")),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        'عنوان: ',
                        style: TextStyle(fontSize: 22),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20.0, right: 8.0),
                          child: TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value == "") {
                                return 'فیلد خالی است.';
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'متن: ',
                        style: TextStyle(fontSize: 22),
                      ),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20.0, right: 8.0),
                          child: TextFormField(
                            controller: _bodyController,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            minLines: 7,
                            maxLines: 10,
                            validator: (value) {
                              if (value!.isEmpty || value == "") {
                                return 'فیلد خالی است.';
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (!_isSending) {
                        sendMsg(
                          influencer,
                          _titleController.text,
                          _bodyController.text,
                        );
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _isSending
                            ? CircularProgressIndicator(color: Colors.white,)
                            : Text(
                                'ارسال',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
