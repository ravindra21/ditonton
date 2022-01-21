import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:core/presentation/bloc/popular_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTV])
void main() {
  late MockGetPopularTV mockGetPopularTV;
  late PopularTvBloc popularTvBloc;

  setUp(() {
    mockGetPopularTV = MockGetPopularTV();
    popularTvBloc = PopularTvBloc(getPopularTv: mockGetPopularTV);
  });
  test('initial state should be empty', () async {
    expect(popularTvBloc.state, PopularTvEmpty());
  });

  blocTest<PopularTvBloc, PopularTvState>(
    'should emit [loading, hasData] when data successfully fetch',
    build: () {
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Right(testTVList));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () => [
      PopularTvLoading(),
      PopularTvHasData(tv: testTVList),
    ],
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'should emit [loading, error] when data failed to fetch',
    build: () {
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularTvBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () => [
      PopularTvLoading(),
      const PopularTvError('Server Failure'),
    ],
  );
}
