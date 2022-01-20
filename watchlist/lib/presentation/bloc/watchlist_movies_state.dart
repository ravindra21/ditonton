part of 'watchlist_movies_bloc.dart';

abstract class WatchlistMoviesState extends Equatable {
  const WatchlistMoviesState();

  @override
  List<Object> get props => [];
}

class WatchlistMoviesEmpty extends WatchlistMoviesState {}

class WatchlistMoviesError extends WatchlistMoviesState {
  final String message;

  const WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMoviesLoading extends WatchlistMoviesState {}

class WatchlistMoviesHasData extends WatchlistMoviesState {
  final List<Movie> movies;

  const WatchlistMoviesHasData({
    required this.movies,
  });

  @override
  List<Object> get props => [movies];
}
