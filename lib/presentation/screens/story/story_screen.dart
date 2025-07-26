import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stories_client/config/UI/app_assets.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/UI/app_text_style.dart';
import 'package:stories_client/presentation/screens/story/bloc/story_bloc.dart';
import 'package:stories_client/presentation/widgets/app_button.dart';
import 'package:stories_client/presentation/widgets/player/bloc/app_player_bloc.dart';
import 'package:stories_client/presentation/widgets/story_categories_list.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/stories_data.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key, required this.story});
  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    final storyPopularRepository = diStoriesData<StoryPopularRepository>();
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            StoryBloc(storyPopularRepository)..add(StoryInitial(story.id)),
        lazy: false,
        child: Provider(
          create: (context) => story,
          child: const StoryScreenBody(),
        ),
      ),
    );
  }
}

class StoryScreenBody extends StatelessWidget {
  const StoryScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final story = context.read<StoryModel>();
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250.0,
          pinned: false,
          elevation: 4,
          stretch: true,
          iconTheme: IconThemeData(color: AppColors.hexFFFFFF),
          flexibleSpace: FlexibleSpaceBar(
            background: CachedNetworkImage(
              imageUrl: story.imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  Container(color: AppColors.hexFBF7F4),
              placeholder: (context, url) =>
                  Container(color: AppColors.hexFBF7F4),
            ),
            titlePadding: const EdgeInsets.only(bottom: 16, right: 16),
            title: story.audio != null ? ButtonPlay(story: story) : null,
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
                Text(story.content, style: AppTextStyles.s14h000000n),
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
    );
  }
}

class ButtonPlay extends StatelessWidget {
  const ButtonPlay({super.key, required this.story});
  final StoryModel story;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AppPlayerBloc>().add(AppPlayerShow(story));
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.hexFFFFFF,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.headphones_outlined,
                color: AppColors.hex5F3430,
                size: 16,
              ),
              Text('Слушать', style: AppTextStyles.s12h5F3430n),
            ],
          ),
        ),
      ),
    );
  }
}
