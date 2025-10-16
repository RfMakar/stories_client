import 'package:go_router/go_router.dart';
import 'package:stories_client/config/router/routers.dart';
import 'package:stories_client/presentation/screens/categories/categories_screen.dart';
import 'package:stories_client/presentation/screens/home/home_screen.dart';
import 'package:stories_client/presentation/screens/search/search_screen.dart';
import 'package:stories_client/presentation/screens/stories_to_category/stories_to_category_screen.dart';
import 'package:stories_client/presentation/screens/story/story_screen.dart';
import 'package:stories_client/presentation/screens/story_image_full/story_image_full_screen.dart';
import 'package:stories_data/models/category_model.dart';
import 'package:stories_data/models/story_model.dart';

final router = GoRouter(
  initialLocation: Routers.pathHomeScreen,
  routes: [
    GoRoute(
      path: Routers.pathHomeScreen,
      name: Routers.pathHomeScreen,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: Routers.pathCategoriesScreen,
          name: Routers.pathCategoriesScreen,
          builder: (context, state) => const CategoriesScreen(),
          routes: [
            GoRoute(
              path: Routers.pathStoriesToCategoryScreen,
              name: Routers.pathStoriesToCategoryScreen,
              builder: (context, state) {
                final category = state.extra as CategoryModel;
                return StoriesToCategoryScreen(category: category);
              },
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: Routers.pathStoryScreen,
      name: Routers.pathStoryScreen,
      builder: (context, state) {
        final story = state.extra as StoryModel;
        return StoryScreen(story: story);
      },
      routes: [
        GoRoute(
          path: Routers.pathStoryImageFullScreen,
          name: Routers.pathStoryImageFullScreen,
          pageBuilder: (context, state) {
            final imageUrl = state.extra as String;
            return CustomTransitionPage(
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              transitionsBuilder: (_, __, ___, child) => child,
              child: StoryImageFullScreen(imageUrl: imageUrl),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: Routers.pathSearchScreen,
      name: Routers.pathSearchScreen,
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);
