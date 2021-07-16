import 'dart:io';

import 'package:http/http.dart' as http;

class WebApi {
  final String _baseUri = "http://192.168.1.9:8000/";
  late final Uri _emailUrl;
  late final Uri _otpUrl;
  late final Uri _influencerSignUpUrl;


  WebApi() {
    this._emailUrl = Uri.parse(this._baseUri + "send-email/");
  }

  Future<void> sendEmail(String email) async {
    http.Response response = await http.post(this._emailUrl, body: {'email': email});
    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }
  }

}