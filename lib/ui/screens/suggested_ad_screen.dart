import 'package:flutter/material.dart';

import '../widgets/AdRow.dart';

class SuggestedAdScreen extends StatelessWidget {
  const SuggestedAdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 4.0),
              child: AdRow(),
            ),
          ],
        ),
      ),
    );
  }
}
