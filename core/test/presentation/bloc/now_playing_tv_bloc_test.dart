import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:core/presentation/bloc/now_playing_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV])
void main() {
  late MockGetNowPlayingTV mockGetNowPlayingTV;
  late NowPlayingTvBloc nowPlayingTvBloc;

  setUp(() {
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    nowPlayingTvBloc = NowPlayingTvBloc(getNowPlayingTv: mockGetNowPlayingTV);
  });

  group('now playing tv bloc', () {
    test('initial state should be empty', () async {
      expect(nowPlayingTvBloc.state, NowPlayingTvEmpty());
    });

    blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'should emit [loading, hasData] when data successfully fetch',
      build: () {
        when(mockGetNowPlayingTV.execute())
            .thenAnswer((_) async => Right(testTVList));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTv()),
      expect: () => [
        NowPlayingTvLoading(),
        NowPlayingTvHasData(tv: testTVList),
      ],
    );

    blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'should emit [loading, error] when data failed to fetch',
      build: () {
        when(mockGetNowPlayingTV.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTv()),
      expect: () => [
        NowPlayingTvLoading(),
        const NowPlayingTvError('Server Failure'),
      ],
    );
  });
}
