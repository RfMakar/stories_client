import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stories_client/config/UI/app_theme.dart';
import 'package:stories_client/config/router/router.dart';
import 'package:stories_client/core/services/audio_player_service.dart';
import 'package:stories_client/presentation/screens/categories/bloc/categories_bloc.dart';
import 'package:stories_client/presentation/screens/home/bloc/home_bloc.dart';
import 'package:stories_client/presentation/widgets/player/bloc/app_player_bloc.dart';
import 'package:stories_client/presentation/widgets/player/app_player.dart';
import 'package:stories_data/core/di_stories_data.dart';
import 'package:stories_data/repositories/category_repository.dart';
import 'package:stories_data/repositories/story_popular_repository.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryRepository = diStoriesData<CategoryRepository>();
    final storyPopularRepository = diStoriesData<StoryPopularRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppPlayerBloc(AudioPlayerService()),
        ),
        BlocProvider(
          create: (context) =>
              CategoriesBloc(categoryRepository)
                ..add(const CategoriesInitial()),
        ),
        BlocProvider(
          create: (context) =>
              HomeBloc(storyPopularRepository)..add(const HomeInitial()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ru')],
        builder: (context, child) {
          return Stack(children: [child!, const AppPlayer()]);
        },
      ),
    );
  }
}
