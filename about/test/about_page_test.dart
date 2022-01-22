import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('should show dicoding logo in the center',
      (WidgetTester tester) async {
    final dicodingLogoCenter = find.byType(Image);

    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    expect(dicodingLogoCenter, findsOneWidget);
  });

  testWidgets('should display paragraph', (WidgetTester tester) async {
    final text = find.text(
        'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.');
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    expect(text, findsOneWidget);
  });
}
