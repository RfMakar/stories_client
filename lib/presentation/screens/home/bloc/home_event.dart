part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}


final class HomeInitial extends HomeEvent {
  const HomeInitial();
}