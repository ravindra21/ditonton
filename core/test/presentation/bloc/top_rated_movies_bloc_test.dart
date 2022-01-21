import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesBloc topRatedMoviesBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc =
        TopRatedMoviesBloc(getTopRatedMovies: mockGetTopRatedMovies);
  });

  group('top rated movies bloc', () {
    test('initial state should be empty', () async {
      expect(topRatedMoviesBloc.state, TopRatedMoviesEmpty());
    });

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'should emit [loading, hasData] when data successfully fetch',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return topRatedMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMoviesLoading(),
        TopRatedMoviesHasData(movies: testMovieList),
      ],
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'should emit [loading, error] when data failed to fetch',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMoviesLoading(),
        const TopRatedMoviesError('Server Failure'),
      ],
    );
  });
}
