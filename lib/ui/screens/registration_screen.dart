import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../widgets/location_selector.dart';
import '../widgets/TopicSelector.dart';
import '../widgets/custom_dialog.dart';
import '../../models/topic.dart';
import '../../models/influencer.dart';
import '../../services/web_api.dart';
import '../../services/utils.dart' as utils;

enum InstagramPageType { general, pro }
enum LocationType { all, specific }

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late Influencer influencer;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late final List<dynamic> _provincesAndCities;
  String _province = "";
  String _city = "";
  LocationType? _locType = LocationType.all;
  InstagramPageType? _pageType = InstagramPageType.pro;
  bool _isRegisteringProvincesAndCities = false;
  bool _isRegistering = false;

  List<Topic> _topicsList = [];
  List<Topic> _selectedTopicsList = [];

  final String _locationHelpText =
      "برخی تبلیغات در لینکیش فقط برای نقطه جغرافیایی خاصی می‌باشد"
      " که اگر هماهنگ با داده‌های شما باشد،"
      " شانس شما برای شرکت در کمپین تبلیغاتی بالا می‌رود.";
  final String _topicHelpText = "وجود همخوانی بین موضوعات انتخاب شده محتوا و "
      "پست‌های شما باعث افزایش استقبال از تبلیغ می‌گردد.";

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

  Future<void> loadCities() async {
    setState(() {
      _isRegisteringProvincesAndCities = true;
    });
    final String response =
        await rootBundle.loadString('assets/jsons/iran_cities.json');
    _provincesAndCities = await json.decode(response);
    setState(() {
      _isRegisteringProvincesAndCities = false;
    });
    this._province = _provincesAndCities.first['name'];
    this._city = _provincesAndCities.first['cities'].first['name'];
  }

  void registerUser(Map routeData) async {
    bool isAllLocations = _locType == LocationType.all ? true : false;
    if (isAllLocations) {
      this._province = "همه";
      this._city = "همه";
    }

    bool isGeneralPage = _pageType == InstagramPageType.general ? true : false;
    if (!isGeneralPage && _selectedTopicsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("هیچ محتوایی برای پیج خود انتخاب نکرده اید."),
        ),
      );
    }

    if (!_isRegistering) {
      setState(() {
        _isRegistering = true;
      });
      List<Topic> _finalTopics = [];
      if (!isGeneralPage) {
        _finalTopics = this._selectedTopicsList;
      }

      // bool isValidInstagram = await isValidPage(_igIdController.text);
      // print("is valid page: $isValidInstagram");
      bool isValidInstagram = true;
      if (isValidInstagram) {
        String os = utils.getDeviceOs();
        try {
          Map sendData = {
            "email": routeData['email'],
            "password": _passwordController.text,
            "instagram_id": routeData['instagram_id'],
            "province": _province,
            "city": _city,
            "is_general_page": isGeneralPage,
            "topics": _finalTopics,
            "followers": routeData['followers'],
            "is_business_page": routeData['is_business_page'],
            "is_professional_page": routeData['is_professional_page'],
            "page_category_enum": routeData['page_category_enum'],
            "page_category_name": routeData['page_category_name'],
            "os": os,
          };
          Map response = await WebApi().influencerSignup(sendData);
          influencer.setUserData(sendData);
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
        _isRegistering = false;
      });
    }
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
    Map routeData = ModalRoute.of(context)!.settings.arguments as Map;
    String emailAddress = routeData['email'];
    String instagramId = routeData['instagram_id'];
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
                              instagramId,
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
                Divider(thickness: 1.0),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        "موقعیت مکانی",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RegistrationHelpDialog(_locationHelpText);
                          },
                        );
                      },
                      icon: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.yellow[700],
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: FittedBox(
                      child: const Text('مخاطبین صفحه من همه مردم ایران هستند'),
                    ),
                  ),
                  leading: Radio<LocationType>(
                    value: LocationType.all,
                    groupValue: _locType,
                    onChanged: (LocationType? value) {
                      setState(() {
                        _locType = value;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _locType = LocationType.all;
                      _province = 'همه';
                      _city = 'همه';
                    });
                  },
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: FittedBox(
                      child: const Text('مخاطبین صفحه من در منطقه خاصی هستند'),
                    ),
                  ),
                  leading: Radio<LocationType>(
                    value: LocationType.specific,
                    groupValue: _locType,
                    onChanged: (LocationType? value) {
                      setState(() {
                        _locType = value;
                        _province = _provincesAndCities.first['name'];
                        _city =
                            _provincesAndCities.first['cities'].first['name'];
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _locType = LocationType.specific;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 16.0),
                  child: _locType == LocationType.specific
                      ? _isRegisteringProvincesAndCities
                          ? CircularProgressIndicator()
                          : LocationSelector(
                              _provincesAndCities,
                              this.setProvinceAndCity,
                            )
                      : null,
                ),
                Divider(thickness: 1.0),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        "محتوای پیج",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return RegistrationHelpDialog(_topicHelpText);
                          },
                        );
                      },
                      icon: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.yellow[700],
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: const Text('محتوای پیج من تخصصی نیست'),
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
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (!_isRegistering) {
                                registerUser(routeData);
                              }
                            }
                          },
                          child: _isRegistering
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "ثبت نام",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
