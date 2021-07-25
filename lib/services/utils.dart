import 'package:linkish/models/influencer_ad.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isActiveAd(InfluencerAd ad) {
  String adDateTime = ad.approvedAt.substring(0, 26);
  DateTime? time = DateTime.tryParse(adDateTime);
  DateTime now = DateTime.now();

  Duration diff = now.difference(time!);
  if (diff.inDays >= 1) {
    return false;
  }

  return true;
}

String calculateRemainTime(String timeStr) {
  String adDateTime = timeStr.substring(0, 26);
  DateTime? time = DateTime.tryParse(adDateTime);
  time = DateTime(time!.year, time.month, time.day+1, time.hour, time.minute, time.second);

  DateTime now = DateTime.now();
  Duration diff = time.difference(now);

  final String hour = diff.inHours.toString().padLeft(2, '0');
  final String minute = (diff.inMinutes - (diff.inHours*60)).toString().padLeft(2, '0');
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

String getNextDay(String today) {
  int day = int.parse(today.substring(8, 10));
  day += 1;
  return today.substring(0,8) + day.toString() + today.substring(10);
}