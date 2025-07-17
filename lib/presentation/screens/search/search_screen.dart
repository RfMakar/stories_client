import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/UI/app_text_style.dart';
import 'package:stories_client/presentation/screens/search/bloc/search_bloc.dart';
import 'package:stories_client/presentation/widgets/story.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/stories_data.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchRepository = diStoriesData<SearchRepository>();
    return Scaffold(
      body: BlocProvider(
        create: (context) => SearchBloc(searchRepository),
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.initial:
              case SearchStatus.query:
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      title: TextField(
                        onChanged: (query) =>
                            context.read<SearchBloc>().add(SearchQuery(query)),
                        autofocus: true,
                        style: AppTextStyles.s14h5F3430n,
                        cursorColor: AppColors.hex5F3430,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: 'Название сказки',
                          hintStyle: AppTextStyles.s14h5F3430n,
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final story = state.stories[index];
                        return StoryWidget(story: story, isShowParam: true);
                      }, childCount: state.stories.length),
                    ),
                  ],
                );
              case SearchStatus.failure:
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


// class StoriesToCategoryScreen extends StatelessWidget {
//   const StoriesToCategoryScreen({super.key, required this.category});
//   final CategoryModel category;

//   @override
//   Widget build(BuildContext context) {
//     final storyRepository = diStoriesData<StoryRepository>();
//     return Scaffold(
//       body: BlocProvider(
//         create: (context) =>
//             StoriesToCategoryBloc(storyRepository)
//               ..add(StoriesToCategoryInitial(category.id)),
//         child: BlocBuilder<StoriesToCategoryBloc, StoriesToCategoryState>(
//           builder: (context, state) {
//             switch (state.status) {
//               case StoriesToCategoryStatus.initial:
//                 return const Center(
//                   child: CircularProgressIndicator.adaptive(),
//                 );

//               case StoriesToCategoryStatus.failure:
//                 return Center(
//                   child: Text(state.exception?.message ?? "Неизвестная ошибка"),
//                 );

//               case StoriesToCategoryStatus.success:
//                 return CustomScrollView(
//                   slivers: [
//                     SliverAppBar(
//                       floating: true,
//                       snap: true,
//                       title: Text(category.name),
//                     ),
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate((context, index) {
//                         final story = state.stories[index];
//                         return StoryWidget(story: story, isShowParam: true);
//                       }, childCount: state.stories.length),
//                     ),
//                   ],
//                 );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }