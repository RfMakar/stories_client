import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_client/config/UI/app_assets.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/router/routers.dart';
import 'package:stories_client/presentation/screens/stories_to_category/bloc/stories_to_category_bloc.dart';
import 'package:stories_client/presentation/widgets/player/bloc/app_player_bloc.dart';
import 'package:stories_client/presentation/widgets/story.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/models/index.dart';
import 'package:stories_data/repositories/story_repository.dart';

class StoriesToCategoryScreen extends StatefulWidget {
  const StoriesToCategoryScreen({super.key, required this.category});
  final CategoryModel category;

  @override
  State<StoriesToCategoryScreen> createState() =>
      _StoriesToCategoryScreenState();
}

class _StoriesToCategoryScreenState extends State<StoriesToCategoryScreen> {
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
    final storyRepository = diStoriesData<StoryRepository>();
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
                        context.goNamed(Routers.pathCategoriesScreen),
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
      body: BlocProvider(
        create: (context) =>
            StoriesToCategoryBloc(storyRepository)
              ..add(StoriesToCategoryInitial(widget.category.id)),
        child: BlocBuilder<StoriesToCategoryBloc, StoriesToCategoryState>(
          builder: (context, state) {
            switch (state.status) {
              case StoriesToCategoryStatus.initial:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );

              case StoriesToCategoryStatus.failure:
                return Center(
                  child: Text(state.exception?.message ?? "Неизвестная ошибка"),
                );

              case StoriesToCategoryStatus.success:
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      title: Text(widget.category.name),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final story = state.stories[index];
                        return StoryWidget(
                          story: story,
                          isShowParam: true,
                        );
                      }, childCount: state.stories.length),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}
