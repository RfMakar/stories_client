import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_client/config/UI/app_colors.dart';

class StoryImageFullScreen extends StatelessWidget {
  const StoryImageFullScreen({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.hexFBF7F4,
      body: Center(
        child: GestureDetector(
          onTap: () => context.pop(),
          child: CachedNetworkImage(
            
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                Container(color: AppColors.hexFBF7F4),
            placeholder: (context, url) => Container(color: AppColors.hexFBF7F4),
          ),
        ),
      ),
    );
  }
}
