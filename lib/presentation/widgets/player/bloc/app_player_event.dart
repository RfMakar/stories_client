part of 'app_player_bloc.dart';

sealed class AppPlayerEvent extends Equatable {
  const AppPlayerEvent();

  @override
  List<Object> get props => [];
}

final class AppPlayerShow extends AppPlayerEvent {
  const AppPlayerShow(this.story);
  final StoryModel story;
}

final class AppPlayerPlay extends AppPlayerEvent {
  const AppPlayerPlay();
}

class AppPlayerPause extends AppPlayerEvent {
  const AppPlayerPause();
}

class AppPlayerHide extends AppPlayerEvent {
  const AppPlayerHide();
}

