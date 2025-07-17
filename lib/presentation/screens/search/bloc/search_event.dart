part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchQuery extends SearchEvent {
  const SearchQuery(this.query);
  final String query;
}
