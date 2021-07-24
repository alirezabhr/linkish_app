import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/influencer_ad.dart';
import '../../services/web_api.dart';
import '../../services/utils.dart';

class AdDetail extends StatefulWidget {
  final InfluencerAd influencerAd;

  AdDetail(this.influencerAd);

  @override
  _AdDetailState createState() => _AdDetailState();
}

class _AdDetailState extends State<AdDetail> {
  final String filename = 'sooriland_video.mp4';
  double progress = 0;
  bool _isDownloading = false;
  bool _isDownloaded = false;

  Future<bool> saveVideo(String url, String fileName) async {
    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory())!;
          String newPath = "";
          print(directory);
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

  downloadFile(String mediaPathName) async {
    setState(() {
      _isDownloading = true;
      progress = 0;
    });

    bool downloaded = await saveVideo(mediaPathName, "new_video.mp4");

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
        content: Text('Copied to clipboard'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String remainingTime =
        calculateRemainTime(this.widget.influencerAd.approvedAt);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                  child: Text(widget.influencerAd.shortLink),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.copy),
                  onPressed: () async {
                    await _copyToClipboard(widget.influencerAd.shortLink);
                  },
                  label: Text("copy"),
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
                    "media type: ${widget.influencerAd.ad.isVideo ? "video" : "image"}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.download_sharp),
                  onPressed: () async {
                    String mediaUrl = widget.influencerAd.ad.isVideo
                        ? widget.influencerAd.ad.videoUrl
                        : widget.influencerAd.ad.imageUrl;
                    mediaUrl = WebApi.baseUrl + mediaUrl;
                    await downloadFile(mediaUrl);
                  },
                  label: Text("download"),
                ),
              ],
            ),
          ),
          Text(_isDownloading
              ? "progress: $progress%"
              : _isDownloaded
                  ? "Successfully downloaded"
                  : ""),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "remaining: " + remainingTime,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
