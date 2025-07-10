import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/repositories/story_popular_repository.dart';

part 'story_event.dart';
part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc(this._storyPopularRepository) : super(const StoryState()) {
    on<StoryInitial>(_initial);
  }

  final StoryPopularRepository _storyPopularRepository;

  Future<void> _initial(StoryInitial event, Emitter<StoryState> emit) async {
    try {
      await _storyPopularRepository.updateStoryReads(storyId: event.storyId);
      emit(state.copyWith(status: StoryStatus.success));
    } on DioException catch (exception) {
      emit(state.copyWith(status: StoryStatus.failure, exception: exception));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
