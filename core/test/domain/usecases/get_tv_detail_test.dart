import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTVRepository mockTVRepository;
  late GetTVDetail usecase;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVDetail(mockTVRepository);
  });

  final int tId = 1;

  final tTVDetail = TVDetail(
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

  test('should get tv detail object from the repository', () async {
    //arrange
    when(mockTVRepository.getTVDetail(tId))
        .thenAnswer((_) async => Right(tTVDetail));

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, Right(tTVDetail));
  });
}
