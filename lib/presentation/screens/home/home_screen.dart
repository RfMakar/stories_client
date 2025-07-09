import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_client/config/UI/app_text_style.dart';
import 'package:stories_client/config/router/routers.dart';
import 'package:stories_client/presentation/widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: const HomeScreenBody());
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.bottomCenter,
      children: [Placeholder(), ButtonCategoriesToScreen()],
    );
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
