import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'home_movie_event.dart';
part 'home_movie_state.dart';

class HomeMovieBloc extends Bloc<HomeMovieEvent, HomeMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  HomeMovieBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(HomeMovieEmpty()) {
    on<FetchData>((event, emit) async {
      emit(HomeMovieLoading());

      final playingMovies = await getNowPlayingMovies.execute();
      final popularMovies = await getPopularMovies.execute();
      final topRatedMovies = await getTopRatedMovies.execute();

      playingMovies.fold((l) => emit(HomeMovieError(l.message)), (playing) {
        popularMovies.fold((l) => emit(HomeMovieError(l.message)), (popular) {
          topRatedMovies.fold((l) => emit(HomeMovieError(l.message)),
              (topRated) {
            emit(HomeMovieHasData(
              playingMovies: playing,
              popularMovies: popular,
              topRatedMovies: topRated,
            ));
          });
        });
      });
    });
  }
}
