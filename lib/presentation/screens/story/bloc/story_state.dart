part of 'story_bloc.dart';

enum StoryStatus { initial, success, failure }

final class StoryState extends Equatable {
  const StoryState({
    this.status = StoryStatus.initial,
    this.exception,
  });
  final StoryStatus status;
  final DioException? exception;

  StoryState copyWith({
    StoryStatus? status,
    DioException? exception,
  }) {
    return StoryState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, exception];
}

