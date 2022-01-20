part of 'home_detail_bloc.dart';

abstract class HomeDetailState extends Equatable {
  const HomeDetailState();

  @override
  List<Object> get props => [];
}

class HomeDetailEmpty extends HomeDetailState {}

class HomeDetailLoading extends HomeDetailState {}

class HomeDetailError extends HomeDetailState {
  final String message;

  const HomeDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeDetailHasData extends HomeDetailState {
  final MovieDetail movie;
  final List<Movie> movieRecommendations;
  final bool watchlisStatus;
  final String message;

  const HomeDetailHasData(
      {required this.movie,
      required this.movieRecommendations,
      required this.watchlisStatus,
      required this.message});

  HomeDetailHasData copyWith({
    MovieDetail? movie,
    List<Movie>? movieRecommendations,
    bool? watchlisStatus,
    String? message,
  }) {
    return HomeDetailHasData(
      movie: movie ?? this.movie,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      watchlisStatus: watchlisStatus ?? this.watchlisStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props =>
      [movie, movieRecommendations, watchlisStatus, message];
}
