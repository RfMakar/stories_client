import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/UI/app_text_style.dart';
import 'package:stories_client/config/router/routers.dart';
import 'package:stories_client/presentation/screens/categories/bloc/categories_bloc.dart';
import 'package:stories_data/models/category_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Категории')),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          switch (state.status) {
            case CategoriesStatus.initial:
              return const Center(child: CircularProgressIndicator.adaptive());
            case CategoriesStatus.success:
              return CategoriesScreenBody(categories: state.categories);
            case CategoriesStatus.failure:
              return Center(
                child: Text(state.exception?.message ?? "Неизвестная ошибка"),
              );
          }
        },
      ),
    );
  }
}

class CategoriesScreenBody extends StatelessWidget {
  const CategoriesScreenBody({super.key, required this.categories});
  final List<CategoryModel> categories;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.90,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryWidget(category: category);
      },
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routers.pathStoriesToCategoryScreen, extra: category);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16),
              child: CachedNetworkImage(
                imageUrl: category.iconUrl,
                fit: BoxFit.fill,
                errorWidget: (context, url, error) =>
                    Container(color: AppColors.hexFBF7F4),
                placeholder: (context, url) =>
                    Container(color: AppColors.hexFBF7F4),
              ),
            ),
          ),
          Text(category.name, style: AppTextStyles.s14h000000n),
        ],
      ),
    );
  }
}
