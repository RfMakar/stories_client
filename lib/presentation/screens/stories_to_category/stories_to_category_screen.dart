import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories_client/presentation/screens/stories_to_category/bloc/stories_to_category_bloc.dart';
import 'package:stories_client/presentation/widgets/story.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/models/index.dart';
import 'package:stories_data/repositories/story_repository.dart';

class StoriesToCategoryScreen extends StatelessWidget {
  const StoriesToCategoryScreen({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final storyRepository = diStoriesData<StoryRepository>();
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: BlocProvider(
        create: (context) =>
            StoriesToCategoryBloc(storyRepository)
              ..add(StoriesToCategoryInitial(category.id)),
        child: BlocBuilder<StoriesToCategoryBloc, StoriesToCategoryState>(
          builder: (context, state) {
            switch (state.status) {
              case StoriesToCategoryStatus.initial:
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              case StoriesToCategoryStatus.success:
                return StoriesToCategoryScreenBody(stories: state.stories);
              case StoriesToCategoryStatus.failure:
                return Center(
                  child: Text(state.exception?.message ?? "Неизвестная ошибка"),
                );
            }
          },
        ),
      ),
    );
  }
}

class StoriesToCategoryScreenBody extends StatelessWidget {
  const StoriesToCategoryScreenBody({super.key, required this.stories});
  final List<StoryModel> stories;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return StoryWidget(story: story, isShowParam: true,);
      },
    );
  }
}

