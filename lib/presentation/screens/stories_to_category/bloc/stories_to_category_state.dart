part of 'stories_to_category_bloc.dart';

enum StoriesToCategoryStatus { initial, success, failure }

final class StoriesToCategoryState extends Equatable {
  const StoriesToCategoryState({
    this.status = StoriesToCategoryStatus.initial,
    this.stories = const [],
    this.exception,
  });
  final StoriesToCategoryStatus status;
  final List<StoryModel> stories;
  final DioException? exception;

  StoriesToCategoryState copyWith({
    StoriesToCategoryStatus? status,
    List<StoryModel>? stories,
    DioException? exception,
  }) {
    return StoriesToCategoryState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, stories, exception];
}
