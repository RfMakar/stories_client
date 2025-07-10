import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/index.dart';
import 'package:stories_data/repositories/story_popular_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._storyPopularRepository) : super(const HomeState()) {
    on<HomeInitial>(_initial);
  }
  final StoryPopularRepository _storyPopularRepository;

  Future<void> _initial(HomeInitial event, Emitter<HomeState> emit) async {
    try {
      final storyDay = await _storyPopularRepository.getStoryTopToDay();
      final storiesNew = await _storyPopularRepository.getStoriesNew();
      final storiesWeek = await _storyPopularRepository.getStoriesTopToWeek();
      final storiesMonth = await _storyPopularRepository.getStoriesTopToMonth();

      emit(
        state.copyWith(
          status: HomeStatus.success,
          storyDay: storyDay,
          storiesNew: List.of(storiesNew),
          storiesWeek: List.of(storiesWeek),
          storiesMonth: List.of(storiesMonth),
        ),
      );
    } on DioException catch (exception) {
      emit(state.copyWith(status: HomeStatus.failure, exception: exception));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
