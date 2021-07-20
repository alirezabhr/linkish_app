import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/topic.dart';

class Influencer with ChangeNotifier {
  late bool _isRegistered;
  late String _token;
  late String _email;
  late String _password;
  late String _instagramId;
  late String _location;
  late bool _isGeneralPage;
  late List<Topic> _topicsList;

  bool get isRegistered => _isRegistered;

  String get token => _token;

  String get email => _email;

  String get password => _password;

  String get instagramId => _instagramId;

  String get location => _location;

  bool get isGeneralPage => _isGeneralPage;

  List<Topic> get topicsList => _topicsList;

  Future<void> getUserDataSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs);
    _isRegistered = prefs.getBool("is_registered")!;
    _token = prefs.getString("token")!;
    _email = prefs.getString("email")!;
    _password = prefs.getString("password")!;
    _instagramId = prefs.getString("instagram_id")!;
    _location = prefs.getString("location")!;
    _isGeneralPage = prefs.getBool("is_general_page")!;
    String? topicsJson = prefs.getString("topics_json");
    List topicsMap = jsonDecode(topicsJson!);
    _topicsList = List.generate(topicsMap.length, (index) => Topic.mapToTopic(topicsMap[index]));
  }

  Future<void> registerUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_registered", true);
    prefs.setString("token", token);
    prefs.setString("email", _email);
    prefs.setString("password", _password);
    prefs.setString("instagram_id", _instagramId);
    prefs.setString("location", _location);
    prefs.setBool("is_general_page", _isGeneralPage);
    List<Map> topicsMap = List.generate(
        _topicsList.length, (index) => _topicsList[index].toMap());
    String topicsJson = jsonEncode(topicsMap);
    prefs.setString("topics_json", topicsJson);
  }

  void setUserDat(Map data) {
    this._isRegistered = true;
    this._email = data['email'];
    this._password = data['password'];
    this._instagramId = data['instagram_id'];
    this._location = data['location'];
    this._isGeneralPage = data['is_general_page'];
    this._topicsList = data['topics'];
    notifyListeners();
  }

  Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = token;
    prefs.setString("token", _token);
    notifyListeners();
  }
}
