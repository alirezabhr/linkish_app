import 'package:dio/dio.dart';

import '../services/utils.dart';

import '../models/topic.dart';
import '../models/ad.dart';
import '../models/suggested_ad.dart';
import '../models/influencer_ad.dart';

class WebApi {
  static final String baseUrl = "http://185.10.72.73";
  final String _baseUrl = "http://185.10.72.73/";
  late final String _obtainTokenUrl;
  late final String _emailUrl;
  late final String _otpUrl;
  late final String _topicsUrl;
  late final String _influencerSignUpUrl;
  late final String _influencerSuggestedAdUrl;
  late final String _confirmAdUrl;
  late final String _baseShortLink;
  late final String _walletUrl;
  late final String _updateAccountUrl;
  late final String _changePasswordUrl;
  late final String _withdraw;

  WebApi() {
    this._obtainTokenUrl = this._baseUrl + "obtain-token/";
    this._emailUrl = this._baseUrl + "send-email/";
    this._otpUrl = this._baseUrl + "check-otp/";
    this._topicsUrl = this._baseUrl + "topic/";
    this._influencerSignUpUrl = this._baseUrl + "signup/influencer/";
    this._influencerSuggestedAdUrl = this._baseUrl + "ad/inf/";
    this._confirmAdUrl = this._baseUrl + "ad/inf/";
    this._baseShortLink = this._baseUrl + "ad/ia/";
    this._walletUrl = this._baseUrl + "ad/inf/wallet/";
    this._updateAccountUrl = this._baseUrl + "influencer/";
    this._changePasswordUrl = this._baseUrl + "change-pass/";
    this._withdraw = this._baseUrl + "withdraw/";
  }

  Future<String> obtainToken() async {
    String? email = await getUserEmail();
    String? password = await getUserPassword();
    Map data = {
      "email": email,
      "password": password,
    };

    Response response = await Dio().post(this._obtainTokenUrl, data: data);
    String newToken = "jwt " + response.data["token"];
    return newToken;
  }

  Future<void> sendEmail(String email) async {
    Map body = {'email': email};
    await Dio().post(this._emailUrl, data: body);
  }

  Future<void> checkOtp(String email, String otp) async {
    int otpCode = int.parse(otp);
    Map<String, dynamic> body = {
      'email': email,
      'otp_code': otpCode,
    };
    await Dio().post(this._otpUrl, data: body);
  }

  Future<List<Topic>> getTopicsList() async {
    Response response = await Dio().get(this._topicsUrl);

    List responseBody = response.data;
    List<Topic> topics = List.generate(
      responseBody.length,
      (index) => Topic(responseBody[index]["id"], responseBody[index]["title"]),
    );

    return topics;
  }

  Future<Map> influencerSignup(Map data) async {
    List<int> topicsPk = List.generate(
        data["topics"].length, (index) => data["topics"][index].id);
    Map body = {
      "email": data['email'],
      "password": data['password'],
      "instagram_id": data['instagram_id'],
      "province": data['province'],
      "city": data['city'],
      "is_general_page": data['is_general_page'],
      "topics": topicsPk,
    };
    Response response = await Dio().post(this._influencerSignUpUrl, data: body);
    return response.data;
  }

  Future<List<SuggestedAd>> getSuggestedAds(int influencerPk) async {
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();
    String url = this._influencerSuggestedAdUrl + influencerPk.toString() + "/";
    Response response = await dio.get(url);

    List<SuggestedAd> _suggestedAdsList =
        List.generate(response.data.length, (index) {
      Map adMap = response.data[index]["ad"];
      Ad ad = Ad(adMap["title"], adMap["base_link"], adMap["is_video"],
          adMap["image"], []);
      ad.id = adMap["id"];
      ad.videoUrl = adMap["video"];

      int _id = response.data[index]["id"];
      bool _isApproved = response.data[index]["is_approved"];
      String _suggestedAt = response.data[index]["suggested_at"];

      return SuggestedAd(_id, _isApproved, _suggestedAt, ad);
    });

    return _suggestedAdsList;
  }

  Future<List<InfluencerAd>> getApprovedAds(int influencerPk) async {
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();
    String url =
        this._influencerSuggestedAdUrl + influencerPk.toString() + "/approved/";
    Response response = await dio.get(url);

    List<InfluencerAd> _approvedAdList =
        List.generate(response.data.length, (index) {
      Map adMap = response.data[index]["suggested_ad"]["ad"];
      Ad ad = Ad(adMap["title"], adMap["base_link"], adMap["is_video"],
          adMap["image"], []);
      ad.id = adMap["id"];
      ad.videoUrl = adMap["video"];

      String _shortUrl =
          this._baseShortLink + response.data[index]["short_link"] + "/";
      int _clicks = response.data[index]["clicks"];
      int _deduction = response.data[index]["deduction"];
      int _cpc = response.data[index]["cpc"];
      String _approvedAt = response.data[index]["approved_at"];

      return InfluencerAd(
          _shortUrl, _clicks, _deduction, _cpc, _approvedAt, ad);
    });

    return _approvedAdList;
  }

  Future<void> confirmAd(int influencerPk, int suggestionId) async {
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();
    String url = this._confirmAdUrl + influencerPk.toString() + "/";
    Map<String, dynamic> body = {
      "suggested_ad": suggestionId,
    };
    await dio.post(url, data: body);
  }

  Future<void> rejectAd(int influencerPk, int suggestionId) async {
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();
    String url = this._confirmAdUrl + influencerPk.toString() + "/";
    Map<String, dynamic> body = {
      "suggested_ad": suggestionId,
      "is_rejected": true,
    };
    await dio.put(url, data: body);
  }

  Future<void> reportAd(
      int influencerPk, int suggestionId, String reportMsg) async {
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();
    String url = this._confirmAdUrl + influencerPk.toString() + "/";
    Map<String, dynamic> body = {
      "suggested_ad": suggestionId,
      "is_reported": true,
      "report_msg": reportMsg,
    };
    await dio.put(url, data: body);
  }

  Future<List<InfluencerAd>> getWallet(int influencerPk) async {
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();
    String url = this._walletUrl + influencerPk.toString() + "/";
    Response response = await dio.get(url);

    List<InfluencerAd> _walletList =
        List.generate(response.data.length, (index) {
      Map adMap = response.data[index]["influencer_ad"]["suggested_ad"]["ad"];
      Ad ad = Ad(adMap["title"], adMap["base_link"], adMap["is_video"],
          adMap["image"], []);
      ad.id = adMap["id"];
      ad.videoUrl = adMap["video"];

      String _shortUrl = this._baseShortLink +
          response.data[index]["influencer_ad"]["short_link"];
      int _clicks = response.data[index]["influencer_ad"]["clicks"];
      int _deduction = response.data[index]["influencer_ad"]["deduction"];
      int _cpc = response.data[index]["influencer_ad"]["cpc"];
      String _approvedAt = response.data[index]["influencer_ad"]["approved_at"];

      InfluencerAd influencerAd = InfluencerAd(
        _shortUrl,
        _clicks,
        _deduction,
        _cpc,
        _approvedAt,
        ad,
      );
      return influencerAd;
    });

    return _walletList;
  }

  Future<void> setBankAccount(
      int userId, String cardNo, String accountNo) async {
    final String url = this._updateAccountUrl + userId.toString() + "/";
    Map body = {
      "pk": userId,
      "card_number": cardNo,
      "account_number": accountNo,
    };
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();
    await dio.put(url, data: body);
  }

  Future<Map> getBankAccount(int userId) async {
    final String url = this._updateAccountUrl + userId.toString() + "/";
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();
    Response response = await dio.get(url);

    String _cardNo = "";
    String _accountNo = "";

    if (response.data['card_number'] != null) {
      _cardNo = response.data['card_number'];
    }
    if (response.data['account_number'] != null) {
      _accountNo = response.data['account_number'];
    }

    Map data = {
      "card_number": _cardNo,
      "account_number": _accountNo,
    };

    return data;
  }

  Future<void> setNewPassword(
      int userId, String currentPass, String newPass) async {
    final String url = this._changePasswordUrl + userId.toString() + "/";
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();

    Map data = {
      "current_pass": currentPass,
      "new_pass": newPass,
    };

    await dio.put(url, data: data);
  }

  Future<void> withdraw(int userId, int amount) async {
    final String url = this._withdraw + userId.toString() + "/";
    Dio dio = Dio();
    dio.options.headers["authorization"] = await getUserToken();

    Map data = {
      "amount": amount,
    };
    await dio.post(url, data: data);
  }
}
