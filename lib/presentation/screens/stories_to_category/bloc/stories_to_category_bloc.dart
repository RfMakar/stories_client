import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/stories_data.dart';

part 'stories_to_category_event.dart';
part 'stories_to_category_state.dart';

class StoriesToCategoryBloc
    extends Bloc<StoriesToCategoryEvent, StoriesToCategoryState> {
  StoriesToCategoryBloc(this._storyRepository)
    : super(const StoriesToCategoryState()) {
    on<StoriesToCategoryInitial>(_initial);
  }

  final StoryRepository _storyRepository;

  Future<void> _initial(
    StoriesToCategoryInitial event,
    Emitter<StoriesToCategoryState> emit,
  ) async {
    try {
      final data = await _storyRepository.getStories(
        categoryId: event.categoryId,
      );
      emit(
        state.copyWith(
          status: StoriesToCategoryStatus.success,
          stories: List.of(data),
        ),
      );
    } on DioException catch (exception) {
      emit(
        state.copyWith(
          status: StoriesToCategoryStatus.failure,
          exception: exception,
        ),
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
