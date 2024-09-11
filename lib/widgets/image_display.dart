import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String imagePath;
  final double height;

  const ImageDisplay({
    super.key,
    required this.imagePath,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      height: height,
    );
  }
}
