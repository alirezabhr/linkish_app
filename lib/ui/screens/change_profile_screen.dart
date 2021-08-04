import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/TopicSelector.dart';
import '../../services/web_api.dart';
import '../../services/utils.dart' as utils;
import '../../models/influencer.dart';
import '../../models/topic.dart';

enum InstagramPageType { general, pro }

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({Key? key}) : super(key: key);

  @override
  _ChangeProfileScreenState createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  late InstagramPageType _pageType;
  bool _flag = false;
  late final String userEmail;
  late final String userIgId;
  bool _isLoading = true;
  bool _isSending = false;
  List<Topic> _topicsList = [];
  List<Topic> _selectedTopicsList = [];

  Future<void> setTopics() async {
    setState(() {
      _isLoading = true;
    });
    List<Topic> topicsList = await WebApi().getTopicsList();
    this._topicsList = topicsList;
    this._topicsList.sort((a, b) => a.title.compareTo(b.title));
    List<Topic> _currentTopics = await utils.getUserTopics();

    for (Topic currentTopic in _currentTopics) {
      _topicsList.removeWhere((element) => element.title == currentTopic.title);
      _selectedTopicsList.add(currentTopic);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    setTopics();
    super.initState();
  }

  void appendItem(Topic value) {
    setState(() {
      this._topicsList.remove(value);
      this._selectedTopicsList.add(value);
      this._topicsList.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  void removeItem(Topic value) {
    setState(() {
      this._topicsList.add(value);
      this._selectedTopicsList.remove(value);
      this._topicsList.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  Future<void> sendData(Influencer influencer) async {
      setState(() {
        _isSending = true;
      });
      bool _isGeneralPage =
      _pageType == InstagramPageType.general
          ? true
          : false;

      List<Topic> _finalTopics = [];
      if (!_isGeneralPage) {
        _finalTopics = this._selectedTopicsList;
      }

      if (!_isGeneralPage && _selectedTopicsList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "هیچ محتوایی برای پیج خود انتخاب نکرده اید."),
          ),
        );
        return;
      }

      Map data = {
        "email": influencer.email,
        "password": influencer.password,
        "instagram_id": influencer.instagramId,
        "province": influencer.province,
        "city": influencer.city,
        "is_general_page": _isGeneralPage,
        "topics": _finalTopics,
        "card_number": influencer.bankCardNo,
        "account_number": influencer.bankAccountNo,
      };

      try {
        await WebApi().updateUserAccount(influencer.userId, data);
        influencer.setUserData(data);
        await influencer.registerUser();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("پروفایل جدید با موفقیت ثبت شد."),
          ),
        );
      } on DioError catch (e) {
        print(e.response!.data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "در حال حاضر این عملیات امکان پذیر نمی باشد."),
          ),
        );
      } finally {
        setState(() {
          _isSending = false;
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    final Influencer influencer = Provider.of<Influencer>(context);
    if (!_flag) {
      _flag = true;
      this.userEmail = influencer.email;
      this.userIgId = influencer.instagramId;
      if (influencer.isGeneralPage) {
        _pageType = InstagramPageType.general;
      } else {
        _pageType = InstagramPageType.pro;
      }
    }
    return Scaffold(
      appBar: AppBar(title: Text("تغییر حساب کاربری")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                        // labelText: 'Password',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ایمیل:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FittedBox(
                              child: Text(
                                userEmail,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                        // labelText: 'Password',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "اینستاگرام:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FittedBox(
                              child: Text(
                                userIgId,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('محتوای پیج من عمومی است'),
                    leading: Radio<InstagramPageType>(
                      value: InstagramPageType.general,
                      groupValue: _pageType,
                      onChanged: (InstagramPageType? value) {
                        setState(() {
                          _pageType = value!;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _pageType = InstagramPageType.general;
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('محتوای پیج من تخصصی است'),
                    leading: Radio<InstagramPageType>(
                      value: InstagramPageType.pro,
                      groupValue: _pageType,
                      onChanged: (InstagramPageType? value) {
                        setState(() {
                          _pageType = value!;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _pageType = InstagramPageType.pro;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 16.0),
                    child: _pageType == InstagramPageType.pro
                        ? TopicSelector(
                            this._topicsList,
                            this._selectedTopicsList,
                            this.appendItem,
                            this.removeItem)
                        : null,
                  ),
                  Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_isSending) {
                          await sendData(influencer);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: _isSending
                                ? CircularProgressIndicator()
                                : Text(
                                    "ثبت",
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
