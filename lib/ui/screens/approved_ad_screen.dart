import 'package:flutter/material.dart';

import '../widgets/approved_ad_list.dart';

class ApprovedAdScreen extends StatelessWidget {
  const ApprovedAdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          child: ApprovedAdList(),
        ),
      ),
    );
  }
}
