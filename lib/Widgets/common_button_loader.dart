import 'package:flutter/material.dart';

class CommonButtonLoader extends StatelessWidget {
  final Color indicatorColor;
  const CommonButtonLoader({super.key, required this.indicatorColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      width: 15,
      child: CircularProgressIndicator(
        color: indicatorColor,
      ),
    );
  }
}
