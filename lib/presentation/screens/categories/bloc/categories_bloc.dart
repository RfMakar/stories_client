import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:stories_client/core/functions/sort_category_types.dart';
import 'package:stories_data/core/utils/logger.dart';
import 'package:stories_data/models/category_type_model.dart';
import 'package:stories_data/repositories/category_type_repository.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc(this._categoryTypeRepository) : super(const CategoriesState()) {
    on<CategoriesInitial>(_initial);
  }

  final CategoryTypeRepository _categoryTypeRepository;

  Future<void> _initial(
    CategoriesInitial event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      final data = await _categoryTypeRepository.getCategoriesTypes(withCategories: true);
      final sortData = sortCategoryTypes(data);
      emit(
        state.copyWith(
          status: CategoriesStatus.success,
          categoriesTypes: List.of(sortData),
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
