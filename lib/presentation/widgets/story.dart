import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_client/config/UI/app_assets.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/UI/app_text_style.dart';
import 'package:stories_client/config/router/routers.dart';
import 'package:stories_client/presentation/widgets/story_categories_list.dart';
import 'package:stories_data/models/story_model.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({
    super.key,
    required this.story,
    required this.isShowParam,
  });
  final StoryModel story;
  final bool isShowParam;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routers.pathStoryScreen, extra: story);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.hexFFFFFF.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.hexE7E7E7),
        ),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: story.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Container(color: AppColors.hexFBF7F4),
                  placeholder: (context, url) =>
                      Container(color: AppColors.hexFBF7F4),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(story.title, style: AppTextStyles.s14h000000b),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                story.description,
                style: AppTextStyles.s12h000000n,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            isShowParam ? 
            StoryCategoriesListWidget(categories: story.categories) : Container(),
           isShowParam ?  Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 4,
                    children: [
                      SvgPicture.asset(AppAssets.iconShow),
                      Text(
                        story.readCount.toString(),
                        style: AppTextStyles.s14h000000n,
                      ),
                    ],
                  ),
                ],
              ),
            ): Container(),
          ],
        ),
      ),
    );
  }
}
