part of 'home_movie_bloc.dart';

abstract class HomeMovieEvent extends Equatable {
  const HomeMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchData extends HomeMovieEvent {}
