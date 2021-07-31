import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_insta/flutter_insta.dart';

import '../widgets/location_selector.dart';
import '../widgets/TopicSelector.dart';
import '../../models/topic.dart';
import '../../models/influencer.dart';
import '../../services/web_api.dart';

enum InstagramPageType { general, pro }

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late Influencer influencer;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _igIdController = TextEditingController();
  late final List<dynamic> _provincesAndCities;
  String _province = "";
  String _city = "";
  InstagramPageType? _pageType = InstagramPageType.general;
  bool _isLoadingProvincesAndCities = false;
  bool _isLoading = false;

  List<Topic> _topicsList = [];
  List<Topic> _selectedTopicsList = [];

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

  void setProvinceAndCity(String province, String city) {
    setState(() {
      this._province = province;
      this._city = city;
    });
  }

  setData() async {
    List<Topic> topicsList = await WebApi().getTopicsList();
    this._topicsList = topicsList;
    this._topicsList.sort((a, b) => a.title.compareTo(b.title));
  }

  Future<bool> isValidPage(String instagramId) async {
    try {
      FlutterInsta flutterInsta = new FlutterInsta();
      await flutterInsta.getProfileData(instagramId);
      int followers = int.parse(flutterInsta.followers!);
      if (followers < 10000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("تعداد فالوئر شما کمتر از 10هزار نفر است")),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("آیدی اینستاگرام نامعتبر است")),
      );
      return false;
    }
    return true;
  }

  Future<void> loadCities() async {
    setState(() {
      _isLoadingProvincesAndCities = true;
    });
    final String response = await rootBundle.loadString(
        'assets/jsons/iran_cities.json');
    _provincesAndCities = await json.decode(response);
    setState(() {
      _isLoadingProvincesAndCities = false;
    });
    this._province = _provincesAndCities.first['name'];
    this._city = _provincesAndCities.first['cities'].first['name'];
  }

  @override
  void initState() {
    this.loadCities();
    this.setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    influencer = Provider.of<Influencer>(context);
    String emailAddress = ModalRoute
        .of(context)!
        .settings
        .arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("ثبت نام لینکیش"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: SingleChildScrollView(
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
                    child: FittedBox(
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
                                emailAddress,
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'رمزعبور',
                      prefixIcon: IconButton(
                        icon: _obscurePassword
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                    obscureText: this._obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فیلد رمزعبور خالی است';
                      }
                      if (value.length < 8) {
                        return 'رمز عبور باید شامل حداقل 8 کاراکتر باشد';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _igIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'آیدی اینستاگرام',
                    ),
                    textDirection: TextDirection.ltr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'فیلد آیدی اینستاگرام خالی است';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: _isLoadingProvincesAndCities
                      ? CircularProgressIndicator()
                      : LocationSelector(_provincesAndCities, this.setProvinceAndCity),
                ),
                ListTile(
                  title: const Text('محتوای پیج من عمومی است'),
                  leading: Radio<InstagramPageType>(
                    value: InstagramPageType.general,
                    groupValue: _pageType,
                    onChanged: (InstagramPageType? value) {
                      setState(() {
                        _pageType = value;
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
                        _pageType = value;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (!_isLoading) {
                            setState(() {
                              _isLoading = true;
                            });

                            // bool isValidInstagram = await isValidPage(_igIdController.text);
                            // print("is valid page: $isValidInstagram");
                            bool isValidInstagram = true;
                            if (isValidInstagram) {
                              bool isGeneral = _pageType ==
                                  InstagramPageType.general ? true : false;
                              try {
                                Map data = {
                                  "email": emailAddress,
                                  "password": _passwordController.text,
                                  "instagram_id": _igIdController.text,
                                  "province": _province,
                                  "city": _city,
                                  "is_general_page": isGeneral,
                                  "topics": this._selectedTopicsList,
                                };
                                Map response = await WebApi().influencerSignup(data);
                                influencer.setUserData(data);
                                influencer.setUserId(response["id"]);
                                influencer.setToken("jwt " + response["token"]);
                                influencer.registerUser();
                                Navigator.pushReplacementNamed(context, "/home");
                              } on DioError catch (e) {
                                print(e.response!
                                    .data); // todo should add a validation, show the exception
                              }
                            }

                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white,)
                          : Text(
                        "ثبت نام",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
