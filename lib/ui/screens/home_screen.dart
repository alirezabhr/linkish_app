import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/AdRow.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Linkish"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_sharp)),
        ],
      ),
      drawer: Drawer(),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              child: AdRow(),
            ),
          ],
        ),
      ),
    );
  }
}
