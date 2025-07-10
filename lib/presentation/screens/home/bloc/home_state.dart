part of 'home_bloc.dart';

enum HomeStatus { initial, success, failure }

final class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.storyDay,
    this.storiesNew = const [],
    this.storiesWeek = const [],
    this.storiesMonth = const [],
    this.exception,
  });
  final HomeStatus status;
  final StoryModel? storyDay;
  final List<StoryModel> storiesNew;
  final List<StoryModel> storiesWeek;
  final List<StoryModel> storiesMonth;
  final DioException? exception;

  HomeState copyWith({
    HomeStatus? status,
    StoryModel? storyDay,
    final List<StoryModel>? storiesNew,
    final List<StoryModel>? storiesWeek,
    final List<StoryModel>? storiesMonth,
    DioException? exception,
  }) {
    return HomeState(
      status: status ?? this.status,
      storyDay: storyDay ?? this.storyDay,
      storiesNew: storiesNew ?? this.storiesNew,
      storiesWeek: storiesWeek ?? this.storiesWeek,
      storiesMonth: storiesMonth ?? this.storiesMonth,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
    status,
    storyDay,
    storiesNew,
    storiesWeek,
    storiesMonth,
    exception,
  ];
}
