import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/presentation/transforms/debounce_transform.dart';

part 'search_movies_event.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final SearchMovies usecase;

  SearchMoviesBloc(this.usecase) : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());
      final result = await usecase.execute(query);
      await result.fold(
        (failure) async {
          emit(SearchError(failure.message));
        },
        (data) async {
          emit(SearchHasData(data));
        },
      );
    },
        transformer:
            DebounceTransform.debounce(const Duration(milliseconds: 500)));
  }
}
