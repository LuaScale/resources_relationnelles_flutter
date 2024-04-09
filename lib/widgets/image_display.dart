import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final String imagePath;
  final double height;

  const ImageDisplay({
    Key? key,
    required this.imagePath,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      height: height,
    );
  }
}
