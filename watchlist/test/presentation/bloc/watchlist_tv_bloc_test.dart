import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/usecases/get_watchlist_tv.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTV])
void main() {
  late MockGetWatchlistTV mockGetWatchlistTV;
  late WatchlistTvBloc watchlistTvBloc;

  setUp(() {
    mockGetWatchlistTV = MockGetWatchlistTV();
    watchlistTvBloc = WatchlistTvBloc(getWatchlistTv: mockGetWatchlistTV);
  });
  test('initial state should be empty', () async {
    expect(watchlistTvBloc.state, WatchlistTvEmpty());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'should emit [loading, hasData] when data successfully fetch',
    build: () {
      when(mockGetWatchlistTV.execute())
          .thenAnswer((_) async => Right(testTVList));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvHasData(tv: testTVList),
    ],
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'should emit [loading, error] when data failed to fetch',
    build: () {
      when(mockGetWatchlistTV.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTv()),
    expect: () => [
      WatchlistTvLoading(),
      const WatchlistTvError('Server Failure'),
    ],
  );
}
