import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/presentation/bloc/popular_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesBloc popularMoviesBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc =
        PopularMoviesBloc(getPopularMovies: mockGetPopularMovies);
  });
  test('initial state should be empty', () async {
    expect(popularMoviesBloc.state, PopularMoviesEmpty());
  });

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [loading, hasData] when data successfully fetch',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () => [
      PopularMoviesLoading(),
      PopularMoviesHasData(movies: testMovieList),
    ],
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [loading, error] when data failed to fetch',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () => [
      PopularMoviesLoading(),
      const PopularMoviesError('Server Failure'),
    ],
  );
}
