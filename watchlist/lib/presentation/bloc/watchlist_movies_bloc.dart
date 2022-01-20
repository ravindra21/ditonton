import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:watchlist/domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc({
    required this.getWatchlistMovies,
  }) : super(WatchlistMoviesEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMoviesLoading());

      final watchlistMovies = await getWatchlistMovies.execute();

      watchlistMovies.fold((l) => emit(WatchlistMoviesError(l.message)),
          (movies) {
        emit(WatchlistMoviesHasData(
          movies: movies,
        ));
      });
    });
  }
}
