import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_tv_status.dart';
import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist_tv.dart';
import 'package:core/presentation/bloc/home_detail_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_detail_tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchlistTVStatus,
  SaveWatchlistTV,
  RemoveTVWatchlist,
])
void main() {
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetWatchlistTVStatus mockGetWatchlistTVStatus;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveTVWatchlist mockRemoveTVWatchlist;
  late HomeDetailTvBloc homeDetailTvBloc;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetWatchlistTVStatus = MockGetWatchlistTVStatus();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveTVWatchlist = MockRemoveTVWatchlist();

    homeDetailTvBloc = HomeDetailTvBloc(
      getTVDetail: mockGetTVDetail,
      getTVRecommendations: mockGetTVRecommendations,
      getWatchListStatus: mockGetWatchlistTVStatus,
      saveWatchlist: mockSaveWatchlistTV,
      removeWatchlist: mockRemoveTVWatchlist,
    );
  });

  test('initial test must be empty', () async {
    expect(homeDetailTvBloc.state, HomeDetailTvEmpty());
  });

  group('FetchDetail', () {
    blocTest<HomeDetailTvBloc, HomeDetailTvState>(
      'should emit [loading, hasData] when data fetched successfully',
      build: () {
        when(mockGetTVDetail.execute(testTVDetail.id))
            .thenAnswer((_) async => Right(testTVDetail));
        when(mockGetTVRecommendations.execute(testTVDetail.id))
            .thenAnswer((_) async => Right(testTVList));
        when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
            .thenAnswer((_) async => false);
        return homeDetailTvBloc;
      },
      act: (bloc) => bloc.add(FetchDetail(testTVDetail.id)),
      expect: () => [
        HomeDetailTvLoading(),
        HomeDetailTvHasData(
          tv: testTVDetail,
          tvRecommendations: testTVList,
          watchlisStatus: false,
          message: '',
        ),
      ],
    );
    blocTest<HomeDetailTvBloc, HomeDetailTvState>(
      'should emit [loading, error] when data fetch failed',
      build: () {
        when(mockGetTVDetail.execute(testTVDetail.id))
            .thenAnswer((_) async => Left(ServerFailure('server fail')));
        when(mockGetTVRecommendations.execute(testTVDetail.id))
            .thenAnswer((_) async => Left(ServerFailure('server fail')));
        when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
            .thenAnswer((_) async => false);
        return homeDetailTvBloc;
      },
      act: (bloc) => bloc.add(FetchDetail(testTVDetail.id)),
      expect: () => [
        HomeDetailTvLoading(),
        const HomeDetailTvError('server fail'),
      ],
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<HomeDetailTvBloc, HomeDetailTvState>(
      'should emit [hasData] when remove tv from watchlist db is success',
      build: () {
        when(mockRemoveTVWatchlist.execute(testTVDetail)).thenAnswer(
            (_) async => const Right('successfully remove watchlist'));
        when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
            .thenAnswer((_) async => false);
        return homeDetailTvBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(
        HomeDetailTvHasData(
          tv: testTVDetail,
          tvRecommendations: testTVList,
          watchlisStatus: true,
          message: '',
        ),
        testTVDetail,
      )),
      expect: () => [
        HomeDetailTvHasData(
          tv: testTVDetail,
          tvRecommendations: testTVList,
          watchlisStatus: true,
          message: 'successfully remove watchlist',
        ),
      ],
    );

    blocTest<HomeDetailTvBloc, HomeDetailTvState>(
      'should emit [error] when remove data from db failed',
      build: () {
        when(mockRemoveTVWatchlist.execute(testTVDetail))
            .thenAnswer((_) async => Left(ServerFailure('server fail')));
        when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
            .thenAnswer((_) async => false);
        return homeDetailTvBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(
        HomeDetailTvHasData(
          tv: testTVDetail,
          tvRecommendations: testTVList,
          watchlisStatus: true,
          message: '',
        ),
        testTVDetail,
      )),
      expect: () => [
        const HomeDetailTvError('server fail'),
      ],
    );
  });

  group('AddWatchlist', () {
    blocTest<HomeDetailTvBloc, HomeDetailTvState>(
      'should emit [hasData] when add tv to watchlist db is success',
      build: () {
        when(mockSaveWatchlistTV.execute(testTVDetail))
            .thenAnswer((_) async => const Right('successfully add watchlist'));
        when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
            .thenAnswer((_) async => true);
        return homeDetailTvBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(
        HomeDetailTvHasData(
          tv: testTVDetail,
          tvRecommendations: testTVList,
          watchlisStatus: false,
          message: '',
        ),
        testTVDetail,
      )),
      expect: () => [
        HomeDetailTvHasData(
          tv: testTVDetail,
          tvRecommendations: testTVList,
          watchlisStatus: false,
          message: 'successfully add watchlist',
        ),
      ],
    );
    blocTest<HomeDetailTvBloc, HomeDetailTvState>(
      'should emit [error] when add data to db failed',
      build: () {
        when(mockSaveWatchlistTV.execute(testTVDetail))
            .thenAnswer((_) async => Left(ServerFailure('server fail')));
        when(mockGetWatchlistTVStatus.execute(testTVDetail.id))
            .thenAnswer((_) async => true);
        return homeDetailTvBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(
        HomeDetailTvHasData(
          tv: testTVDetail,
          tvRecommendations: testTVList,
          watchlisStatus: false,
          message: '',
        ),
        testTVDetail,
      )),
      expect: () => [
        const HomeDetailTvError('server fail'),
      ],
    );
  });
}
