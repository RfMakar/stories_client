import 'package:go_router/go_router.dart';
import 'package:stories_client/config/router/routers.dart';
import 'package:stories_client/presentation/screens/categories/categories_screen.dart';
import 'package:stories_client/presentation/screens/home/home_screen.dart';

final router = GoRouter(
  initialLocation: Routers.pathHomeScreen,
  routes: [
    GoRoute(
      path: Routers.pathHomeScreen,
      name: Routers.pathHomeScreen,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: Routers.pathCategoriesScreen,
      name: Routers.pathCategoriesScreen,
      builder: (context, state) => const CategoriesScreen(),
    ),
  ],
);
