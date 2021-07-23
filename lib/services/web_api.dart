import 'dart:io';

import 'package:dio/dio.dart';

import '../models/topic.dart';
import '../models/ad.dart';
import '../models/suggested_ad.dart';

class WebApi {
  static final String baseUrl = "http://192.168.1.9:8000";
  final String _baseUrl = "http://192.168.1.9:8000/";
  late final String _emailUrl;
  late final String _otpUrl;
  late final String _topicsUrl;
  late final String _influencerSignUpUrl;
  late final String _influencerSuggestedAdUrl;
  late final String _confirmAdUrl;

  WebApi() {
    this._emailUrl = this._baseUrl + "send-email/";
    this._otpUrl = this._baseUrl + "check-otp/";
    this._topicsUrl = this._baseUrl + "topic/";
    this._influencerSignUpUrl = this._baseUrl + "signup/influencer/";
    this._influencerSuggestedAdUrl = this._baseUrl + "ad/inf/";
    this._confirmAdUrl = this._baseUrl + "ad/inf/";
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
      responseBody.length,
      (index) => Topic(responseBody[index]["id"], responseBody[index]["title"]),
    );

    return topics;
  }

  Future<String> influencerSignup(Map data) async {
    List<int> topicsPk = List.generate(data["topics"].length, (index) => data["topics"][index].id);
    Map body = {
      "email": data['email'],
      "password": data['password'],
      "instagram_id": data['instagram_id'],
      "location": data['location'],
      "is_general_page": data['is_general_page'],
      "topics": topicsPk,
    };
    Response response = await Dio().post(this._influencerSignUpUrl, data: body);
    if (response.statusCode == 201) {
      String token = response.data["token"];
      return token;
    }
    return "Error";
  }

  Future<List<SuggestedAd>> getSuggestedAds(int influencerPk) async {
    String url = this._influencerSuggestedAdUrl + influencerPk.toString() + "/";
    Response response = await Dio().get(url);

    List<SuggestedAd> _suggestedAdsList = List.generate(response.data.length, (index) {
      Map adMap = response.data[index]["ad"];
      Ad ad = Ad(adMap["title"], adMap["base_link"], adMap["is_video"], adMap["image"], []);
      ad.id = adMap["id"];
      ad.videoUrl = adMap["video"];

      int _id = response.data[index]["id"];
      bool _isApproved = response.data[index]["is_approved"];
      String _suggestedAt = response.data[index]["suggested_at"];

      return SuggestedAd(_id, _isApproved, _suggestedAt, ad);
    });

    return _suggestedAdsList;
  }

  Future<void> confirmAd(int influencerPk, int suggestionId) async {
    String url = this._confirmAdUrl + influencerPk.toString() + "/";
    Map<String, dynamic> body = {
      "suggested_ad": suggestionId,
    };
    try {
      await Dio().post(url, data: body);
    } on DioError catch (e) {
      print(e.response);
    }
  }
}
