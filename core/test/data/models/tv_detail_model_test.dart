import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTVDetailModel = TVDetailModel(
      adult: false,
      backdropPath: "/path.jpg",
      firstAirDate: "2020-05-05",
      genres: [GenreModel(id: 1, name: "Action")],
      id: 1,
      name: "Title",
      originalName: "Original Title",
      overview: "Overview",
      posterPath: "/path.jpg",
      voteAverage: 1.0,
      voteCount: 1);

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
      voteCount: 1);

  test('should return subclass of TVDetail entity', () async {
    final result = tTVDetailModel.toEntity();

    expect(result, tTVDetail);
  });
}
