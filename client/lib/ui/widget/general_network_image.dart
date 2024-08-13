
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxBorder? border;
  final BorderRadius? borderRadius;
  final bool isCircular;
  final BoxFit? fit;
  final Color? filterColor;
  final FilterQuality? filterQuality;
  final Color? placeHolderColor;
  final Alignment? alignment;
  final bool useCacheKey;
  final String? viewType;
  final VoidCallback? onTap;

  const CachedImage({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    this.border,
    this.borderRadius,
    this.isCircular = false,
    this.fit,
    this.filterColor,
    this.filterQuality,
    this.placeHolderColor,
    this.alignment,
    this.useCacheKey = false,
    this.viewType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      filterQuality: filterQuality ?? FilterQuality.low,
      cacheKey: _cacheKey,
      imageBuilder: (context, image) {
        return InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
              border: border,
              borderRadius: borderRadius,
              image: DecorationImage(
                image: image,
                fit: fit ?? BoxFit.cover,
                alignment: alignment ?? Alignment.center,
                colorFilter: (filterColor != null)
                    ? ColorFilter.mode(filterColor!, BlendMode.overlay)
                    : null,
              ),
            ),
          ),
        );
      },
      imageUrl: url,
      width: width,
      height: height,
      placeholder: (_, url) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: (isCircular == false) ? (borderRadius ?? BorderRadius.zero) : null,
          color: placeHolderColor ?? Colors.grey[200],
        ),
        child:FittedBox(
          alignment: Alignment.center,
          child:  SizedBox(
            width: width/2,
            height: height/2,
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
      errorWidget: (_, url, error) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: (isCircular == false) ? (borderRadius ?? BorderRadius.zero) : null,
          color: placeHolderColor ?? Colors.grey[200],
        ),
        child: Icon(Icons.error,size: min(width,height)/2,),
      ),
    );
  }

  String get _cacheKey {
    if(useCacheKey == false) return url;
    final now = DateTime.now();
    return '$url-${now.year}-${now.month}-${now.day}-${now.hour}';
  }
}