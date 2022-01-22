import 'dart:convert';

import 'package:core/common/exception.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../json_reader.dart';
import 'tv_remote_data_source_test.mocks.dart';

Future<IOClient> fc(IOClient client) async {
  return client;
}

@GenerateMocks([IOClient])
void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSource;
  late MockIOClient mockClient;

  setUp(() {
    mockClient = MockIOClient();
    dataSource = TVRemoteDataSourceImpl(ioClient: fc(mockClient));
  });

  group('get popular tv series', () {
    final tTVList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv/popular.json')))
            .tvList;

    test('should return list of tv series when response is success (200)',
        () async {
      // arrange
      when(mockClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/popular.json'), 200));

      //act
      final result = await dataSource.getPopularTV();

      //assert
      expect(result, tTVList);
    });

    test('should throw a ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final result = dataSource.getPopularTV(); // no await

      // assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series detail', () {
    const tId = 1;
    final tTVDetail = TVDetailModel.fromJson(
        json.decode(readJson('dummy_data/tv/tv_detail.json')));

    test('should return tv series when response code is 200', () async {
      // arrange
      when(mockClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY'))).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv/tv_detail.json'), 200));

      // act
      final result = await dataSource.getTVDetail(tId);

      // assert
      expect(result, equals(tTVDetail));
    });

    test('should throw Server Exception when response code is 404 or other',
        () async {
      // arrange
      when(mockClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final result = dataSource.getTVDetail(tId);

      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('get recommendation tv series', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv/recommendations.json')))
        .tvList;
    const tId = 85552;

    test(
        'should return list of tv series recommendation when response is success (200)',
        () async {
      // arrange
      when(mockClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv/recommendations.json'), 200));

      //act
      final result = await dataSource.getTVRecommendations(tId);

      //assert
      expect(result, tTVList);
    });

    test('should throw a ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final result = dataSource.getTVRecommendations(tId); // no await

      // assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('get on air tv', () {
    final tTVList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv/popular.json')))
            .tvList;

    test('should return list of tv series when response is success (200)',
        () async {
      // arrange
      when(mockClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/popular.json'), 200));

      //act
      final result = await dataSource.getNowPlayingTV();

      //assert
      expect(result, tTVList);
    });

    test('should throw a ServerException when response code is 404 or other',
        () async {
      // arrange
      when(mockClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // act
      final result = dataSource.getNowPlayingTV(); // no await

      // assert
      expect(() => result, throwsA(isA<ServerException>()));
    });
  });

  group('search tv', () {
    final tSearchResult = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv/search_spiderman_tv.json')))
        .tvList;
    const tQuery = 'spiderman';

    test('should return list of tv when response code is 200', () async {
      // arrange
      when(mockClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv/search_spiderman_tv.json'), 200));
      // act
      final result = await dataSource.searchTV(tQuery);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTV(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv/top_rated.json')))
        .tvList;

    test('should return list of tv when response code is 200 ', () async {
      // arrange
      when(mockClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv/top_rated.json'), 200));
      // act
      final result = await dataSource.getTopRatedTV();
      // assert
      expect(result, tTVList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTV();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
