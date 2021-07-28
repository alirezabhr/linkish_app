import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/topic.dart';

class Influencer with ChangeNotifier {
  late int _userId;
  late bool _isRegistered;
  late String _token;
  late String _email;
  late String _password;
  late String _instagramId;
  late String _province;
  late String _city;
  late bool _isGeneralPage;
  late List<Topic> _topicsList;

  int get userId => _userId;

  bool get isRegistered => _isRegistered;

  String get token => _token;

  String get email => _email;

  String get password => _password;

  String get instagramId => _instagramId;

  String get province => _province;

  String get city => _city;

  bool get isGeneralPage => _isGeneralPage;

  List<Topic> get topicsList => _topicsList;

  Future<void> getUserDataSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isRegistered = prefs.getBool("is_registered")!;
    _userId = prefs.getInt("id")!;
    _token = prefs.getString("token")!;
    _email = prefs.getString("email")!;
    _password = prefs.getString("password")!;
    _instagramId = prefs.getString("instagram_id")!;
    _province = prefs.getString("province")!;
    _city = prefs.getString("city")!;
    _isGeneralPage = prefs.getBool("is_general_page")!;
    String? topicsJson = prefs.getString("topics_json");
    List topicsMap = jsonDecode(topicsJson!);
    _topicsList = List.generate(topicsMap.length, (index) => Topic.mapToTopic(topicsMap[index]));
  }

  Future<void> registerUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_registered", true);
    prefs.setInt("id", _userId);
    prefs.setString("token", _token);
    prefs.setString("email", _email);
    prefs.setString("password", _password);
    prefs.setString("instagram_id", _instagramId);
    prefs.setString("province", _province);
    prefs.setString("city", _city);
    prefs.setBool("is_general_page", _isGeneralPage);
    List<Map> topicsMap = List.generate(
        _topicsList.length, (index) => _topicsList[index].toMap());
    String topicsJson = jsonEncode(topicsMap);
    prefs.setString("topics_json", topicsJson);
  }

  void setUserData(Map data) {
    this._isRegistered = true;
    this._email = data['email'];
    this._password = data['password'];
    this._instagramId = data['instagram_id'];
    this._province = data['province'];
    this._city = data['city'];
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

  Future<void> setUserId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = id;
    prefs.setInt("id", _userId);
    notifyListeners();
  }

  Future<void> setNewPass(String password) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    this._password = password;
    _prefs.setString("password", password);
    notifyListeners();
  }
}
