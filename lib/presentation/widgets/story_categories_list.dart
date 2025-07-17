import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stories_client/config/UI/app_colors.dart';
import 'package:stories_client/config/router/routers.dart';
import 'package:stories_data/models/category_model.dart';

class StoryCategoriesListWidget extends StatelessWidget {
  const StoryCategoriesListWidget({super.key, required this.categories});
  final List<CategoryModel> categories;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryCardStory(category: category);
        },
      ),
    );
  }
}

class CategoryCardStory extends StatelessWidget {
  const CategoryCardStory({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.pushNamed(Routers.pathStoriesToCategoryScreen, extra: category);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.hexE7E7E7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(category.name),
      ),
    );
  }
}