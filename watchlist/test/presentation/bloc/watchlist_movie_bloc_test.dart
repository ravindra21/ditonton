import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/usecases/get_watchlist_movies.dart';
import 'package:watchlist/presentation/bloc/watchlist_movies_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMoviesBloc watchlistMoviesBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc =
        WatchlistMoviesBloc(getWatchlistMovies: mockGetWatchlistMovies);
  });
  test('initial state should be empty', () async {
    expect(watchlistMoviesBloc.state, WatchlistMoviesEmpty());
  });

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'should emit [loading, hasData] when data successfully fetch',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesHasData(movies: testMovieList),
    ],
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'should emit [loading, error] when data failed to fetch',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistMovies()),
    expect: () => [
      WatchlistMoviesLoading(),
      const WatchlistMoviesError('Server Failure'),
    ],
  );
}
