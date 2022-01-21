import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVRecommendations usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVRecommendations(mockTVRepository);
  });

  final tTV = <TV>[];

  group('getTVRecommendations Tests', () {
    group('execute', () {
      final tId = 85552;
      test(
          'should get list recommendation of tv from the repo when execute function is called',
          () async {
        // arrange
        when(mockTVRepository.getTVRecommendations(tId))
            .thenAnswer((_) async => Right(tTV));

        // act
        final result = await usecase.execute(tId);

        // assert
        expect(result, Right(tTV));
      });
    });
  });
}
