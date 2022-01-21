import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/bloc/home_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late HomeDetailBloc homeDetailBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();

    homeDetailBloc = HomeDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  test('initial test must be empty', () async {
    expect(homeDetailBloc.state, HomeDetailEmpty());
  });

  group('FetchDetail', () {
    blocTest<HomeDetailBloc, HomeDetailState>(
      'should emit [loading, hasData] when data fetched successfully',
      build: () {
        when(mockGetMovieDetail.execute(testMovieDetail.id))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(testMovieDetail.id))
            .thenAnswer((_) async => Right(testMovieList));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return homeDetailBloc;
      },
      act: (bloc) => bloc.add(FetchDetail(testMovieDetail.id)),
      expect: () => [
        HomeDetailLoading(),
        HomeDetailHasData(
          movie: testMovieDetail,
          movieRecommendations: testMovieList,
          watchlisStatus: false,
          message: '',
        ),
      ],
    );
    blocTest<HomeDetailBloc, HomeDetailState>(
      'should emit [loading, error] when data fetch failed',
      build: () {
        when(mockGetMovieDetail.execute(testMovieDetail.id))
            .thenAnswer((_) async => Left(ServerFailure('server fail')));
        when(mockGetMovieRecommendations.execute(testMovieDetail.id))
            .thenAnswer((_) async => Left(ServerFailure('server fail')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return homeDetailBloc;
      },
      act: (bloc) => bloc.add(FetchDetail(testMovieDetail.id)),
      expect: () => [
        HomeDetailLoading(),
        const HomeDetailError('server fail'),
      ],
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<HomeDetailBloc, HomeDetailState>(
      'should emit [hasData] when remove movie from watchlist db is success',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
            (_) async => const Right('successfully remove watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return homeDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(
        HomeDetailHasData(
          movie: testMovieDetail,
          movieRecommendations: testMovieList,
          watchlisStatus: true,
          message: '',
        ),
        testMovieDetail,
      )),
      expect: () => [
        HomeDetailHasData(
          movie: testMovieDetail,
          movieRecommendations: testMovieList,
          watchlisStatus: true,
          message: 'successfully remove watchlist',
        ),
      ],
    );

    blocTest<HomeDetailBloc, HomeDetailState>(
      'should emit [error] when remove data from db failed',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(ServerFailure('server fail')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return homeDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlist(
        HomeDetailHasData(
          movie: testMovieDetail,
          movieRecommendations: testMovieList,
          watchlisStatus: true,
          message: '',
        ),
        testMovieDetail,
      )),
      expect: () => [
        const HomeDetailError('server fail'),
      ],
    );
  });

  group('AddWatchlist', () {
    blocTest<HomeDetailBloc, HomeDetailState>(
      'should emit [hasData] when add movie to watchlist db is success',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('successfully add watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return homeDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(
        HomeDetailHasData(
          movie: testMovieDetail,
          movieRecommendations: testMovieList,
          watchlisStatus: false,
          message: '',
        ),
        testMovieDetail,
      )),
      expect: () => [
        HomeDetailHasData(
          movie: testMovieDetail,
          movieRecommendations: testMovieList,
          watchlisStatus: false,
          message: 'successfully add watchlist',
        ),
      ],
    );
    blocTest<HomeDetailBloc, HomeDetailState>(
      'should emit [error] when add data to db failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(ServerFailure('server fail')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return homeDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(
        HomeDetailHasData(
          movie: testMovieDetail,
          movieRecommendations: testMovieList,
          watchlisStatus: false,
          message: '',
        ),
        testMovieDetail,
      )),
      expect: () => [
        const HomeDetailError('server fail'),
      ],
    );
  });
}
