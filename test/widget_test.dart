// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('MyApp displays the portfolio homepage', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    final apiClient = ApiClient(
      client: MockClient((_) async => http.Response('[]', 200)),
    );
    await tester.pumpWidget(MyApp(apiClient: apiClient));

    // Verify that the portfolio home screen is displayed.
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);

    // Verify that counter boilerplate is not part of this app.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
  });
}
