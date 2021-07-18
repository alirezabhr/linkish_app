import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../models/topic.dart';
import '../models/influencer.dart';

class WebApi {
  final String _baseUrl = "http://192.168.1.9:8000/";
  late final String _emailUrl;
  late final String _otpUrl;
  late final String _topicsUrl;
  late final String _influencerSignUpUrl;

  WebApi() {
    this._emailUrl = this._baseUrl + "send-email/";
    this._otpUrl = this._baseUrl + "check-otp/";
    this._topicsUrl = this._baseUrl + "topic/";
    this._influencerSignUpUrl = this._baseUrl + "signup/influencer/";
  }

  Future<void> sendEmail(String email) async {
    Map body = {'email': email};
    Response response = await Dio().post(this._emailUrl, data: body);
    if (response.statusCode != 201) {
      throw HttpException(response.data);
    }
  }

  Future<void> checkOtp(String email, String otp) async {
    int otpCode = int.parse(otp);
    Map<String, dynamic> body = {
      'email': email,
      'otp_code': otpCode,
    };
    Response response = await Dio().post(this._otpUrl, data: body);
    if (response.statusCode != 200) {
      throw HttpException(response.data);
    }
  }

  Future<List<Topic>> getTopicsList() async {
    Response response = await Dio().get(this._topicsUrl);
    if (response.statusCode != 200) {
      throw HttpException(response.data);
    }

    List responseBody = response.data;
    List<Topic> topics = List.generate(
        responseBody.length, (index) => Topic(responseBody[index]["id"], responseBody[index]["title"]));

    return topics;
  }

  Future<void> influencerSignup(Influencer influencer) async {
    List<int> topicsId = TopicList().getTopicsId(influencer.topicsList);
    print(topicsId);
    int a = 2;
    int b = 3;
    List<int> list = [a,b];
    Map body = {
      "email": influencer.email,
      "password": influencer.password,
      "instagram_id": influencer.instagramId,
      "location": influencer.location,
      "is_general_page": influencer.isGeneralPage,
      "topics": list,
    };

    try {
      Response response = await Dio().post(this._influencerSignUpUrl, data: body);
      if (response.statusCode != 201) {
        if (response.statusCode == 400) {
          throw Exception("bad request in signup");
        } else {
          throw Exception("some problem in signup.[${response.statusCode}]");
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
