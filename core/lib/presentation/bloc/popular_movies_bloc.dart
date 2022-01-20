import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc({
    required this.getPopularMovies,
  }) : super(PopularMoviesEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularMoviesLoading());

      final popularMovies = await getPopularMovies.execute();

      popularMovies.fold((l) => emit(PopularMoviesError(l.message)), (movies) {
        emit(PopularMoviesHasData(
          movies: movies,
        ));
      });
    });
  }
}
