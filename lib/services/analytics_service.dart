import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'utils.dart' as utils;

class AnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  // FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> sendLog(eventName, eventParams) async {
    await this._setUserId();
    this._sendAnalyticsEvent(eventName, eventParams);
  }

  Future<void> _sendAnalyticsEvent(String name, Map<String, dynamic> params) async {
    await analytics.logEvent(
      name: name,
      parameters: params,
    );
  }

  Future<void> _setUserId() async {
    String userEmail = "";
    userEmail = (await utils.getUserEmail())!;
    await analytics.setUserId(userEmail);
  }

}
