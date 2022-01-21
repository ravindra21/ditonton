import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/home_movie_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late HomeMovieBloc homeMoviesBloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();

    homeMoviesBloc = HomeMovieBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });
  test('initial state should be empty', () async {
    expect(homeMoviesBloc.state, HomeMovieEmpty());
  });

  blocTest<HomeMovieBloc, HomeMovieState>(
    'should emit [loading, hasData] when data successfully fetch',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return homeMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchData()),
    expect: () => [
      HomeMovieLoading(),
      HomeMovieHasData(
        playingMovies: testMovieList,
        popularMovies: testMovieList,
        topRatedMovies: testMovieList,
      ),
    ],
  );

  blocTest<HomeMovieBloc, HomeMovieState>(
    'should emit [loading, error] when data failed to fetch',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return homeMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchData()),
    expect: () => [
      HomeMovieLoading(),
      const HomeMovieError('Server Failure'),
    ],
  );
}
