import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_client/config/UI/app_assets.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/UI/app_text_style.dart';
import 'package:stories_client/config/router/routers.dart';
import 'package:stories_client/presentation/screens/home/bloc/home_bloc.dart';
import 'package:stories_client/presentation/widgets/player/bloc/app_player_bloc.dart';
import 'package:stories_client/presentation/widgets/story.dart';
import 'package:stories_data/stories_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showFab = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        _showFab) {
      setState(() => _showFab = false);
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        !_showFab) {
      setState(() => _showFab = true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showFab
          ? BlocSelector<AppPlayerBloc, AppPlayerState, bool>(
              selector: (state) {
                return state.isShow;
              },
              builder: (context, isShow) {
                //Если проигрыватель показываетсся то отступ выше
                return Padding(
                  padding: isShow
                      ? const EdgeInsets.only(bottom: 60)
                      : EdgeInsetsGeometry.zero,
                  child: FloatingActionButton(
                    onPressed: () =>
                        context.pushNamed(Routers.pathCategoriesScreen),
                    backgroundColor: AppColors.hex5F3430,
                    child: SvgPicture.asset(
                      AppAssets.iconCategory,
                      colorFilter: ColorFilter.mode(
                        AppColors.hexFFFFFF,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                );
              },
            )
          : null,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.status) {
            case HomeStatus.initial:
              return const Center(child: CircularProgressIndicator.adaptive());

            case HomeStatus.failure:
              return Center(
                child: Text(state.exception?.message ?? "Неизвестная ошибка"),
              );

            case HomeStatus.success:
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    title: GestureDetector(
                      onTap: () => context.pushNamed(Routers.pathSearchScreen),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.hex5F3430),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              height: 16,
                              width: 16,
                              AppAssets.iconSearch,
                              colorFilter: ColorFilter.mode(
                                AppColors.hex5F3430,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Найти сказку...',
                              style: AppTextStyles.s14h5F3430n,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: StoryTopDayWidget()),
                  SliverToBoxAdapter(
                    child: StoriesTop(
                      title: 'Новинки',
                      stories: state.storiesNew,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: StoriesTopCarousel(
                      title: 'Топ недели',
                      stories: state.storiesWeek,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: StoriesTopCarousel(
                      title: 'Топ месяца',
                      stories: state.storiesMonth,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
          }
        },
      ),
    );
  }
}

class StoryTopDayWidget extends StatelessWidget {
  const StoryTopDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, StoryModel?>(
      selector: (state) {
        return state.storyDay;
      },
      builder: (context, story) {
        return story == null
            ? Container()
            : GestureDetector(
                onTap: () {
                  context.pushNamed(Routers.pathStoryScreen, extra: story);
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.hex5F3430,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Сказка дня', style: AppTextStyles.s20hFFFFFFn),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
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
                      Text(story.title, style: AppTextStyles.s14hFFFFFFb),
                      Text(story.description, style: AppTextStyles.s12hFFFFFFn),
                    ],
                  ),
                ),
              );
      },
    );
  }
}

class StoriesTop extends StatelessWidget {
  const StoriesTop({super.key, required this.title, required this.stories});
  final String title;
  final List<StoryModel> stories;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(title, style: AppTextStyles.s20h79553Dn),
          ),
        ),
        Column(
          children: stories
              .map((story) => StoryWidget(story: story, isShowParam: true))
              .toList(),
        ),
      ],
    );
  }
}

class StoriesTopCarousel extends StatefulWidget {
  const StoriesTopCarousel({
    super.key,
    required this.title,
    required this.stories,
  });
  final String title;
  final List<StoryModel> stories;
  @override
  State<StoriesTopCarousel> createState() => _StoriesTopCarouselState();
}

class _StoriesTopCarouselState extends State<StoriesTopCarousel> {
  late PageController _pageController;
  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.title, style: AppTextStyles.s20h79553Dn),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.stories.length,
              pageSnapping: true,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                final story = widget.stories[pagePosition];
                return StoryTopWidget(story: story);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(widget.stories.length, activePage),
          ),
        ],
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return currentIndex == index
          ? Container(
              margin: const EdgeInsets.all(8),
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.hex5F3430),
                color: AppColors.hex5F3430,
              ),
            )
          : Container(
              height: 12,
              width: 12,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.hex5F3430),

                color: AppColors.hexFFFFFF.withValues(alpha: 0.4),
              ),
            );
    });
  }
}

class StoryTopWidget extends StatelessWidget {
  const StoryTopWidget({super.key, required this.story});
  final StoryModel story;
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
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
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
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.only(left: 8, right: 16),
              decoration: BoxDecoration(
                color: AppColors.hexFBF7F4,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                story.title,
                style: AppTextStyles.s14h5F3430n,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
