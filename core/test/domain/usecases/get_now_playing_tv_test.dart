import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetNowPlayingTV(mockTVRepository);
  });

  final tTV = <TV>[];

  group('getNowPlayingTV Tests', () {
    group('execute', () {
      test(
          'should get list of tv from the repo when execute function is called',
          () async {
        // arrange
        when(mockTVRepository.getNowPlayingTV())
            .thenAnswer((_) async => Right(tTV));

        // act
        final result = await usecase.execute();

        // assert
        expect(result, Right(tTV));
      });
    });
  });
}
