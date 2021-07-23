import 'package:linkish/models/influencer_ad.dart';

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

  return "${diff.inHours}:${diff.inMinutes - (diff.inHours*60)}";
}