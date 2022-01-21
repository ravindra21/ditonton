import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:core/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTV])
void main() {
  late MockGetTopRatedTV mockGetTopRatedTV;
  late TopRatedTvBloc topRatedTvBloc;

  setUp(() {
    mockGetTopRatedTV = MockGetTopRatedTV();
    topRatedTvBloc = TopRatedTvBloc(getTopRatedTv: mockGetTopRatedTV);
  });

  group('top rated tv bloc', () {
    test('initial state should be empty', () async {
      expect(topRatedTvBloc.state, TopRatedTvEmpty());
    });

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit [loading, hasData] when data successfully fetch',
      build: () {
        when(mockGetTopRatedTV.execute())
            .thenAnswer((_) async => Right(testTVList));
        return topRatedTvBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        TopRatedTvLoading(),
        TopRatedTvHasData(tv: testTVList),
      ],
    );

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit [loading, error] when data failed to fetch',
      build: () {
        when(mockGetTopRatedTV.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedTvBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        TopRatedTvLoading(),
        const TopRatedTvError('Server Failure'),
      ],
    );
  });
}
