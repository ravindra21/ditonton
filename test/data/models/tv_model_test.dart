import 'package:core/data/models/tv_model.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVModel = TVModel(
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

  test('should be a subclass of TV entity', () async {
    final result = tTVModel.toEntity();
    expect(result, tTV);
  });
}
