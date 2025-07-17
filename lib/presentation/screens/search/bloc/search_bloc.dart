import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/stories_data.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchRepository) : super(const SearchState()) {
    on<SearchQuery>(_query);
  }

  final SearchRepository _searchRepository;

  Future<void> _query(SearchQuery event, Emitter<SearchState> emit) async {
    try {
      if (event.query.trim().isEmpty || event.query.length < 3) {
        emit(state.copyWith(status: SearchStatus.query, stories: List.of([])));
        return;
      }
      await Future.delayed(const Duration(milliseconds: 600));

      final data = await _searchRepository.getSearchStories(query: event.query);
      emit(state.copyWith(status: SearchStatus.query, stories: List.of(data)));
    } on DioException catch (exception) {
      emit(state.copyWith(status: SearchStatus.failure, exception: exception));
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
