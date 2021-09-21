import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_share/social_share.dart';

import '../../models/influencer_ad.dart';
import '../../models/ad.dart';
import '../../services/web_api.dart';
import '../../services/utils.dart' as utils;
import '../../services/logger_service.dart';

class AdDetail extends StatefulWidget {
  final InfluencerAd influencerAd;

  AdDetail(this.influencerAd);

  @override
  _AdDetailState createState() => _AdDetailState();
}

class _AdDetailState extends State<AdDetail> {
  double progress = 0;
  bool _isDownloading = false;
  bool _isDownloaded = false;
  late String _mediaPath;

  Future<bool> _hasAcceptedPermissions() async {
    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage) &&
          // access media location needed for android 10/Q
          await _requestPermission(Permission.accessMediaLocation) &&
          // manage external storage needed for android 11/R
          await _requestPermission(Permission.manageExternalStorage)) {
        return true;
      } else {
        return false;
      }
    }
    if (Platform.isIOS) {
      if (await _requestPermission(Permission.photos)) {
        return true;
      } else {
        return false;
      }
    } else {
      // not android or ios
      return false;
    }
  }

  Future<Directory> getAppDirectory() async {
    Directory directory;

    if (Platform.isAndroid) {
      directory = (await getExternalStorageDirectory())!;
      String newPath = "";
      List<String> paths = directory.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/Linkish";
      directory = Directory(newPath);
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    return directory;
  }

  Future<File> getSaveFileData(String fileName) async {
    Directory directory = await getAppDirectory();
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    File saveFile = File(directory.path + "/$fileName");

    return saveFile;
  }

  Future<void> downloadMedia(String url, String saveFilePath) async {
    await Dio().download(url, saveFilePath,
        onReceiveProgress: (value1, value2) {
      String progressStr = ((value1 / value2) * 100).toStringAsFixed(2);
      setState(() {
        progress = double.parse(progressStr);
      });
    });

    this._mediaPath = saveFilePath;
  }

  Future<void> saveMediaToGallery(String saveFilePath) async {
    if (Platform.isIOS) {
      await ImageGallerySaver.saveFile(saveFilePath, isReturnPathOfIOS: true);
    } else {
      await ImageGallerySaver.saveFile(saveFilePath);
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> downloadAndSaveMedia(String url, bool isVideo) async {
    String newMediaName = utils.getCurrentDateTime();
    String format = isVideo ? ".mp4" : ".jpg";

    if (await _hasAcceptedPermissions()) {
      File saveFile = await getSaveFileData(newMediaName + format);
      await downloadMedia(url, saveFile.path);
      await saveMediaToGallery(saveFile.path);
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('لینک کپی شد'),
      ),
    );
  }

  String getMediaUrl(Ad ad) {
    String mediaUrl = ad.isVideo ? ad.videoUrl : ad.imageUrl;
    mediaUrl = WebApi.baseUrl + mediaUrl;

    return mediaUrl;
  }

  void showSnackError(String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMsg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String remainingTime =
        utils.calculateRemainTime(this.widget.influencerAd.approvedAt);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: Text(
              widget.influencerAd.ad.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: BoxDecoration(),
            child: FittedBox(
              child: Image.network(
                  "${WebApi.baseUrl}${widget.influencerAd.ad.imageUrl}"),
            ),
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text(
                    widget.influencerAd.shortLink,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontFamily: 'Arial'),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.copy),
                  onPressed: () async {
                    await _copyToClipboard(widget.influencerAd.shortLink);
                  },
                  label: Text("کپی"),
                ),
              ],
            ),
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 8.0),
                  child: Text(
                    "نوع محتوا: ${widget.influencerAd.ad.isVideo ? "ویدئو" : "عکس"}",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.download_sharp),
                  onPressed: () async {
                    bool _isAdVideo = widget.influencerAd.ad.isVideo;
                    String mediaUrl = getMediaUrl(widget.influencerAd.ad);

                    setState(() {
                      _isDownloading = true;
                      progress = 0;
                    });

                    try {
                      await downloadAndSaveMedia(mediaUrl, _isAdVideo);
                      setState(() {
                        _isDownloading = false;
                        _isDownloaded = true;
                      });
                    } on DioError catch (error) {
                      setState(() {
                        _isDownloading = false;
                        _isDownloaded = false;
                      });
                      showSnackError('خطا در دانلود محتوای تبلیغ!');

                      LoggerService logger = LoggerService();
                      logger.setUserData();
                      await logger.sendLog(
                        'download_ad',
                        {
                          "catch_in": 'dio error in download media on pressed',
                          "response_status": error.response!.statusCode,
                          "response_data": error.response!.data,
                        },
                      );
                    } catch (error) {
                      setState(() {
                        _isDownloading = false;
                        _isDownloaded = false;
                      });
                      showSnackError('خطا در ذخیره سازی محتوای تبلیغ!');

                      LoggerService logger = LoggerService();
                      logger.setUserData();
                      await logger.sendLog(
                        'download_ad',
                        {
                          "catch_in": 'catch in download media on pressed',
                          "error": error.toString(),
                        },
                      );
                    }
                  },
                  label: Text("دانلود"),
                ),
                SizedBox(width: 16.0),
                ElevatedButton.icon(
                  icon: Icon(Icons.share),
                  onPressed: () async {
                    bool _isAdVideo = widget.influencerAd.ad.isVideo;
                    String mediaUrl = getMediaUrl(widget.influencerAd.ad);
                    String newMediaName = utils.getCurrentDateTime();
                    String format = _isAdVideo ? ".mp4" : ".jpg";

                    try {
                      if (await _hasAcceptedPermissions()) {
                        File saveFile =
                            await getSaveFileData(newMediaName + format);
                        await downloadMedia(mediaUrl, saveFile.path);
                        await saveMediaToGallery(saveFile.path);
                        SocialShare.shareInstagramStory(_mediaPath,
                            attributionURL: mediaUrl);
                      }
                    } on DioError catch (error) {
                      showSnackError(
                          'در حال حاضر امکان انتشار مستقیم به استوری وجود ندارد!');

                      LoggerService logger = LoggerService();
                      logger.setUserData();
                      await logger.sendLog(
                        'share_to_story',
                        {
                          "catch_in": 'dio error in share media on pressed',
                          "response_status": error.response!.statusCode,
                          "response_data": error.response!.data,
                        },
                      );
                    } catch (error) {
                      showSnackError('خطا در انتشار مستقیم به استوری!');

                      LoggerService logger = LoggerService();
                      logger.setUserData();
                      await logger.sendLog(
                        'share_to_story',
                        {
                          "catch_in": 'catch in share media on pressed',
                          "error": error.toString(),
                        },
                      );
                    }
                  },
                  label: Text("استوری"),
                ),
              ],
            ),
          ),
          Text(_isDownloading
              ? "دانلود شده: $progress%"
              : _isDownloaded
                  ? "با موفقیت دانلود شد"
                  : ""),
          Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "زمان باقی مانده کمپین: " + remainingTime,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
