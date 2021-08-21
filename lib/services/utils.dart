import 'dart:convert';
import 'dart:io';

import 'package:linkish/models/influencer_ad.dart';
import 'package:linkish/models/topic.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isActiveAd(InfluencerAd ad) {
  String adDateTime = ad.approvedAt;
  DateTime? time = DateTime.tryParse(adDateTime);
  DateTime now = DateTime.now();

  Duration diff = now.difference(time!);
  if (diff.inDays >= 1) {
    return false;
  }

  return true;
}

String calculateRemainTime(String timeStr) {
  DateTime? time = DateTime.tryParse(timeStr);
  time = DateTime(
    time!.year,
    time.month,
    time.day + 1,
    time.hour,
    time.minute,
    time.second,
  );

  DateTime now = DateTime.now();
  Duration diff = time.difference(now);

  final String hour = diff.inHours.toString().padLeft(2, '0');
  final String minute =
      (diff.inMinutes - (diff.inHours * 60)).toString().padLeft(2, '0');
  return "$hour:$minute";
}

Future<String?> getUserToken() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String? token = _prefs.getString("token");
  return token;
}

Future<String?> getUserEmail() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String? email = _prefs.getString("email");
  return email;
}

Future<String?> getUserPassword() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String? password = _prefs.getString("password");
  return password;
}

Future<List<Topic>> getUserTopics() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String? topicsJson = _prefs.getString("topics_json");
  List topicsMap = jsonDecode(topicsJson!);
  List<Topic> topicList = List.generate(
    topicsMap.length,
    (index) => Topic.mapToTopic(topicsMap[index]),
  );
  return topicList;
}

String getCurrentDateTime() {
  DateTime now = DateTime.now();
  String currentDateTime = "";
  currentDateTime += now.toString().substring(0, 4);
  currentDateTime += now.toString().substring(5, 7);
  currentDateTime += now.toString().substring(8, 10);
  currentDateTime += "_";
  currentDateTime += now.toString().substring(11, 13);
  currentDateTime += now.toString().substring(14, 16);
  currentDateTime += now.toString().substring(17, 19);
  return currentDateTime;
}

List<String> splitDate(String dateTime) {
  return (dateTime.split(" ")[0]).split("-");
}

List<String> splitTime(String dateTime) {
  return (dateTime.split(" ")[1]).split(":");
}

String getNextDay(String today) {
  List<String> date = splitDate(today);
  List<String> time = splitTime(today);

  DateTime dateTime = DateTime(
    int.parse(date[0]),
    int.parse(date[1]),
    int.parse(date[2]),
    int.parse(time[0]),
    int.parse(time[1]),
    int.parse(time[2]),
  );
  DateTime nextDay = dateTime.add(Duration(days: 1));
  return nextDay.toString().substring(0, 19);
}

bool isNumeric(String number) {
  for (int i = 0; i < number.length; i++) {
    try {
      int.parse(number[i]);
    } catch (e) {
      return false;
    }
  }
  return true;
}

String addDashCardNo(String cardNo) {
  String newStr = "";

  for (int i = 4; i <= cardNo.length; i += 4) {
    newStr += cardNo.substring(i - 4, i);
    if (i != cardNo.length) {
      newStr += ' - ';
    }
  }

  return newStr;
}

String getDeviceOs() {
  if (Platform.isAndroid) {
    return 'Android';
  } else if (Platform.isIOS) {
    return 'IOS';
  } else {
    return "other OS or can't detect";
  }
}