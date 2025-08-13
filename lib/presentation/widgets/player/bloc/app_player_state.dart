part of 'app_player_bloc.dart';

enum AppPlayerStatus { initial, show, hide, failure }

final class AppPlayerState extends Equatable {
  const AppPlayerState({
    this.status = AppPlayerStatus.initial,
    this.isPlaying = false,
    this.isShow = false,
    this.story,
    this.exception,
  });
  final AppPlayerStatus status;
  final StoryModel? story;
  final bool isPlaying;
  final bool isShow;
  final DioException? exception;

  AppPlayerState copyWith({
    AppPlayerStatus? status,
    StoryModel? story,
    bool? isPlaying,
    bool? isShow,
    DioException? exception,
  }) {
    return AppPlayerState(
      status: status ?? this.status,
      story: story ?? this.story,
      isPlaying: isPlaying ?? this.isPlaying,
      isShow: isShow ?? this.isShow,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, story, exception, isPlaying];
}
