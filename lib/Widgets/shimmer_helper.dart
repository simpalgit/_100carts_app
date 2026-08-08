import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHelper extends StatelessWidget {
  final double height, width;
  final double? borderRadius;
  const ShimmerHelper(
      {super.key,
      required this.height,
      required this.width,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white,
      enabled: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(borderRadius ?? 0)),
      ),
    );
  }
}
