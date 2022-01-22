import 'package:core/presentation/bloc/home_detail_bloc.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([HomeDetailBloc])
void main() {
  late MockHomeDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockHomeDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<HomeDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => Stream.value(HomeDetailHasData(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        watchlisStatus: false,
        message: '')));
    when(mockBloc.state).thenReturn(HomeDetailHasData(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        watchlisStatus: false,
        message: ''));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => Stream.value(HomeDetailHasData(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        watchlisStatus: true,
        message: '')));
    when(mockBloc.state).thenReturn(HomeDetailHasData(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        watchlisStatus: true,
        message: ''));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => Stream.value(HomeDetailHasData(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        watchlisStatus: false,
        message: '')));
    when(mockBloc.state).thenReturn(HomeDetailHasData(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        watchlisStatus: false,
        message: ''));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when remove to watchlist',
      (WidgetTester tester) async {
    when(mockBloc.stream).thenAnswer((_) => Stream.value(HomeDetailHasData(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        watchlisStatus: true,
        message: '')));
    when(mockBloc.state).thenReturn(HomeDetailHasData(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        watchlisStatus: true,
        message: ''));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from watchlist'), findsOneWidget);
  });
}
