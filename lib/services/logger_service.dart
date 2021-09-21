import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'web_api.dart';
import 'device_info_service.dart';

class LoggerService {
  String _loggerUrl = WebApi.baseUrl + '/logger/';

  int _userId = 0;
  String _userEmail = '';
  Map _deviceData = {};

  Future<void> sendLog(String eventName, Map eventParams) async {
    await setUserDeviceData();

    Map userData = {
      'user_id': _userId,
      'user_email': _userEmail,
      'device_data': _deviceData,
    };

    Map data = {
      "event_name": eventName,
      "event_params": eventParams,
      "user_data": userData,
    };

    try {
      await Dio().post(_loggerUrl, data: data);
    } on DioError catch (E) {
      print(E.response!.data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> setUserData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _userId = _prefs.getInt("id")!;
    _userEmail = _prefs.getString("email")!;
  }

  Future<void> setUserDeviceData() async {
    CustomDeviceInfoService deviceInfoService = CustomDeviceInfoService();
    Map deviceData = await deviceInfoService.getDeviceData();

    try {
      _deviceData = deviceData;
    } catch (_) {
      return;
    }
  }
}
