import 'dart:convert';
import 'package:core/data/models/tv_model.dart';
import 'package:core/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

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
  final tTVResponseModel = TVResponse(tvList: <TVModel>[tTVModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      //arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv/popular.json'));

      //act
      final result = TVResponse.fromJson(jsonMap);

      //assert
      expect(result, tTVResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tTVResponseModel.toJson();

      // assert
      final expectedJson = {
        'results': [
          {
            "backdrop_path": "/35SS0nlBhu28cSe7TiO3ZiywZhl.jpg",
            "first_air_date": "2018-05-02",
            "genre_ids": [10759, 18],
            "id": 77169,
            "name": "Cobra Kai",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "Cobra Kai",
            "overview":
                "This Karate Kid sequel series picks up 30 years after the events of the 1984 All Valley Karate Tournament and finds Johnny Lawrence on the hunt for redemption by reopening the infamous Cobra Kai karate dojo. This reignites his old rivalry with the successful Daniel LaRusso, who has been working to maintain the balance in his life without mentor Mr. Miyagi.",
            "popularity": 3190.743,
            "poster_path": "/6POBWybSBDBKjSs1VAQcnQC1qyt.jpg",
            "vote_average": 8.1,
            "vote_count": 4010
          }
        ]
      };

      expect(result, expectedJson);
    });
  });
}
