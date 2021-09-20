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
import '../../services/analytics_service.dart';

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

  Future<bool> saveMedia(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage) &&
            await _requestPermission(Permission.accessMediaLocation)) {
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
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await Dio().download(url, saveFile.path,
            onReceiveProgress: (value1, value2) {
              setState(() {
                progress = (value1 / value2) * 100;
              });
            });
        this._mediaPath = saveFile.path;
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        } else {
          await ImageGallerySaver.saveFile(saveFile.path);
        }
        return true;
      }
      return false;
    } catch (e) {
      AnalyticsService analytics = AnalyticsService();
      await analytics.sendLog(
        'save_ad_media',
        {
          "error": e,
        },
      );
      print(e);
      return false;
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

  downloadFile(String mediaPathName, bool isVideo) async {
    setState(() {
      _isDownloading = true;
      progress = 0;
    });

    String newMediaName = utils.getCurrentDateTime();
    String format = isVideo ? ".mp4" : ".jpg";
    bool downloaded = await saveMedia(mediaPathName, newMediaName + format);

    if (downloaded) {
      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });
      print("File Downloaded");
    } else {
      print("Problem Downloading File");
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

                    try {
                      await downloadFile(mediaUrl, _isAdVideo);
                    } catch (e) {
                      showSnackError('خطا در دانلود محتوای تبلیغ!');

                      AnalyticsService analytics = AnalyticsService();
                      await analytics.sendLog(
                        'download_ad_media',
                        {
                          "error": e,
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
                      await this.saveMedia(mediaUrl, newMediaName + format);
                      SocialShare.shareInstagramStory(_mediaPath,
                          attributionURL: mediaUrl);
                    } catch (e) {
                      showSnackError(
                          'در حال حاضر امکان انتشار مستقیم به استوری وجود ندارد!');
                      AnalyticsService analytics = AnalyticsService();
                      await analytics.sendLog(
                        'share_to_story',
                        {
                          "error": e,
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
