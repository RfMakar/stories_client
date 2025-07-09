part of 'stories_to_category_bloc.dart';

sealed class StoriesToCategoryEvent extends Equatable {
  const StoriesToCategoryEvent();

  @override
  List<Object> get props => [];
}

final class StoriesToCategoryInitial extends StoriesToCategoryEvent {
  const StoriesToCategoryInitial(this.categoryId);
  final String categoryId;
}
