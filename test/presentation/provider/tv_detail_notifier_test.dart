import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_tv_status.dart';
import 'package:core/domain/usecases/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist_tv.dart';
import 'package:core/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  SaveWatchlistTV,
  GetWatchlistTVStatus,
  RemoveTVWatchlist
])
void main() {
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockGetWatchlistTVStatus mockGetWatchlistTVStatus;
  late RemoveTVWatchlist mockRemoveTVWatchlist;

  late TVDetailNotifier provider;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockGetWatchlistTVStatus = MockGetWatchlistTVStatus();
    mockRemoveTVWatchlist = MockRemoveTVWatchlist();

    provider = TVDetailNotifier(
      getTVDetail: mockGetTVDetail,
      getTVRecommendations: mockGetTVRecommendations,
      saveWatchlist: mockSaveWatchlistTV,
      getWatchlistStatus: mockGetWatchlistTVStatus,
      removeTVWatchlist: mockRemoveTVWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final int tId = 85552;

  final testTVDetail = TVDetail(
    adult: false,
    backdropPath: "/path.jpg",
    firstAirDate: "2020-05-05",
    genres: [Genre(id: 1, name: "Action")],
    id: 1,
    name: "Title",
    originalName: "Original Title",
    overview: "Overview",
    posterPath: "/path.jpg",
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tTV = TV(
    backdropPath: '/35SS0nlBhu28cSe7TiO3ZiywZhl.jpg',
    firstAirDate: DateTime(2018, 05, 02),
    genreIds: [10759, 18],
    id: 77169,
    name: "Cobra Kai",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Cobra Kai",
    overview:
        "This Karate Kid sequel series picks up 30 years after the events of the 1984 All Valley Karate Tournament and finds Johnny Lawrence on the hunt for redemption by reopening the infamous Cobra Kai karate dojo. This reignites his old rivalry with the successful Daniel LaRusso, who has been working to maintain the balance in his life without mentor Mr. Miyagi.",
    popularity: 3190.743,
    posterPath: "/6POBWybSBDBKjSs1VAQcnQC1qyt.jpg",
    voteAverage: 8.1,
    voteCount: 4010,
  );
  final tTVList = <TV>[tTV];

  _arrangeUsecase() {
    when(mockGetTVDetail.execute(tId))
        .thenAnswer((_) async => Right(testTVDetail));
    when(mockGetTVRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTVList));
  }

  group('TV Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();

      // act
      await provider.fetchTVDetail(tId);

      // assert
      verify(mockGetTVDetail.execute(tId));
    });

    test('should change state to loading when usecase is called', () async {
      // arrange
      _arrangeUsecase();

      // act
      provider.fetchTVDetail(tId);

      // assert
      expect(provider.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();

      // act
      await provider.fetchTVDetail(tId);

      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.tv, testTVDetail);
      expect(listenerCallCount, 3);
    });

    test('should change tv recommendations when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();

      // act
      await provider.fetchTVDetail(tId);

      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvRecommendation, tTVList);
    });

    test('should change state to error when fetch data is failed', () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Fail')));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((realInvocation) async => Right(tTVList));

      // act
      await provider.fetchTVDetail(tId);

      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Fail');
      expect(listenerCallCount, 2);
    });
  });

  group('Get TV Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();

      // act
      await provider.fetchTVDetail(tId);

      // assert
      verify(mockGetTVRecommendations.execute(tId));
      expect(provider.tvRecommendation, tTVList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();

      // act
      await provider.fetchTVDetail(tId);

      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvRecommendation, tTVList);
    });

    test('should update error message when request failed', () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));

      // act
      await provider.fetchTVDetail(tId);

      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });
}
