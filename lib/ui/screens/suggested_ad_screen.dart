import 'package:flutter/material.dart';

import '../widgets/AdRow.dart';

class SuggestedAdScreen extends StatelessWidget {
  const SuggestedAdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AdRow(),
    );
  }
}
