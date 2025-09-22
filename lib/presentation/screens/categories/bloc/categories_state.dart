part of 'categories_bloc.dart';

enum CategoriesStatus { initial, success, failure }

final class CategoriesState extends Equatable {
  const CategoriesState({
    this.status = CategoriesStatus.initial,
    this.categoriesTypes = const [],
    this.exception,
  });
  final CategoriesStatus status;
  final List<CategoryTypeModel>? categoriesTypes;
  final DioException? exception;

  CategoriesState copyWith({
    CategoriesStatus? status,
    List<CategoryTypeModel>? categoriesTypes,
    DioException? exception,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categoriesTypes: categoriesTypes ?? this.categoriesTypes,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [status, categoriesTypes, exception];
}
