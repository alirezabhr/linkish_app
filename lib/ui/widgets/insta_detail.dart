import 'package:flutter/material.dart';
import 'package:flutter_insta/flutter_insta.dart';

class InstaDetails extends StatefulWidget {
  final String instagramId;

  InstaDetails(this.instagramId);

  @override
  _InstaDetailsState createState() => _InstaDetailsState();
}

class _InstaDetailsState extends State<InstaDetails> {
  bool _isLoading = true;
  late int _followers;
  late String _imageUrl;

  setInstaDetails() async {
    setState(() {
      _isLoading = true;
    });

    FlutterInsta flutterInsta = new FlutterInsta();
    await flutterInsta.getProfileData(widget.instagramId);

    setState(() {
      _followers = int.parse(flutterInsta.followers!);
      _imageUrl = flutterInsta.imgurl;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    setInstaDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    _imageUrl,
                    height: 100,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.instagramId,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "تعداد فالوئر: $_followers",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
