import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class WebApi {
  final String _baseUrl = "http://192.168.1.9:8000/";
  late final Uri _emailUrl;
  late final Uri _otpUrl;
  late final Uri _topicsUrl;
  late final Uri _influencerSignUpUrl;

  WebApi() {
    this._emailUrl = Uri.parse(this._baseUrl + "send-email/");
    this._otpUrl = Uri.parse(this._baseUrl + "check-otp/");
    this._topicsUrl = Uri.parse(this._baseUrl + "topic/");
  }

  Future<void> sendEmail(String email) async {
    Map body = {'email': email};
    http.Response response = await http.post(this._emailUrl, body: body);
    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }
  }

  Future<void> checkOtp(String email, String otp) async {
    int otpCode = int.parse(otp);
    Map<String, dynamic> body = {
      'email': email,
      'otp_code': otpCode,
    };
    http.Response response = await http.post(this._otpUrl, body: body);
    if (response.statusCode != 200) {
      throw HttpException(response.body);
    }
  }

  Future<List<String>> getTopicsList()async {
    http.Response response = await http.get(this._topicsUrl);
    if (response.statusCode != 200) {
      throw HttpException(response.body);
    }

    List responseBody = jsonDecode(response.body);
    List<String> topics = List.generate(responseBody.length, (index) => responseBody[index]["title"]);

    return topics;
  }
}
