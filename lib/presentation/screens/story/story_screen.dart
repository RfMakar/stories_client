import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_client/config/UI/app_assets.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/UI/app_text_style.dart';
import 'package:stories_client/presentation/widgets/app_button.dart';
import 'package:stories_client/presentation/widgets/story_categories_list.dart';
import 'package:stories_data/stories_data.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key, required this.story});
  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            elevation: 4,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double top = constraints.biggest.height;

                // Когда высота меньше или равна toolbarHeight (обычно 56), значит, AppBar схлопнулся
                final bool isCollapsed =
                    top <= kToolbarHeight + MediaQuery.of(context).padding.top;

                return FlexibleSpaceBar(
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isCollapsed ? 1.0 : 0.0,
                    child: Text(story.title, style: AppTextStyles.s18h000000n),
                  ),
                  background: CachedNetworkImage(
                    imageUrl: story.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Container(color: AppColors.hexFBF7F4),
                    placeholder: (context, url) =>
                        Container(color: AppColors.hexFBF7F4),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.title, style: AppTextStyles.s20h79553n),

                  Text(
                    story.content,
                    style: AppTextStyles.s14h000000n,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StoryCategoriesListWidget(categories: story.categories),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
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
            ),
          ),
          SliverToBoxAdapter(
            child: AppButton(
              child: Text('Назад', style: AppTextStyles.s16hFFFFFFn),
              onTap: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}
