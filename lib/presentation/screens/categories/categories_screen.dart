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
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          switch (state.status) {
            case CategoriesStatus.initial:
              return const Center(child: CircularProgressIndicator.adaptive());

            case CategoriesStatus.failure:
              return Center(
                child: Text(state.exception?.message ?? "Неизвестная ошибка"),
              );

            case CategoriesStatus.success:
              return CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    floating: true,
                    snap: true,
                    title: Text('Категории'),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final categoryType = state.categoriesTypes![index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16,),
                            child: Text(
                              categoryType.name,
                              style: AppTextStyles.s18h5F3430n,
                            ),
                          ),
                          GridView.builder(
                            padding: const EdgeInsets.all(16),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.88,
                                ),
                            itemCount: categoryType.categories?.length,
                            itemBuilder: (context, gridIndex) {
                              final category =
                                  categoryType.categories![gridIndex];
                              return CategoryWidget(category: category);
                            },
                          ),
                        ],
                      );
                    }, childCount: state.categoriesTypes?.length),
                  ),
                ],
              );
          }
        },
      ),
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
          ClipRRect(
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
          Text(category.name, style: AppTextStyles.s14h5F3430n),
        ],
      ),
    );
  }
}
