import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonImageView extends StatefulWidget {
  final String? url;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CommonImageView({
    super.key,
    this.url,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<CommonImageView> createState() => _CommonImageViewState();
}

class _CommonImageViewState extends State<CommonImageView> {
  @override
  Widget build(BuildContext context) {
    if (widget.url == null || widget.url!.isEmpty) {
      return _buildErrorPlaceholder();
    }

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      child: CachedNetworkImage(
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        imageUrl: widget.url!,
        placeholder: (context, url) => _buildShimmerPlaceholder(),
        errorWidget: (context, url, error) {
          debugPrint('Error loading network image: $url');
          debugPrint('Error: $error');
          return _buildErrorPlaceholder();
        },
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: widget.height ?? 100,
        width: widget.width ?? 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      height: widget.height ?? 100,
      width: widget.width ?? 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey.shade600,
          size: 30,
        ),
      ),
    );
  }
}
