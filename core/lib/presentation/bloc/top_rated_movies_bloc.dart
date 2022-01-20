import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc({
    required this.getTopRatedMovies,
  }) : super(TopRatedMoviesEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedMoviesLoading());

      final topRatedMovies = await getTopRatedMovies.execute();

      topRatedMovies.fold((l) => emit(TopRatedMoviesError(l.message)),
          (movies) {
        emit(TopRatedMoviesHasData(
          movies: movies,
        ));
      });
    });
  }
}
