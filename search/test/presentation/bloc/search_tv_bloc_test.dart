import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:search/presentation/bloc/search_tv_bloc.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTV])
void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTV mockSearchTV;

  setUp(() {
    mockSearchTV = MockSearchTV();
    searchTvBloc = SearchTvBloc(mockSearchTV);
  });

  const tQuery = 'superman';

  final testTV = TV(
    backdropPath: '/35SS0nlBhu28cSe7TiO3ZiywZhl.jpg',
    firstAirDate: DateTime(2018, 05, 02),
    genreIds: const [10759, 18],
    id: 77169,
    name: "Cobra Kai",
    originCountry: const ["US"],
    originalLanguage: "en",
    originalName: "Cobra Kai",
    overview:
        "This Karate Kid sequel series picks up 30 years after the events of the 1984 All Valley Karate Tournament and finds Johnny Lawrence on the hunt for redemption by reopening the infamous Cobra Kai karate dojo. This reignites his old rivalry with the successful Daniel LaRusso, who has been working to maintain the balance in his life without mentor Mr. Miyagi.",
    popularity: 3190.743,
    posterPath: "/6POBWybSBDBKjSs1VAQcnQC1qyt.jpg",
    voteAverage: 8.1,
    voteCount: 4010,
  );

  final testTVList = [testTV];
  test('initial state must be empty', () {
    expect(searchTvBloc.state, SearchTvEmpty());
  });

  blocTest<SearchTvBloc, SearchTvState>(
      'should emit [loading, hasData] when fetch data is success',
      build: () {
        when(mockSearchTV.execute(tQuery))
            .thenAnswer((_) async => Right(testTVList));

        return searchTvBloc;
      },
      wait: const Duration(milliseconds: 500),
      act: (bloc) {
        bloc.add(const OnQueryChanged(tQuery));
      },
      expect: () => [
            SearchTvLoading(),
            SearchTvHasData(testTVList),
          ],
      verify: (bloc) => verify(mockSearchTV.execute(tQuery)));

  blocTest<SearchTvBloc, SearchTvState>(
    'should return [loading,error] when fetch is fail',
    build: () {
      when(mockSearchTV.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Fail')));
      return searchTvBloc;
    },
    wait: const Duration(milliseconds: 500),
    act: (bloc) {
      bloc.add(const OnQueryChanged(tQuery));
    },
    expect: () => [SearchTvLoading(), const SearchTvError('Server fail')],
    verify: (bloc) => verify(mockSearchTV.execute(tQuery)),
  );
}
