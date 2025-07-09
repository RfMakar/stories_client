import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/category_model.dart';
import 'package:stories_data/repositories/category_repository.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(this._categoryRepository) : super(const CategoriesState()) {
    on<CategoriesInitial>(_initial);
  }

  final CategoryRepository _categoryRepository;

  Future<void> _initial(
    CategoriesInitial event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      final data = await _categoryRepository.getCategories();
      emit(
        state.copyWith(
          status: CategoriesStatus.success,
          categories: List.of(data),
        ),
      );
    } on DioException catch (exception) {
      emit(
        state.copyWith(status: CategoriesStatus.failure, exception: exception),
      );
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
