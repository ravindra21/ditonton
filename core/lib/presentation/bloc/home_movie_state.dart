part of 'home_movie_bloc.dart';

abstract class HomeMovieState extends Equatable {
  const HomeMovieState();

  @override
  List<Object> get props => [];
}

class HomeMovieEmpty extends HomeMovieState {}

class HomeMovieError extends HomeMovieState {
  final String message;

  const HomeMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeMovieLoading extends HomeMovieState {}

class HomeMovieHasData extends HomeMovieState {
  final List<Movie> playingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;

  const HomeMovieHasData({
    required this.playingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
  });

  @override
  List<Object> get props => [playingMovies, popularMovies, topRatedMovies];
}
