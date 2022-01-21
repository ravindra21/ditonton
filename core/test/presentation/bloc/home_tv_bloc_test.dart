import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:core/presentation/bloc/home_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_tv_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV, GetPopularTV, GetTopRatedTV])
void main() {
  late MockGetNowPlayingTV mockGetNowPlayingTV;
  late MockGetPopularTV mockGetPopularTV;
  late MockGetTopRatedTV mockGetTopRatedTV;
  late HomeTvBloc homeTVBloc;

  setUp(() {
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    mockGetPopularTV = MockGetPopularTV();
    mockGetTopRatedTV = MockGetTopRatedTV();

    homeTVBloc = HomeTvBloc(
      getNowPlayingTv: mockGetNowPlayingTV,
      getPopularTv: mockGetPopularTV,
      getTopRatedTv: mockGetTopRatedTV,
    );
  });
  test('initial state should be empty', () async {
    expect(homeTVBloc.state, HomeTvEmpty());
  });

  blocTest<HomeTvBloc, HomeTvState>(
    'should emit [loading, hasData] when data successfully fetch',
    build: () {
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Right(testTVList));
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Right(testTVList));
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => Right(testTVList));
      return homeTVBloc;
    },
    act: (bloc) => bloc.add(FetchData()),
    expect: () => [
      HomeTvLoading(),
      HomeTvHasData(
        playingTv: testTVList,
        popularTv: testTVList,
        topRatedTv: testTVList,
      ),
    ],
  );

  blocTest<HomeTvBloc, HomeTvState>(
    'should emit [loading, error] when data failed to fetch',
    build: () {
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return homeTVBloc;
    },
    act: (bloc) => bloc.add(FetchData()),
    expect: () => [
      HomeTvLoading(),
      const HomeTvError('Server Failure'),
    ],
  );
}
