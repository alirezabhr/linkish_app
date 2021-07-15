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
      appBar: AppBar(title: Text("Linkish"),),
      drawer: Drawer(),
      body: Container(
        child: Column(
          children: [
            AdRow(),
          ],
        ),
      ),
    );
  }
}
