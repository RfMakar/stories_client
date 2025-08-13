import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stories_client/core/services/audio_player_service.dart';
import 'package:stories_data/models/story_model.dart';

part 'app_player_event.dart';
part 'app_player_state.dart';

class AppPlayerBloc extends Bloc<AppPlayerEvent, AppPlayerState> {
  AppPlayerBloc(this._audio) : super(const AppPlayerState()) {
    _stateSub = _audio.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Закрытие после окончания
        add(const AppPlayerHide());
      }
    });
    on<AppPlayerShow>(_show);
    on<AppPlayerPlay>(_play);
    on<AppPlayerPause>(_pause);
    on<AppPlayerHide>(_hide);
  }

  final AudioPlayerService _audio;
  StreamSubscription<PlayerState>? _stateSub;

  Future<void> _show(AppPlayerShow event, Emitter<AppPlayerState> emit) async {
    emit(
      state.copyWith(
        story: event.story,
        status: AppPlayerStatus.show,
        isShow: true,
      ),
    );
    await _audio.setUrl(event.story.audioUrl);
    add(const AppPlayerPlay());
  }

  Future<void> _play(AppPlayerPlay event, Emitter<AppPlayerState> emit) async {
    final url = state.story?.audioUrl;
    if (url != null) {
      emit(state.copyWith(isPlaying: true));
      await _audio.play();
    }
  }

  Future<void> _pause(
    AppPlayerPause event,
    Emitter<AppPlayerState> emit,
  ) async {
    emit(state.copyWith(isPlaying: false));
    await _audio.pause();
  }

  Future<void> _hide(AppPlayerHide event, Emitter<AppPlayerState> emit) async {
    await _audio.stop();
    emit(
      state.copyWith(
        status: AppPlayerStatus.hide,
        isPlaying: false,
        isShow: false,
      ),
    );
  }

  @override
  Future<void> close() {
    _stateSub?.cancel();
    _audio.dispose();
    return super.close();
  }
}
