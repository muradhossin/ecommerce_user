import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String imagePath;
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const CustomImage({super.key, required this.imagePath, this.imageUrl, this.height, this.width, this.fit});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageUrl: imageUrl!,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return Image.asset(imagePath, height: height, width: width, fit: fit);
    }
  }
}

