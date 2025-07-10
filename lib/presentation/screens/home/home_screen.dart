import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/UI/app_text_style.dart';
import 'package:stories_client/config/router/routers.dart';
import 'package:stories_client/presentation/screens/home/bloc/home_bloc.dart';
import 'package:stories_client/presentation/widgets/app_button.dart';
import 'package:stories_client/presentation/widgets/story.dart';
import 'package:stories_data/stories_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.hexE7E7E7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text('Найти сказку...', style: AppTextStyles.s14hE7E7E7n),
              ],
            ),
          ),
        ),
      ),
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
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: [
                      const StoryTopDayWidget(),
                      StoriesTopCarousel(
                        title: 'Новинки',
                        stories: state.storiesNew,
                      ),
                      StoriesTopCarousel(
                        title: 'Топ недели',
                        stories: state.storiesWeek,
                      ),
                      StoriesTopCarousel(
                        title: 'Топ месяца',
                        stories: state.storiesMonth,
                      ),
                    ],
                  ),
                  const ButtonCategoriesToScreen(),
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
                  margin: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.symmetric(vertical:4 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.title, style: AppTextStyles.s20h79553n),
            ),
          ),
          SizedBox(
            height: 400,
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
                return StoryWidget(story: story);
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

class ButtonCategoriesToScreen extends StatelessWidget {
  const ButtonCategoriesToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      child: Text('Категории', style: AppTextStyles.s16hFFFFFFn),
      onTap: () => context.pushNamed(Routers.pathCategoriesScreen),
    );
  }
}
