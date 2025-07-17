part of 'search_bloc.dart';

enum SearchStatus { initial, query, failure }

final class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.stories = const [],
    this.exception,
  });
  final SearchStatus status;
  final List<StoryModel> stories;
  final DioException? exception;

  SearchState copyWith({
    SearchStatus? status,
    List<StoryModel>? stories,
    DioException? exception,
  }) {
    return SearchState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, stories, exception];
}