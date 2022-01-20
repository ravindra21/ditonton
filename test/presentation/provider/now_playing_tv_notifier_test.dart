import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:core/presentation/provider/now_playing_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV])
void main() {
  late MockGetNowPlayingTV mockGetNowPlayingTV;
  late NowPlayingTVNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    notifier = NowPlayingTVNotifier(mockGetNowPlayingTV)
      ..addListener(() {
        listenerCallCount++;
      });
  });

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
      voteCount: 4010);

  final tTVList = <TV>[tTV];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetNowPlayingTV.execute()).thenAnswer((_) async => Right(tTVList));

    // act
    notifier.fetchNowPlayingTV();

    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv data when data is gotten successfully', () async {
    // arrange
    when(mockGetNowPlayingTV.execute()).thenAnswer((_) async => Right(tTVList));

    // act
    await notifier.fetchNowPlayingTV();

    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tv, tTVList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetNowPlayingTV.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    // act
    await notifier.fetchNowPlayingTV();

    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
